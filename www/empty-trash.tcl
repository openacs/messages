ad_page_contract {
    Empty Trash

    @author pedro@viaro.net
    @creation-date 2010-01-22
    @cvs-id $Id$
} {

}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set folder_id [messages::get_folder_id -folder_name "trash"]
db_transaction {
    db_dml empty_trash {}
}