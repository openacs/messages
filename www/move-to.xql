<?xml version="1.0"?>
<queryset>
    <fullquery name="update_folder">
        <querytext>
            update messages_user_messages set folder_id = :folder_id 
            where parent_id in ($msg_ids)
                and user_id = :user_id
                and folder_id != :folder_id_sent
        </querytext>
    </fullquery>
</queryset>