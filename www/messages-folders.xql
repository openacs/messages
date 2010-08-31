<?xml version="1.0"?>
<queryset>

    <fullquery name="get_folders_user">
        <querytext>
            select folder_id, folder_name
            from messages_folders 
            where (user_id = :user_id
            or user_id = 0)
            order by folder_id asc
        </querytext>
    </fullquery>

</queryset>   
