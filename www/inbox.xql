<?xml version="1.0"?>
<queryset>

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

    <fullquery name="get_msg_info">
        <querytext>
            select coalesce(parent_id,msg_id) as parent_id, msg_content, to_char(sent_date, 'YYYY-MM-DD HH24:MI:SS') as sent_date_ansi
            from messages_messages
            where msg_id in ($last_msg_ids)
        </querytext>
    </fullquery>

    <fullquery name="get_total_messages">
        <querytext>
                select count(um.msg_id) as total
                from (select distinct(mum.parent_id) as msg_id
                        from (select * from messages_user_messages where user_id = :user_id) as mum
                        where user_id = :user_id
                        and msg_id in (select msg_id 
                        from messages_messages 
                        where community_id = :community_id)
                        and folder_id = :folder_id) um
        </querytext>
    </fullquery>

    <fullquery name="get_max_show_msg">
        <querytext>
            select max_messages
            from messages_options
            where user_id = :user_id
        </querytext>
    </fullquery>

    <fullquery name="get_attachment_p">
        <querytext>
            select um.parent_id, count(*) as count_attachment
            from messages_attachments ma,
                (select msg_id, parent_id
                             from messages_user_messages
                             where user_id = :user_id
                                    and folder_id = :folder_id
                                    and parent_id in ($msg_ids)
                            ) um
             where ma.msg_id = um.msg_id
            group by um.parent_id
        </querytext>
    </fullquery>

    <fullquery name="get_new_p">
        <querytext>
            select parent_id, new_p
            from messages_user_messages
            where parent_id in ($last_msg_ids)
                    and folder_id = :folder_id
                    and user_id = :user_id
        </querytext>
    </fullquery>

    <fullquery name="get_owner_id">
        <querytext>
            select owner_id
            from messages_messages
            where msg_id = :msg_id
            and community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="get_members_ids_rel_type">
        <querytext>
            select $rel_type_case as rel_type 
            from acs_rels map
            where map.object_id_one = :community_id
                and map.rel_type in ('$rel_types')  
                and object_id_two = :owner_id
        </querytext>
    </fullquery>

    <fullquery name="get_name">
        <querytext>
            select first_names
            from persons
            where person_id = :contact_id
        </querytext>
    </fullquery>

</queryset> 