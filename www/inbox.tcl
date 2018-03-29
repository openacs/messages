ad_page_contract {
    Inbox Page

    @author pedro@viaro.net
    @creation-date 2009-11-11
    @cvs-id $Id$
} {
    {folder_id ""}
    {page_number ""}
} 

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
if {[empty_string_p $page_number]} {
    set page_number 1
}

if {[empty_string_p $folder_id]} {
    set folder_id 0
}

#####################################################################
#get the total messages and calculate how many pages have in folder show
#First and last row are calculate based on the total messages show per page
set total_messages [db_string get_total_messages {} -default 0]
set show_messages [db_string get_max_show_msg {} -default 25]
#Round to the next integer because the las page include some messages.
set total_pages [expr ceil([expr [expr $total_messages + 0.0] / [expr $show_messages + 0.0]])]
set oldest_page [expr $total_pages - 1]
set count_messages 0
if { $page_number != 1} {
    set first_row [expr [expr [expr $page_number - 1] * $show_messages] + 1]
    set last_row [expr [expr $first_row + $show_messages] - 1]
} else {
    set first_row [expr [expr $page_number - 1] * $show_messages]
    set last_row [expr $first_row + $show_messages]
    set first_row [expr $first_row + 1]
}
######################################################################

set elements [list  msg_ids \
                [list label { <input type="checkbox" id="checkbox_general" name="_dummy" onclick="select_all(this.form,this.checked);" title="[_ acs-templating.lt_Checkuncheck_all_rows]">} \
                display_template {<input type="checkbox" id="check_box_msg.@messages.msg_id@" name="subject_id" value="@messages.msg_id@" id="msg_ids.@messages.msg_id@" title="[_ acs-templating.lt_Checkuncheck_this_row]" onclick="more_actions_select();">} \
                sub_class {narrow} \
                html { align center }] \
            ]

lappend elements contacts \
            [list html { align left style "font-size: smaller; width:20%"} \
                label [_ messages.from] \
                display_template { <a href="#@messages.msg_id@a${folder_id}a${page_number}" onclick="read_message(@messages.msg_id@,$folder_id,$page_number)"> <if @messages.new_p@>\
                                     <span id="new_p.@messages.msg_id@"><span id="new_p_style.@messages.msg_id@"  style="font-weight: bold;">@messages.contacts@ \
                                        <if $folder_id ne 1> (@messages.number_conversation@) </if></span>\
                                    </if><else><span id="new_p_style.@messages.msg_id@" style="font-weight:;">@messages.contacts@ (@messages.number_conversation@)</span></else></a>} \
            ] \
    rel_type \
        [list html { align left style "font-size: smaller; width:5%;"} \
            label "" \
                display_template { <if @messages.rel_type@ ne ""> \
                        <a href="#@messages.msg_id@a${folder_id}a${page_number}" style="background-color:#F06040;color:white;padding:2px;" onclick="read_message(@messages.msg_id@,$folder_id,$page_number)">@messages.rel_type@</a></if> } \
        ] \
    attachmet_mail \
        [list html { align center style "font-size: smaller; width:3%"} \
            label "" \
                display_template { <a href="#@messages.msg_id@a${folder_id}a${page_number}" onclick="read_message(@messages.msg_id@,$folder_id,$page_number)">\
                                    <if @messages.attachment_p@ gt 0><span style="font-weight: bold;"><img src="/resources/messages/attachment.png" width="20" height="20"></span> \
                                   </if></a>} \
        ] \
    subject_mail \
        [list html { align left style "font-size: smaller; width:62%"} \
            label [_ messages.subject] \
                display_template { <a href="#@messages.msg_id@a${folder_id}a${page_number}" onclick="read_message(@messages.msg_id@,$folder_id,$page_number)">\
                                    <if @messages.new_p@><span id="new_p_sub.@messages.msg_id@" style="font-weight: bold;">@messages.subject_mail@</span> \
                                   </if><else><span id="new_p_sub.@messages.msg_id@" style="font-weight:;">@messages.subject_mail@</span></else></a>} \
        ] \
    date \
        [list html { align left style "font-size: smaller;width:12%"} \
            label [_ messages.date] \
                display_template { <a href="#@messages.msg_id@a${folder_id}a${page_number}" onclick="read_message(@messages.msg_id@,$folder_id,$page_number)">\
                                    <if @messages.new_p@><span id="new_p_date.@messages.msg_id@" style="font-weight: bold;">@messages.date@</span> \
                                    </if><else><span id="new_p_date.@messages.msg_id@" style="font-weight:;">@messages.date@</span></else></a>} \
        ]

template::list::create \
    -name messages \
    -multirow messages \
    -main_class "list-table" \
    -html { width=100% } \
    -orderby_name orderby \
    -no_data "[_ messages.no_messages_found]" \
    -elements $elements 


set msg_id_list [list]
set last_msg_ids_list [list]
db_foreach get_msg_ids { *SQL* } {
    set last_msg_ids_array($msg_id) $last_msg_id
    lappend last_msg_ids_list $last_msg_id
    lappend msg_id_list $msg_id
}

set msg_ids [join $msg_id_list ","]
set last_msg_ids [join $last_msg_ids_list ","]

if { [empty_string_p $msg_ids] } {
    set msg_ids 0
}

if { [empty_string_p $last_msg_ids] } {
    set last_msg_ids 0
}

db_foreach get_attachment_p { } {
   set get_attachment_array($parent_id) $count_attachment
}

db_foreach get_new_p {} {
   set new_p_array($parent_id) $new_p
}

db_foreach get_msg_info {} {
    set msg_content_array($parent_id) $msg_content
    set date_sent_array($parent_id) $sent_date_ansi
}

##Roles: se estable los roles que existen y se obtienen lo usuarios y sus roles
set roles [dotlrn_community::get_roles -community_id $community_id]
set rel_types [list]
foreach role $roles {
    lappend rel_types [lindex $role 0]
}
set rel_types [join $rel_types "','"]
set rel_type_case "case "
foreach {rel_type role pretty_name pretty_plural} [eval concat $roles] {
    if { [string equal $rel_type "dotlrn_student_rel"] } {
        append rel_type_case "when rel_type = '$rel_type' then '' "
    } else {
        append rel_type_case "when rel_type = '$rel_type' then '$pretty_name' "
    }
}
append rel_type_case " end"

###

foreach msg_id $msg_id_list {
    set contacts_ids [db_list get_contacts {}]
    set owner_id [db_string get_owner_id {}]
    set member_ids_rel_type($owner_id) [db_string get_members_ids_rel_type {}]
    if { [llength $contacts_ids] > 1} {
        set contacts ""
        foreach contact_id $contacts_ids {
            append contacts [db_string get_name {}] ","
        }
        set contacts [string range $contacts 0 end-1]
        set msg_contacts($msg_id) $contacts
    }     
}

db_multirow -extend { rel_type subject_mail date attachment_p new_p} messages get_messages { *SQL* } {
    if { [info exists get_attachment_array($msg_id)]} {
        set attachment_p $get_attachment_array($msg_id)
    } else {
        set attachment_p 0
    }
    if { [info exists member_ids_rel_type($owner_id)]} {
        set rel_type [lang::util::localize $member_ids_rel_type($owner_id)] 
    } else {
        set rel_type ""
    }

    if { [info exists msg_contacts($msg_id)]} {
        set contacts $msg_contacts($msg_id)
    }
    set msg_content $msg_content_array($msg_id)
    set sent_date_ansi $date_sent_array($msg_id)
    set content [ad_html_to_text [template::util::richtext::get_property contents $msg_content]]
    if { [empty_string_p $subject] } {
        set subject "[_ messages.no_subject] "
    }
    append subject_mail $subject "-" [string_truncate -len 80 -ellipsis "..." " $content"]
    set cur_time [clock format [clock seconds] -format "%Y %m %d"]
    set sent_time_seconds [clock format [clock scan $sent_date_ansi] -format "%Y %m %d"]
    #compare the sent date with the current date and display the message according to the date.
    if { [lindex $cur_time 0] > [lindex $sent_time_seconds 0]} {
        set date [lc_time_fmt $sent_date_ansi "%D"]
    } else {
        if {[lindex $cur_time 1] >= [lindex $sent_time_seconds 1] && [lindex $cur_time 2] == [lindex $sent_time_seconds 2]} {
            set date [_ messages.today]
        } else {
            set date [lc_time_fmt $sent_date_ansi "%d,%b,%Y %H:%M"]
        }
    }
    if { [info exists new_p_array($msg_id)]} {
        set new_p $new_p_array($msg_id)
    } else {
        set new_p 0
    }
    incr count_messages
}

set last_number [expr [expr $count_messages + $first_row] - 1]
