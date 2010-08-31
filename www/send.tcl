ad_page_contract {
    Send the message with attachment to users in the community.

} {
    {msg_id "" }
    {subject ""}
    {contacts_ids ""}
    {total_attachment 0}
    {reply ""}
    {reply_p 0}
    {general_parent_id ""}
    {rel_types:multiple "" }
    {reply_option ""}
}

set page_title "[_ messages.messages]"
set context [list "[_ messages.compose_mail]"]
set community_id [dotlrn_community::get_community_id]
set rel_types_html ""
set owner_id [ad_conn user_id]
set package_id [ad_conn package_id]
set admin_p [permission::permission_p -party_id $owner_id -object_id $package_id -privilege admin]
#Set file javascript to members functions
if { $reply_p == 1 } {
    set action_send "send-mail"
    #when send message reply
    set member_js "show_members_rol_index"
} else {
    set action_send "send"
    #When send a new message
    set member_js "show_members_rol"
}

set roles [dotlrn_community::get_roles -community_id $community_id]
if { $admin_p } {
    foreach {rel_type role pretty_name pretty_plural} [eval concat $roles] {
        if {![string equal $rel_type "dotlrn_student_rel"]} {
            append rel_types_html "<input type=\"checkbox\" value=\"$rel_type\" name=\"rel_types\" id=\"$rel_type\"> <a onclick=\"${member_js}('$rel_type')\"><img src=\"/resources/messages/add.png\"></a> [lang::util::localize $pretty_plural] |"
        } else {
            append rel_types_html "<input type=\"checkbox\" value=\"$rel_type\" name=\"rel_types\" id=\"$rel_type\" onclick=\"${member_js}(this.id,this.checked)\">  [lang::util::localize $pretty_plural] |"
        }
    }
    append rel_types_html "<input type=\"checkbox\" value=\"[_ messages.send_to_all]\" name=\"rel_types_all\" onclick=\"select_all_rel_types(this.checked);\"> [_ messages.send_to_all]"
} else {
    foreach {rel_type role pretty_name pretty_plural} [eval concat $roles] {
        if {[string equal $rel_type "dotlrn_ca_rel"] || [string equal $rel_type "dotlrn_instructor_rel"] } {
            if {![string equal $rel_type "dotlrn_student_rel"]} {
                append rel_types_html "<input type=\"checkbox\" value=\"$rel_type\" name=\"rel_types\" id=\"$rel_type\"> <a onclick=\"${member_js}('$rel_type')\"><img src=\"/resources/messages/add.png\"></a> [lang::util::localize $pretty_plural] |"
            } else {
                append rel_types_html "<input type=\"checkbox\" value=\"$rel_type\" name=\"rel_types\" id=\"$rel_type\" onclick=\"${member_js}(this.id,this.checked)\">  [lang::util::localize $pretty_plural] |"
            }
        }
    }
}

if {![exists_and_not_null show_master_p]} {
    set show_master_p 1
    set reply_send 0
} else {
    set reply_send 1
}

if {![exists_and_not_null option]} {
    set option ""
}

set community_id [dotlrn_community::get_community_id]
if { !$reply_p } {
    set contacts_list [util_memoize [list messages::get_community_users_fb -community_id $community_id] 86400]
}

set signature_p [db_string signature_p {} -default 0]

if { $signature_p } {
    set signature [db_string get_signature {}]
    set signature [ad_html_to_text [lindex $signature 0]]
    set signature "<div id=signature><font color=\"#888888\"> &#45;&#45; <br> $signature</font></div>"
} else {
    set signature ""
}

if { [empty_string_p $signature] } {
    set signature ""
} else {
    set signature [string trim $signature]
}

set attachment [db_list_of_lists get_attachment_id {}]
if { [llength $attachment] != 0} {
    foreach attachment_info $attachment {
        set attachment_id [lindex $attachment_info 0]
        set attachment_item_id [lindex $attachment_info 1]
        db_1row get_sol_info { *SQL* }
        set position [string first . "$content" 1]
        if { $position == "-1" } {
            set position [string length $content]
        }
        append download_file "<input type=checkbox checked name=attachment_checkbox id=${attachment_id}>[string range $title 0 [expr $position - 1]]<br>"
    }
} else {
    set download_file ""
}

set fs_package_id [dotlrn_community::get_package_id_from_package_key -package_key file-storage -community_id $community_id]
set fs_folder_id [fs::get_root_folder -package_id $fs_package_id]
set attachment_item_id ""

set history_conversation [messages::get_history_conversation -parent_id $general_parent_id -msg_id $msg_id -user_id $owner_id]
set content_message_conversation "<br>$history_conversation $signature"

if { ![string equal $reply_option "forward"] } {
    set content_message_conversation "<p>&nbsp;</p><p>&nbsp;</p> $signature"
}

ad_form -html { enctype multipart/form-data } -export { signature } -name compose_message -form {
    {message:richtext(richtext),optional,nospell {label ""} {options {width "99%"}} {value "[list \"$content_message_conversation\" \"text/html\"]"}
        {html {id "comments" rows 25 cols 50 onload "loadEditors('advancedMessagesEditor'); return false;"}} 
    }
} -on_submit {
    set count_attachment [expr $total_attachment + 1]
    if { ![exists_and_not_null parent_id] }  {
        set parent_id ""
    }

    set base_url [dotlrn_community::get_community_url $community_id]
    set message_url [export_vars -base "${base_url}messages/messages"]
    set msg_id [messages::send_mail -parent_id $parent_id -count_attachment $count_attachment \
    -contacts_ids $contacts_ids -community_id $community_id \
    -owner_id $owner_id  -subject $subject -message $message -message_url $message_url -rel_types $rel_types]

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
                    set filename ${x}_$upload_file
                }
                set community_id [dotlrn_community::get_community_id]
                set package_id [dotlrn_community::get_package_id_from_package_key -package_key messages -community_id $community_id]
                set title [template::util::file::get_property filename $upload_file]
                set item_id [db_nextval acs_object_id_seq]
                set item_name "${item_id}-${title}"
                set mime_type [cr_filename_to_mime_type -create $title]
                set folder_id [content::item::get_id -item_path "messages_attachments_${package_id}" -resolve_index f]
                set creation_user [ad_conn user_id]
                set creation_ip [ad_conn peeraddr]
                # set storage_type to its default value according to a db constraint
                set storage_type file
                set attachment_item_id [content::item::new \
                                -item_id $item_id \
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
} -after_submit {
    ad_returnredirect "messages"
    ad_script_abort
}

template::head::add_javascript -src "/resources/ajaxhelper/yui/yahoo-dom-event/yahoo-dom-event.js" -order "-1"
template::head::add_javascript -src "/resources/ajaxhelper/yui/yahoo/yahoo-min.js" -order "-14"
template::head::add_javascript -src "/resources/ajaxhelper/yui/element/element-beta-min.js" -order "-13"
template::head::add_javascript -src "/resources/ajaxhelper/yui/event/event-min.js" -order "-15"
template::head::add_javascript -src "/resources/ajaxhelper/yui/dom/dom-min.js" -order "-16"
template::head::add_javascript -src "/resources/ajaxhelper/yui/button/button-beta-min.js" -order "-17"
template::head::add_javascript -src "/resources/ajaxhelper/yui/utilities/utilities.js" -order "-18"
template::head::add_javascript -src "/resources/ajaxhelper/yui/history/history-beta-min.js" -order "-19"
template::head::add_javascript -src "/resources/messages/prototype.js" -order "2"
template::head::add_javascript -src "/resources/messages/effects.js" -order "3"
template::head::add_javascript -src "/resources/ajaxhelper/yui/dragdrop/dragdrop.js" -order "4"
template::head::add_javascript -src "/resources/messages/controls.js" -order "5"
template::head::add_javascript -src "/resources/messages/builder.js" -order "7"
template::head::add_javascript -src "/resources/messages/application.js" -order "8"
template::head::add_javascript -src "/resources/messages/messages.js" -order "10"
template::head::add_javascript -src "/resources/messages/message-attachment.js" -order "11"
template::head::add_css -href "/resources/messages/send.css"
template::head::add_javascript -src "/resources/ajaxhelper/yui/container/container-min.js"
template::head::add_css -href "/resources/ajaxhelper/yui/fonts/fonts-min.css"
template::head::add_css -href "/resources/ajaxhelper/yui/button/assets/skins/sam/button.css"
template::head::add_css -href "/resources/ajaxhelper/yui/container/assets/skins/sam/container.css"

template::head::add_javascript -src "/resources/ajaxhelper/yui/connection/connection-min.js"