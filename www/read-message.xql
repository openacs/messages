<?xml version="1.0"?>
<queryset>

    <fullquery name="data_msg">
        <querytext>
            select subject, owner_id
            from messages_messages 
            where msg_id = :msg_id
                and community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="get_parents_ids">
        <querytext>
            select messages.msg_id
            from (select max(m.msg_id) as last_msg_id, m.parent_id as msg_id, count(m.msg_id) as number_conversation
                    from (select msg_id, coalesce(parent_id,msg_id) as parent_id 
                          from messages_messages 
                          where community_id = :community_id 
                              and msg_id in (select parent_id 
                                             from messages_user_messages 
                                             where user_id = :user_id 
                                                 and folder_id = :folder_id)) m
                        group by m.parent_id
                        order by last_msg_id desc) messages
        </querytext>
    </fullquery>

    <fullquery name="get_max_messages">
        <querytext>
            select max_messages
            from messages_options
            where user_id = :user_id
        </querytext>
    </fullquery>

    <fullquery name="get_attachment_id">
        <querytext>
            select attachment_id
            from messages_attachments
            where msg_id in (select msg_id from messages_messages where community_id = :community_id and parent_id = :msg_id or msg_id = :msg_id)
        </querytext>
    </fullquery>

    <fullquery name="get_sol_info">
        <querytext>
            select crr.title as content, 
            crr.title,
            crr.item_id,
            cri.storage_type,
            crr.revision_id,
            crr.content_length,
            crr.mime_type,
            crr.title
            from cr_items cri, cr_revisions crr
            where crr.revision_id = :attachment_id
            and crr.item_id = cri.item_id
        </querytext>
    </fullquery>

    <fullquery name="exist_msg">
        <querytext>
            select count(*)
            from messages_user_messages
            where user_id = :user_id
                  and parent_id = :msg_id
        </querytext>
    </fullquery>

    <fullquery name="get_members_ids_rel_type">
        <querytext>
            select $rel_type_case as rel_type 
            from acs_rels 
            where object_id_one = :community_id
                and object_id_two = :owner_id
        </querytext>
    </fullquery>


</queryset>  
 
