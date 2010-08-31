<?xml version="1.0"?>
<queryset>

    <fullquery name="update_name">
        <querytext>
            update messages_folders set folder_name = :name where folder_id = :folder_id
        </querytext>
    </fullquery>

    <fullquery name="delete_folder">
        <querytext>
            delete from messages_folders where folder_id = :folder_id
        </querytext>
    </fullquery>

    <fullquery name="update_messages">
        <querytext>
            update messages_user_messages set folder_id = :folder_id_inbox 
            where folder_id = :folder_id and user_id = :user_id
        </querytext>
    </fullquery>

</queryset> 