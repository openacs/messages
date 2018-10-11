ad_library {
    Procedures in the messages namespace.

    @creation-date 12-28-2009
    @author pedro@viaro.net
}

namespace eval messages {} 

ad_proc -public messages::send_mail { 
    -contacts_ids
    -community_id
    -owner_id 
    -subject
    {-message_url ""}
    {-parent_id ""}
    {-count_attachment 0}
    {-message ""}
    {-rel_types ""}
} { 
    Send mail to different users
} {
    set community_name [dotlrn_community::get_community_name $community_id]
    set user_id [ad_conn user_id]
    set user_name [acs_user::get_element -user_id $user_id -element name]
    if { ![exists_and_not_null parent_id] }  {
        set parent_id ""
    }
    db_transaction {
        set msg_id [db_nextval messages_msg_sequence]
        db_dml send_mail {}
    }
    
    if { ![empty_string_p $rel_types] } {
        set rel_types "'[join $rel_types "','"]'"
        set rel_types_user_ids_list [db_list get_rel_types_user_ids {}]
        if { [empty_string_p $contacts_ids] } {
            append contacts_ids_roles [join $rel_types_user_ids_list ","]
        } else {
            append contacts_ids_roles "," [join $rel_types_user_ids_list ","]
        }
    } else {
        set contacts_ids_roles ""
    }

    set party_id_list [lsort -unique [split $contacts_ids ","]]
    if { ![empty_string_p $contacts_ids_roles] } {
        set party_id_list_roles [lsort -unique [split $contacts_ids_roles ","]]
    } else {
        set party_id_list_roles [list]
    }
   
    foreach party_id $party_id_list {
        set email_user [acs_user::get_element -user_id $party_id -element email]
        set package_id [dotlrn_community::get_package_id_from_package_key -package_key kernel -community_id 0]
        set from_addr [parameter::get -parameter "OutgoingSender" -package_id $package_id]
	## E-mail notification is disabled by default, to enable just uncomment the following line in every place in this file
        #acs_mail_lite::send -send_immediately -to_addr $email_user -from_addr $from_addr -subject [encoding convertto iso8859-15 [_ messages.subject_mail]] -body [_ messages.body_mail]
        db_dml recipients {}
        db_dml user_messages {}
    }
    if { ![empty_string_p $rel_types] } {
        foreach party_id $party_id_list_roles {
            if { [lsearch $party_id_list $party_id] == -1 && ![empty_string_p $party_id]} {
                set email_user [acs_user::get_element -user_id $party_id -element email]
                set package_id [dotlrn_community::get_package_id_from_package_key -package_key kernel -community_id 0]
                set from_addr [parameter::get -parameter "OutgoingSender" -package_id $package_id]
		## E-mail notification is disabled by default, to enable just uncomment the following line in every place in this file
                #acs_mail_lite::send -send_immediately -to_addr $email_user -from_addr $from_addr -subject [encoding convertto iso8859-15 [_ messages.subject_mail]] -body [_ messages.body_mail]
                db_dml user_messages {}
            }
        }
        set rel_types [split $rel_types ","]
        foreach rel_type $rel_types {
            db_dml recipients_roles {}
        }

    }
    set save_sent_p [db_string get_save_sent {} -default 1]

    if { $save_sent_p } {
        db_dml sent_message {}
    }
    return $msg_id
    ad_script_abort
}

ad_proc -public messages::reply_mail { 
    -general_parent_id
    -contacts_ids
    -community_id
    -owner_id 
    -subject
    {-message_url ""}
    {-parent_id ""}
    {-count_attachment 0}
    {-message ""}
    {-msg_id_old ""}
    {-attachment_ids ""}
    {-rel_types ""}
} {
    Send reply, reply-all and forward mail to different users
} {
    set message [list "$message" "text/html"]
    set community_name [dotlrn_community::get_community_name $community_id]
    set user_id [ad_conn user_id]
    set user_name [acs_user::get_element -user_id $user_id -element name]
    #set subject [db_string get_subject {}]
    db_transaction {
        set msg_id [db_nextval messages_msg_sequence]
        if { !$general_parent_id } {
            set lang [string range [lang::conn::locale -package_id [ad_conn package_id]] 0 2]
            set subject "[_ messages.msg_subject_forward]: $subject"
            db_dml send_mail_forward {}
            if { ![empty_string_p $attachment_ids] } {
                set attachment_ids_clause "and attachment_id in ($attachment_ids)"
            } else {
                set attachment_ids_clause ""
            }
            set attachment_list [db_list_of_lists get_attachment_id { *SQL*}]
            foreach attachment $attachment_list {
                set attachment_id [lindex $attachment 0]
                set attachment_item_id [lindex $attachment 1]
                db_dml attachment_files {}
            }
           } else {
            set subject "[_ messages.msg_subject_reply]: $subject"
            if { [string equal $contacts_ids ""] } {
                set contacts_ids "$user_id"
            } else {
                append contacts_ids ",$user_id"
            }
            db_dml send_mail {}
        }
    }
    if { ![empty_string_p $rel_types] } {
        set rel_types "'[join $rel_types "','"]'"
        set rel_types_user_ids_list [db_list get_rel_types_user_ids {}]
        if { [empty_string_p $contacts_ids] } {
            append contacts_ids_roles [join $rel_types_user_ids_list ","]
        } else {
            append contacts_ids_roles "," [join $rel_types_user_ids_list ","]
        }
    } else {
        set contacts_ids_roles ""
    }
    set party_id_list [lsort -unique [split $contacts_ids ","]]
    set party_id_list_roles [lsort -unique [split $contacts_ids_roles ","]]
    foreach party_id $party_id_list {
        set email_user [acs_user::get_element -user_id $party_id -element email]
        set package_id [dotlrn_community::get_package_id_from_package_key -package_key kernel -community_id 0]
        set from_addr [parameter::get -parameter "OutgoingSender" -package_id $package_id]
	## E-mail notification is disabled by default, to enable just uncomment the following line in every place in this file
        #acs_mail_lite::send -send_immediately -to_addr $email_user -from_addr $from_addr -subject [encoding convertto iso8859-15 [_ messages.subject_mail]] -body [_ messages.body_mail]
        db_dml recipients {}
        if { !$general_parent_id } {
            db_dml user_messages_forward {}
        } else {
            db_dml user_messages {}
        }
    }
    if { ![empty_string_p $rel_types] } {
        foreach party_id $party_id_list_roles {
            if { [lsearch $party_id_list $party_id] == -1 && ![empty_string_p $party_id]} {
                set email_user [acs_user::get_element -user_id $party_id -element email]
                set package_id [dotlrn_community::get_package_id_from_package_key -package_key kernel -community_id 0]
                set from_addr [parameter::get -parameter "OutgoingSender" -package_id $package_id]
		## E-mail notification is disabled by default, to enable just uncomment the following line in every place in this file
                #acs_mail_lite::send -send_immediately -to_addr $email_user -from_addr $from_addr -subject [encoding convertto iso8859-15 [_ messages.subject_mail]] -body [_ messages.body_mail]
                if { !$general_parent_id } {
                    db_dml user_messages_forward {}
                } else {
                    db_dml user_messages {}
                }
            }
        }
        set rel_types [split $rel_types ","]
        foreach rel_type $rel_types {
            db_dml recipients_roles {}
        }
    }
    set party_id [ad_conn user_id]
    set save_sent_p [db_string get_save_sent {} -default 1]
    if { $save_sent_p } {
        if { !$general_parent_id } {
            db_dml sent_message_forward {}
        } else {
            db_dml sent_message {}
        }
    }
    return $msg_id
    ad_script_abort
}

ad_proc -public messages::delete_trash_messages { 

} { 
    Delete all messages in the thash folder
} {
    set folder_id [messages::get_folder_id -folder_name "trash"]
    set limit_days_in_trash 15
    db_transaction {
        db_dml delete_messages {}
    }
}

ad_proc -public messages::get_folder_id { 
    -folder_name
} { 
    Get the folder id to standar folders to users.
} {
    switch $folder_name {
	inbox {
	    return 0
	}
	sent {
	    return 1
	}
	save {
	    return 2
	}
	trash {
	    return 3
	}
    }
}


ad_proc -public messages::get_history_conversation {
    -parent_id
    -msg_id
    -user_id
} {
    Get the history conversation until the message forward 
} {
    set blockquote_conversation_begin "<blockquote style='border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;'><br/><br/>"
    set blockquote_conversation_end "</blockquote>"
    set conversation "<br><div id=\"history_conversation\">"
    set count_messages 0
    append not_folder_ids [messages::get_folder_id -folder_name "sent"] "," \
                      [messages::get_folder_id -folder_name "trash"]
    db_multirow messages get_history_conversation { *SQL* } {
        set day_receive [lc_time_fmt $sent_date "%d %b, %Y" ]
        set ansi_time "$day_receive - $time"
        set msg_content [template::util::richtext::get_property contents $msg_content]
        append conversation "$blockquote_conversation_begin
                    El $day_receive, a las $time, [acs_user::get_element -user_id $owner_id -element name] escribio: <br><br>
                    $msg_content<br><br>"
        incr count_messages
    }
    for {set i 0} {$i <= $count_messages} {incr i} {
        append blockqoute_end $blockquote_conversation_end
    }
    append conversation "$blockqoute_end </div>"
    return $conversation
}

ad_proc -public messages::get_community_users_fb {
    -community_id
} {
    Memoize de members of the community
} {
    #Recipients are obtained and placed in the form autocomplete style
    set contacts_list [join [db_list members { *SQL* }] ","]
    return $contacts_list
}

ad_proc -public messages::string_truncate_middle {
    {-ellipsis "..."}
    {-len "100"}
    -string
} {
    cut middle part of a string in case it is too long copied from xotcl-request-monitor
} {
    set string [string trim $string]
    if {[string length $string]>$len} {
        set half [expr {($len-2)/2}]
        set left  [string trimright [string range $string 0 $half]]
        set right [string trimleft [string range $string end-$half end]]
        return $left$ellipsis$right
    }
    return $string

}

