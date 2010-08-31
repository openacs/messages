<?xml version="1.0"?>
<queryset>

    <fullquery name="delete_messages">
        <querytext>
            delete from messages_user_messages 
            where folder_id = :folder_id 
                and user_id = :user_id
                and msg_id in ($msg_ids)
            
        </querytext>
    </fullquery>

</queryset>