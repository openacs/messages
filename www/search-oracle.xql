<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>
   
 <fullquery name="get_msg_ids">
        <querytext>
            select msg_id, last_msg_id
            from (select paginate.*, rownum rowsub 
                from (  select max(msg_id) as last_msg_id, parent_id as msg_id, folder_id, count(msg_id) as number_conversation
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
                        group by parent_id, folder_id
                        order by last_msg_id desc
                       ) paginate
              where rownum <= :last_row)
        where rowsub >= :first_row
        </querytext>
    </fullquery>
    
    
        <fullquery name="get_messages">
        <querytext>
        select mm.last_msg_id, mm.msg_id, mm.number_conversation, mm.subject, wm_concat(distinct(p.first_names)) as contacts, mm.folder_id
        from persons p,
            (select max(um.msg_id) as last_msg_id, um.parent_id as msg_id, count(um.msg_id) as number_conversation, m.subject, m.owner_id, um.folder_id
            from (select parent_id,msg_id, folder_id 
                  from messages_user_messages 
                  where user_id = :user_id) um,
                 (select msg_id,subject,owner_id 
                  from messages_messages 
                  where community_id = :community_id 
                        and msg_id in ($msg_ids)) m
            where um.parent_id = m.msg_id
            group by um.parent_id, m.subject, m.owner_id, um.folder_id) mm
        where p.person_id = mm.owner_id
        group by mm.msg_id, mm.subject, mm.last_msg_id, mm.number_conversation, mm.folder_id
        order by mm.last_msg_id desc 
        </querytext>
    </fullquery>
</queryset> 
