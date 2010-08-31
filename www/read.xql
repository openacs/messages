<?xml version="1.0"?>
<queryset>

    <fullquery name="get_msg_ids">
        <querytext>
            select distinct(msg_id)
            from messages_user_messages
            where user_id = :user_id
                  and parent_id = :msg_id
        </querytext>
    </fullquery>

    <fullquery name="count_recipients">
        <querytext>
            select count(party_id)
            from messages_recipients
            where msg_id = :msg_id
        </querytext>
    </fullquery>

    <fullquery name="update_status">
        <querytext>
            update messages_user_messages
            set new_p = 'f'
            where parent_id = :msg_id
                and user_id = :user_id
                and new_p != 'f'
        </querytext>
    </fullquery>

    <fullquery name="get_name">
        <querytext>
            select acs_users_all.last_name||' '||acs_users_all.first_names
            from acs_users_all,
                    dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.community_id = :community_id
                  and dotlrn_member_rels_approved.user_id = acs_users_all.user_id
                  and acs_users_all.user_id = :party_id 
        </querytext>
    </fullquery>

    <fullquery name="get_attachment_id">
        <querytext>
            select attachment_id, attachment_item_id
            from messages_attachments
            where msg_id = :msg_id
        </querytext>
    </fullquery>

    <fullquery name="get_rel_types">
        <querytext>
            select rel_id
            from messages_recipients_roles
            where msg_id = :msg_id
        </querytext>
    </fullquery>

    <fullquery name="get_messages_info">
        <querytext>
            select msg_content, owner_id, community_id,parent_id, subject,
                   to_char(sent_date, 'YYYY-MM-DD HH24:MI:SS') as sent_date, to_char(sent_date, 'HH24:MI:SS') as time, msg_id
            from messages_messages
            where msg_id in ($msg_ids)
            order by msg_id asc
        </querytext>
    </fullquery>

    <fullquery name="get_contacts_ids">
        <querytext>
            select  msg_id,wm_concat(party_id) as contacts
            from messages_recipients
            where msg_id in ($msg_ids)
            group by msg_id
        </querytext>
    </fullquery>

    <fullquery name="get_contacts_ids_roles">
        <querytext>
        select  msg_id, wm_concat(distinct(rel_id)) as contacts
            from messages_recipients_roles
            where msg_id in ($msg_ids)
            group by msg_id
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
