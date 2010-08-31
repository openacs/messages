ad_page_contract {
    General page, list inbox, sent, draft, trash.

    @author pedro@viaro.net
    @creation-date 2009-11-12
    @cvs-id $Id$
} {
    {community_id ""}
    {page_number ""}
}

set page_title "[_ messages.folders]"
set context [list $page_title]
set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]

set contacts_list [util_memoize [list messages::get_community_users_fb -community_id $community_id] 86400]

db_multirow -extend { color total_new_msg} folders get_folders_user { *SQL* } {
    if { $folder_id == 0 } {
        set color "#C0C0C0"
    } else {
        set color "#FFFFFF"
    }
}

