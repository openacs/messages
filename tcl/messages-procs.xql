<?xml version="1.0"?>

<queryset>

<fullquery name="messages::send_mail.send_mail">
      <querytext>
	insert into messages_messages (msg_id, owner_id, community_id, subject, msg_content) 
                   values (:msg_id,:owner_id,:community_id,:subject,:message)
        </querytext>
</partialquery>

    <fullquery name="messages::send_mail.recipients">
        <querytext>
            insert into messages_recipients (msg_id, party_id) 
                   values (:msg_id,:party_id)
        </querytext>
    </fullquery>

    <fullquery name="messages::send_mail.recipients_roles">
        <querytext>
            insert into messages_recipients_roles (msg_id, rel_id) 
                   values (:msg_id,$rel_type)
        </querytext>
    </fullquery>

    <fullquery name="messages::send_mail.user_messages">
        <querytext>
            insert into messages_user_messages (msg_id, user_id, folder_id, new_p,parent_id) 
                   values (:msg_id,:party_id,0,'t',:msg_id)
        </querytext>
    </fullquery>

    <fullquery name="messages::send_mail.get_save_sent">
        <querytext>
            select save_sent_p
            from messages_options
            where user_id = :user_id
        </querytext>
    </fullquery>

    <fullquery name="messages::send_mail.sent_message">
        <querytext>
            insert into messages_user_messages (msg_id, user_id, folder_id, new_p,parent_id) 
                   values (:msg_id,:owner_id,1,'t',:msg_id)
        </querytext>
    </fullquery>

    <fullquery name="messages::reply_mail.update_new">
        <querytext>
            update messages_user_messages
            set new_p = 't'
            where msg_id = :msg_id
        </querytext>
    </fullquery>
 
    <fullquery name="messages::reply_mail.get_attachment_id">
        <querytext>
            select attachment_id, attachment_item_id
            from messages_attachments
            where msg_id = :msg_id_old
                  $attachment_ids_clause
        </querytext>
    </fullquery>

    <fullquery name="messages::reply_mail.send_mail_forward">
        <querytext>
            insert into messages_messages (msg_id, owner_id, community_id, subject, msg_content) 
                   values (:msg_id,:owner_id,:community_id,:subject,:message)
        </querytext>
    </fullquery> 

    <fullquery name="messages::reply_mail.send_mail">
        <querytext>
            insert into messages_messages (msg_id, owner_id, community_id, subject, msg_content,parent_id) 
                   values (:msg_id,:owner_id,:community_id,:subject,:message,:general_parent_id)
        </querytext>
    </fullquery> 

    <fullquery name="messages::reply_mail.recipients">
        <querytext>
            insert into messages_recipients (msg_id, party_id) 
                   values ($msg_id,$party_id)
        </querytext>
    </fullquery>

    <fullquery name="messages::reply_mail.recipients_roles">
        <querytext>
            insert into messages_recipients_roles (msg_id, rel_id) 
                   values (:msg_id,$rel_type)
        </querytext>
    </fullquery>

    <fullquery name="messages::reply_mail.user_messages_forward">
        <querytext>
            insert into messages_user_messages (msg_id, user_id, folder_id, new_p,parent_id)
                   values (:msg_id,:party_id,0,'t',:msg_id)
        </querytext>
    </fullquery>

    <fullquery name="messages::reply_mail.sent_message_forward">
        <querytext>
            insert into messages_user_messages (msg_id, user_id, folder_id, new_p,parent_id) 
                   values (:msg_id,:owner_id,1,'t',:msg_id)
        </querytext>
    </fullquery>

    <fullquery name="messages::reply_mail.get_save_sent">
        <querytext>
            select save_sent_p
            from messages_options
            where user_id = :user_id
        </querytext>
    </fullquery>

    <fullquery name="messages::reply_mail.attachment_files">
        <querytext>
            insert into messages_attachments values (:msg_id,:attachment_id,:attachment_item_id)
        </querytext>
    </fullquery>

    <fullquery name="messages::reply_mail.sent_message">
        <querytext>
            insert into messages_user_messages (msg_id, user_id, folder_id, new_p,parent_id) 
                   values (:msg_id,:owner_id,1,'t',:parent_id)
        </querytext>
    </fullquery>

    <fullquery name="messages::reply_mail.user_messages">
        <querytext>
            insert into messages_user_messages (msg_id, user_id, folder_id, new_p,parent_id)
                   values (:msg_id,:party_id,0,'t',:parent_id)
        </querytext>
    </fullquery>

    <fullquery name="messages::delete_trash_mails.delete_messages">
        <querytext>
            delete from messages_user_messages 
            where msg_id in ( select um.msg_id 
                              from (select parent_id,msg_id from messages_user_messages where folder_id = :folder_id and msg_id = parent_id) um, 
                                   (select msg_id,to_char(sent_date, 'DD-MM-YYYY') as sent_date from messages_messages where sent_date < (SELECT sysdate - :limit_days_in_trash FROM dual)) m
                              where um.msg_id = m.msg_id
                            )
        </querytext>
    </fullquery>

    <fullquery name="messages::delete_trash_mails.get_msg_ids_users">
        <querytext>
            select msg_id, user_id from messages_user_messages where folder_id = :folder_id
        </querytext>
    </fullquery>

    <fullquery name="messages::reply_mail.get_subject">
        <querytext>
            select subject from messages_messages where msg_id = :msg_id_old
        </querytext>
    </fullquery>

    <fullquery name="messages::send_mail.get_rel_types_user_ids">
        <querytext>
            select user_id 
            from dotlrn_member_rels_approved 
            where community_id = :community_id 
                  and rel_type in ($rel_types)
        </querytext>
    </fullquery>

    <fullquery name="messages::reply_mail.get_rel_types_user_ids">
        <querytext>
            select user_id 
            from dotlrn_member_rels_approved 
            where community_id = :community_id 
                  and rel_type in ($rel_types)
        </querytext>
    </fullquery>

    <fullquery name="messages::get_history_conversation.get_history_conversation">
        <querytext>
            select msg_content, owner_id, subject,
                   sent_date, to_char(sent_date, 'HH24:MI:SS') as time
            from messages_messages
            where msg_id in (select msg_id
                             from messages_user_messages
                             where user_id = :user_id
                                 and folder_id not in ($not_folder_ids)
                                 and parent_id = :parent_id)
            and msg_id <= :msg_id
            order by msg_id desc

        </querytext>
    </fullquery>

    <fullquery name="messages::get_community_users_fb.members">
        <querytext>
            select '{name:"'||name.party_name||'", p:"'||name.person_id||'"}'
            from (select persons.first_names||' '||persons.last_name as party_name, persons.person_id
                  from persons,dotlrn_member_rels_approved
                  where dotlrn_member_rels_approved.community_id = :community_id
                        and dotlrn_member_rels_approved.user_id = persons.person_id
                   order by party_name) as name
        </querytext>
    </fullquery> 

</queryset> 