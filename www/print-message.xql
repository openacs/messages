<?xml version="1.0"?>
<queryset>

    <fullquery name="get_contact_names">
        <querytext>
            select acs_users_all.last_name||' '||acs_users_all.first_names  as party_name,
                   acs_users_all.party_id, acs_users_all.email
            from acs_users_all,
                    dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.community_id = :community_id
                  and dotlrn_member_rels_approved.user_id = acs_users_all.user_id
                  and acs_users_all.user_id = :user_id 
        </querytext>
    </fullquery> 

    <fullquery name="data_msg">
        <querytext>
            select subject
            from messages_messages 
            where msg_id = :msg_id
        </querytext>
    </fullquery>

    <fullquery name="get_data_msg">
        <querytext>
            select msg_content, owner_id, community_id,parent_id,
                   sent_date, to_char(sent_date, 'HH24:MI:SS') as time,msg_id
            from messages_messages
            where msg_id in (select msg_id
				from messages_user_messages
				where user_id = :user_id
				      and parent_id = :msg_id)
            order by msg_id asc
        </querytext>
    </fullquery>

    <fullquery name="get_contacts">
        <querytext>
            select party_id
            from messages_recipients
            where msg_id = :msg_id
        </querytext>
    </fullquery> 

    <fullquery name="get_name">
        <querytext>
            select acs_users_all.last_name||' '||acs_users_all.first_names, acs_users_all.email
            from acs_users_all,
                    dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.community_id = :community_id
                  and dotlrn_member_rels_approved.user_id = acs_users_all.user_id
                  and acs_users_all.user_id = :party_id 
        </querytext>
    </fullquery>

</queryset>
