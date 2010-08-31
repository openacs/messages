<?xml version="1.0"?>
<queryset>

    <fullquery name="update_status_msg">
        <querytext>
            update messages_user_messages 
            set new_p = :option_select
            where parent_id in ($msg_ids) and user_id = :user_id
        </querytext>
    </fullquery>

</queryset>