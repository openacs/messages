<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>    

<fullquery name="get_messages">
    <querytext>
    select mm.last_msg_id, mm.msg_id, mm.number_conversation, mm.subject, ARRAY_TO_STRING(ARRAY(select first_names||' '||last_name from persons where person_id = mm.owner_id),',') as contacts, count(distinct p.first_names) as total_contacs, mm.owner_id
    from persons p,
        (select max(um.msg_id) as last_msg_id, um.parent_id as msg_id, count(um.msg_id) as number_conversation, m.subject, m.owner_id
        from (select parent_id,msg_id from messages_user_messages where user_id = :user_id and folder_id = :folder_id) um,
             (select msg_id,subject,owner_id from messages_messages where community_id = :community_id and msg_id in ($msg_ids)) m
        where um.parent_id = m.msg_id
        group by um.parent_id, m.subject, m.owner_id) mm
    where p.person_id = mm.owner_id
    group by mm.msg_id, mm.subject, mm.last_msg_id, mm.number_conversation, mm.owner_id
    order by mm.last_msg_id desc 
    </querytext>
</fullquery>

<fullquery name="get_contacts">
    <querytext>
        select distinct(owner_id)
        from messages_messages
        where parent_id = :msg_id
            or msg_id = :msg_id
        LIMIT 4
    </querytext>
</fullquery>

<fullquery name="get_msg_ids">
    <querytext>
        select messages.msg_id, messages.last_msg_id
        from (select paginate.*
            from (select max(m.msg_id) as last_msg_id, m.parent_id as msg_id, count(m.msg_id) as number_conversation
                    from (select msg_id, coalesce(parent_id,msg_id) as parent_id 
                          from messages_messages 
                          where community_id = :community_id 
                              and msg_id in (select parent_id 
                                             from messages_user_messages 
                                             where user_id = :user_id 
                                                 and folder_id = :folder_id)) m
                        group by m.parent_id
                        order by last_msg_id desc
                   ) paginate
          LIMIT :last_row) messages
    OFFSET :first_row - 1

    </querytext>
</fullquery> 

</queryset>
