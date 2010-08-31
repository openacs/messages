ad_page_contract {
    Delete selected messages in the trash folder

    @author pedro@viaro.net
    @creation-date 2009-11-24
    @cvs-id $Id$
} {
   msg_ids
}

set folder_id [messages::get_folder_id -folder_name "trash"]
set community_id [dotlrn_community::get_community_id]
set user_id [ad_conn user_id]

db_transaction {
    db_dml delete_messages {}
} 
