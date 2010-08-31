ad_page_contract {
    Update the folder name

    @author pedro@viaro.net
    @creation-date 2010-01-19
    @cvs-id $Id$
} {
    {name ""}
    {delete "f"}
    folder_id
}

set user_id [ad_conn user_id]
set folder_id_inbox [messages::get_folder_id -folder_name "inbox"]
if { [string equal $delete "t"] } {
    db_transaction {
        db_dml update_messages { *SQL* }
        db_dml delete_folder { *SQL* }
    }
} elseif {![empty_string_p $name]} {
    db_transaction {
        db_dml update_name { *SQL* }
    }
}