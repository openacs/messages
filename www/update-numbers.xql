<?xml version="1.0"?>
<queryset>

    <fullquery name="count_new_messages">
        <querytext>
                select count (case when um.new_p = 't' then 1 end ) as new_t, um.folder_id, 
                    count (um.new_p) as total
                from (select distinct(parent_id) as msg_id,folder_id,new_p
                        from messages_user_messages 
                        where user_id = :user_id
                        and msg_id in (select msg_id 
                        from messages_messages 
                        where community_id = :community_id)
                        and folder_id not in ($not_folder_ids)) um
                group by um.folder_id
                order by folder_id
        </querytext>
    </fullquery>

</queryset>