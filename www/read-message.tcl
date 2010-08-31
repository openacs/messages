ad_page_contract {
    Read the messages.

    @author pedro@viaro.net
    @creation-date 2009-11-13
    @cvs-id $Id$
} {
    {msg_id ""}
    {folder_id ""}
    {page_number ""}
    {total_messages ""}
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set parents_ids [db_list_of_lists get_parents_ids {}]
set get_max_messages [db_string get_max_messages {} -default 25]
set permition_read [db_string exist_msg {} -default 0]

if { $permition_read == 0 } {
    set permition_read_p "f"
} else {
    set permition_read_p "t"
}

###########################################
#get message ids around the message view
#and set range messages, before or after message display acording to message view.
set msg_before [expr [lsearch $parents_ids $msg_id] - 2]
set msg_after [expr [lsearch $parents_ids $msg_id] + 2]
set parents_ids [lrange $parents_ids $msg_before $msg_after]
set newer_msg_id [lindex $parents_ids [expr [lsearch $parents_ids $msg_id] - 1]]
############################################
if {[empty_string_p $newer_msg_id]} {
    set newer_msg_id "-1"
}
set newest_msg_id [lindex $parents_ids [expr [lsearch $parents_ids $msg_id] - 2]]
if {[empty_string_p $newest_msg_id]} {
    set newest_msg_id "-1"
}
set older_msg_id [lindex $parents_ids [expr [lsearch $parents_ids $msg_id] + 1]]
if {[empty_string_p $older_msg_id]} {
    set older_msg_id "-1"
}
set oldest_msg_id [lindex $parents_ids [expr [lsearch $parents_ids $msg_id] + 2]]
if {[empty_string_p $oldest_msg_id]} {
    set oldest_msg_id "-1"
}

set number_total_pages [expr [expr ceil([expr [expr $total_messages + 0.0] / [expr $get_max_messages + 0.0]])] - 1]

if { !$number_total_pages } {
    set new_page_number 1
} else {
    set new_page_number [expr [format %0.0f [expr ceil([lsearch $parents_ids $msg_id]/ $get_max_messages)]] + 1]
}

db_0or1row data_msg { *SQL* }

if { [empty_string_p $subject] } {
    set subject "[_ messages.no_subject] "
}