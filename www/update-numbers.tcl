ad_page_contract {
    Update numbers of new messages in the menu

    @author pedro@viaro.net
    @creation-date 2009-11-17
    @cvs-id $Id$
} {

}

append not_folder_ids [messages::get_folder_id -folder_name "sent"] "," \
                      [messages::get_folder_id -folder_name "trash"]

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set folders_info [db_list_of_lists count_new_messages {}]
set numbers [list]
foreach folder $folders_info {
    lappend numbers [lindex $folder 0]
    lappend numbers [lindex $folder 1]
    lappend numbers [lindex $folder 2]
}

if { [llength $numbers] } {
    set numbers [join $numbers ","] 
} else {
    set numbers " "
}
