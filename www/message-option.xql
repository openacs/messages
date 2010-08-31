<?xml version="1.0"?>
<queryset>

    <fullquery name="get_folders_data">
        <querytext>
            select folder_id, folder_name
            from messages_folders 
            where user_id = :user_id
            or user_id = 0
            and folder_id not in ($folders_id_standar)
            order by folder_id asc
        </querytext>
    </fullquery>

    <fullquery name="select_options">
        <querytext>
            select max_messages, save_sent_p, signature_p, signature
            from messages_options
            where user_id = :user_id
        </querytext>
    </fullquery>

    <fullquery name="create_options">
        <querytext>
            insert into messages_options values (:user_id,25,:save_sent_p,:signature_p,:signature) 
        </querytext>
    </fullquery>

    <fullquery name="update_options">
        <querytext>
            update messages_options 
            set max_messages = :max_messages,save_sent_p = :save_sent_p, signature_p = :signature_p, signature = :signature
            where user_id = :user_id
        </querytext>
    </fullquery>

</queryset>