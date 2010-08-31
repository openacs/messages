<?xml version="1.0"?>
<queryset>

    <fullquery name="owner_info">
        <querytext>
            select acs_users_all.first_names||' '||acs_users_all.last_name  as contact_name,
                   acs_users_all.party_id as contact_id
            from acs_users_all,
                    dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.community_id = :community_id
            and dotlrn_member_rels_approved.user_id = acs_users_all.user_id
            and acs_users_all.user_id in (select owner_id from messages_messages where msg_id = :msg_id)
        </querytext>
    </fullquery> 

    <fullquery name="recipient_ids">
        <querytext>
            select acs_users_all.first_names||' '||acs_users_all.last_name  as party_name,
                   acs_users_all.party_id
            from acs_users_all,
                    dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.community_id = :community_id
            and dotlrn_member_rels_approved.user_id = acs_users_all.user_id
            and acs_users_all.user_id in (select party_id from messages_recipients where msg_id = :msg_id)
        </querytext>
    </fullquery> 

</queryset>