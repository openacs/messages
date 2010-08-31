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
        select count(*) 
        from (select parent_id, folder_id
            from messages_user_messages
            where user_id = :user_id
             and msg_id in (select msg_id
                            from messages_messages
                            where community_id = :community_id
                                  and (owner_id in (select person_id
                                                    from persons
                                                    $where_clause_user)
                                       or msg_id in (select msg_id
                                                     from messages_recipients
                                                     where party_id in (select person_id
                                                                        from   persons
                                                                        $where_clause_user))
                                      $search_clause))
              group by parent_id,folder_id) as messages
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
            where msg_id in ($last_msg_ids)
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

    <fullquery name="get_folder_name">
        <querytext>
            select folder_name
            from messages_folders
            where folder_id = :folder_id
        </querytext>
    </fullquery>

</queryset>  