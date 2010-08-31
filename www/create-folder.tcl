ad_page_contract {
    Create a New folder.

    @author pedro@viaro.net
    @creation-date 2009-11-17
    @cvs-id $Id$
} {
    folder_name
} 

set user_id [ad_conn user_id]
set folder_id [db_nextval messages_folders_sequence]
set folder_name [string trim "$folder_name"]
#create a new folder but not is create when folder_name is empty or greater than 20 characteres.
if { [empty_string_p $folder_name]  || [string length $folder_name] > 20} {
    if { [empty_string_p $folder_name] } {
        set response "[_ messages.new_folder_name_error]"
    } else {
        set response "[_ messages.lt_folder_name_error]"
    }
} else {
    db_transaction {
        db_dml create_new_folder {}
    }
    set response [_ messages.sucsessful_create_folder]
}