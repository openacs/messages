ad_page_contract {
    Update numbers of new messages in the menu

    @author pedro@viaro.net
    @creation-date 2009-11-24
    @cvs-id $Id$
} {
   msg_ids
   option_select
}

set community_id [dotlrn_community::get_community_id]
set user_id [ad_conn user_id]
db_transaction {
    db_dml update_status_msg {}
}