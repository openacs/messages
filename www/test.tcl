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

set count_members [db_string count_members {}]

for {set i 0} { $i < $count_members} {set i [expr $i + 1500] } {
    ns_log notice ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ciclo for $i"
    set limit [expr $i + 1500]
    append contacts_list [join [db_list members { *SQL* }] ","]
}

ns_log notice ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> count_members $count_members"

