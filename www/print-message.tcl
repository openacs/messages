ad_page_contract {
    Print the messages.

    @author pedro@viaro.net
    @creation-date 2009-11-13
    @cvs-id $Id$
} {
    {msg_id ""}
} 

set page_title "[_ messages.print]"
set context [list $page_title]
set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set contact_names [db_list_of_lists get_contact_names {}]

foreach contact $contact_names {
    if { [lsearch -exact $contact $user_id] } {
        set owner_name "[lindex $contact 0] <[lindex $contact 2]>"
        break
    }
}

db_0or1row data_msg { *SQL* }

set data_msg [db_list_of_lists get_data_msg {}]
set total_msg [llength $data_msg]

db_multirow -extend { contact_names ansi_time content} print get_data_msg { *SQL* } {
    set contact_list [db_list_of_lists get_contacts {}]
    set contact_names [list]
    foreach party_id $contact_list {
    	set contact_name [acs_user::get_element -user_id $party_id -element first_names]
        lappend contact_names $contact_name
    }
    set contact_names [join $contact_names ","]
    set day_recive [lc_time_fmt $sent_date "%d %b, %Y" ]
    set ansi_time "$day_recive - $time"
    set content [template::util::richtext::get_property content $msg_content]
}