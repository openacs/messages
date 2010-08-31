<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>    

    <fullquery name="get_contacts_ids">
        <querytext>
            select  msg_id, concat(distinct(party_id)||',') as contacts
            from messages_recipients
            where msg_id in ($msg_ids)
            group by msg_id
        </querytext>
    </fullquery>
    
    <fullquery name="get_contacts_ids_roles">
        <querytext>
        select  msg_id, concat(distinct(rel_id)||',') as contacts
            from messages_recipients_roles
            where msg_id in ($msg_ids)
            group by msg_id
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

    <fullquery name="get_sol_info">
        <querytext>
            select crr.title as content, 
            crr.title,
            crr.item_id,
            cri.storage_type,
            crr.revision_id,
            crr.content_length,
            crr.mime_type
            from cr_items cri, cr_revisions crr
            where crr.revision_id = :attachment_id
            and crr.item_id = cri.item_id
        </querytext>
    </fullquery>

</queryset>
