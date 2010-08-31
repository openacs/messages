ad_page_contract {
    Page send mail

    @author pedro@viaro.net
    @creation-date 2009-11-11
    @cvs-id $Id$
} {
    {msg_id ""}
    {subject ""}
    {parent_id ""}
    {contacts_ids ""}
    {total_attachment 0}
    {reply ""}
    {content_msg ""}
    {message:html ""}
    {attachment_item_id ""}
    {general_parent_id ""}
    {msg_id_old ""}
    {rel_types:multiple "" }
    {attachment_ids ""}
}

set community_id [dotlrn_community::get_community_id]
set owner_id [ad_conn user_id]
set community_name [dotlrn_community::get_community_name $community_id]
set contact_info ""
set rel_types_html ""
set fs_package_id [dotlrn_community::get_package_id_from_package_key -package_key file-storage -community_id $community_id]
set fs_folder_id [fs::get_root_folder -package_id $fs_package_id]
set attachment_item_id ""
set package_id [ad_conn package_id]
set admin_p [permission::permission_p -party_id $owner_id -object_id $package_id -privilege admin]

if { $admin_p } {
    set roles [dotlrn_community::get_roles -community_id $community_id]
    foreach {rel_type role pretty_name pretty_plural} [eval concat $roles] {
        append rel_types_html "<input type=checkbox value=\"$rel_type\" name=\"rel_types\" id=\"$rel_type\">  [lang::util::localize $pretty_plural] "
    }
    append rel_types_html "<input type=checkbox value=[_ messages.send_to_all] name=rel_types_all onclick=select_all_rel_types(this.checked)> [_ messages.send_to_all]"
}

ad_form -html { enctype multipart/form-data } -name compose_message -form { }

ad_form -extend -name compose_message -form  {

} -on_submit {
    set count_attachment [expr $total_attachment + 1]
    if { ![exists_and_not_null parent_id] }  {
        set parent_id ""
    }
    set base_url [dotlrn_community::get_community_url $community_id]
    set message_url [export_vars -base "${base_url}messages/messages"]
    set msg_id [messages::reply_mail -parent_id $parent_id -count_attachment $count_attachment \
	-contacts_ids $contacts_ids -community_id $community_id \
	-owner_id $owner_id -subject $subject -message $message -general_parent_id $general_parent_id \
        -message_url $message_url -msg_id_old $msg_id_old -attachment_ids $attachment_ids -rel_types $rel_types]

    for {set x 1} {$x < $count_attachment} {incr x} {
        set name_attachment "upload_file_${x}"
        ad_form -extend -name compose_message -form {
            {upload_file_$x:file,optional
                {label ""} 
            }
        } 
        set upload_file [set $name_attachment]
        if { ![empty_string_p $upload_file] }  {
        db_transaction {
                set attachment_item_id ""
                if { ![regexp {[^//\\]+$} $upload_file filename] } {
                    # no match
                    set filename $upload_file
                }
                set community_id [dotlrn_community::get_community_id]
                set package_id [dotlrn_community::get_package_id_from_package_key -package_key messages -community_id $community_id]
                set title [template::util::file::get_property filename $upload_file]
                set item_name "[clock seconds]-${title}"
                set mime_type [cr_filename_to_mime_type -create $title]
                set folder_id [content::item::get_id -item_path "messages_attachments_${package_id}" -resolve_index f]
                set creation_user [ad_conn user_id]
                set creation_ip [ad_conn peeraddr]
                # set storage_type to its default value according to a db constraint
                set storage_type file
                set attachment_item_id [content::item::new \
                                -parent_id $folder_id \
                                -name $item_name \
                                -context_id $package_id \
                                -content_type messages_attachments \
                                -mime_type $mime_type \
                                -storage_type $storage_type \
                                -creation_user $creation_user \
                                -creation_ip $creation_ip]

                set revision_id [content::revision::new  -item_id $attachment_item_id \
                                    -mime_type $mime_type  \
                                    -title $title \
                                    -content_type messages_attachments \
                                    -creation_user $creation_user  \
                                    -creation_ip $creation_ip \
                                    -attributes [list [list msg_id $msg_id]\
                                                        [list attachment_item_id $attachment_item_id] \
                                                ] ]

                content::item::set_live_revision -revision_id $revision_id
                if { ![empty_string_p $upload_file] }  {
                    set tmp_file [template::util::file::get_property tmp_filename $upload_file]
                    set content_length [file size $tmp_file]
                    # create the new item
                    set file_name [cr_create_content_file $attachment_item_id $revision_id $tmp_file]
                    db_dml set_file_content { *SQL* }
                }
            }
        }
    }
}