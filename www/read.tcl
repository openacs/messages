ad_page_contract {
    Read the messages.

    @author pedro@viaro.net
    @creation-date 2009-11-13
    @cvs-id $Id$
} {
    {msg_id ""}
}

set general_parent_id $msg_id
set community_id [dotlrn_community::get_community_id]
set user_id [ad_conn user_id]
set color "#C0C0C0"
set msg_id_list [list]
db_dml update_status {}

db_foreach get_msg_ids {} {
    lappend msg_id_list $msg_id
}

if { [llength $msg_id_list] > 0 } {
    set msg_ids [join $msg_id_list ","]
} else {
    set msg_ids ""
}

db_foreach get_contacts_ids {} {
   set contacts_ids_array($msg_id) $contacts
}

db_foreach get_contacts_ids_roles {} {
   set contacts_ids_array_roles($msg_id) $contacts
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
    append rel_type_case "when rel_type = '$rel_type' then '$pretty_name' "
}
append rel_type_case " end"
###

db_multirow -extend { rel_type_user to first_name_contacts name_user total_recipients contact_names download_file ansi_time } messages get_messages_info { *SQL* } {
    ##Roles: se estable los roles que existen y se obtienen lo usuarios y sus roles
    set rel_type_user [lang::util::localize [db_string get_members_ids_rel_type {}]]

    ###
    set name_user [acs_user::get_element -user_id $owner_id -element name]
    set download_file ""
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
            append download_file "<img width=20 height=20 src=\"/resources/messages/attachment.png\"/><a style=\"font-size: 8pt\" target=\"_blank\"  href=\"view/$title?file%5fid=$attachment_item_id\"> \
                                    [messages::string_truncate_middle -len 15 -string $title]</a><br>"
        }

    } else {
        set download_file ""
    }

    set contact_names ""
    set first_name_contacts ""
    if { [array exists contacts_ids_array] != -1 } {
        if { [lsearch [array name contacts_ids_array] $msg_id] == -1 }  {
            set contact_list ""
        } else {
            set contact_list [split $contacts_ids_array($msg_id) ","]
        }
    } else {
        set contact_list ""
    }


    set total_recipients [llength $contact_list]
    set name_to_p 0
    foreach party_id $contact_list {
        if { ![empty_string_p $party_id] } {
            set name [acs_user::get_element -user_id $party_id -element name] 
            if {$party_id == $owner_id}  {
                     append contact_names $name ",<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
            } else {
                set name_to_p 1
                append first_name_contacts [string range $name 0 [expr [string first " " $name 0] - 1]] ", "
                append contact_names $name ",<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
            }
        }
    }
    set rel_types [db_list get_rel_types {}]
    set rel_types_checked [join $rel_types ","]
    foreach rel_type $rel_types { 
        set pretty_name [dotlrn_community::get_role_pretty_plural -rel_type $rel_type]
        append first_name_contacts $pretty_name ", "
        append contact_names $pretty_name ",<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
    }
    if { $name_to_p } {
        set to [string tolower [_ messages.to] 0 1]
    } else {
        set to ""
    }
    set first_name_contacts [string range $first_name_contacts 0 [expr [string length $first_name_contacts] - 3]]
    set contact_names [string range $contact_names 0 [expr [string length $contact_names] - 60]]
    set cur_time [clock format [clock seconds] -format "%Y %m %d"]
    set sent_time_seconds [clock format [clock scan $sent_date] -format "%Y %m %d"]]
    set day_recive [lc_time_fmt $sent_date "%d %b, %Y" ]
    set ansi_time "$day_recive - $time"
    set msg_content [template::util::richtext::get_property contents $msg_content]
    if { [lindex $cur_time 0] > [lindex $sent_time_seconds 0]} {
        set date [lc_time_fmt $sent_date "%D"]
    } else {
        if { ([lindex $cur_time 1] >= [lindex $sent_time_seconds 1]) && ([lindex $cur_time 2] == [lindex $sent_time_seconds 2] ) } {
            set date [_ messages.today]
        } else {
            set date [lc_time_fmt $sent_date "%d %b" ]
        }
    }
}