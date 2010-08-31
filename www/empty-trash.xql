<?xml version="1.0"?>
<queryset>

    <fullquery name="empty_trash">
        <querytext>
            delete from messages_user_messages 
            where folder_id = :folder_id and user_id = :user_id
        </querytext>
    </fullquery>

</queryset>