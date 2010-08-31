ad_page_contract {
    General page, list inbox, sent, draft, trash.

    @author pedro@viaro.net
    @creation-date 2009-11-13
    @cvs-id $Id$
} {
    {msg_ids ""}
    {folder_id ""}
} 

set user_id [ad_conn user_id]
set folder_id_sent [messages::get_folder_id -folder_name "sent"]
set community_id [dotlrn_community::get_community_id]
db_transaction {
    db_dml update_folder {}
}