<?xml version="1.0"?>
<queryset>

    <fullquery name="get_folders_user">
        <querytext>
            select folder_id, folder_name
            from messages_folders 
            where (user_id = :user_id
            or user_id = 0)
            order by folder_id asc
        </querytext>
    </fullquery>

    <fullquery name="members">
        <querytext>
            select concat('{n:"'||to_clob(party_name)||'", p:"'||to_clob(person_id)||'"}') as contact
            from (select persons.first_names||' '||persons.last_name as party_name, persons.person_id
                  from persons,dotlrn_member_rels_approved
                  where dotlrn_member_rels_approved.community_id = :community_id
                        and dotlrn_member_rels_approved.user_id = persons.person_id and rownum <= $limit and rownum > $i
                   order by party_name)
        </querytext>
    </fullquery>
    
    <fullquery name="members2">
        <querytext>
            select '{n:"'||party_name||'", p:"'||person_id||'"}' as contact
            from (select persons.first_names||' '||persons.last_name as party_name, persons.person_id
                  from persons,dotlrn_member_rels_approved
                  where dotlrn_member_rels_approved.community_id = :community_id
                        and dotlrn_member_rels_approved.user_id = persons.person_id and rownum > 1500
                   order by party_name)
        </querytext>
    </fullquery> 

    <fullquery name="count_members">
        <querytext>
           select count(*)
              from persons,dotlrn_member_rels_approved
              where dotlrn_member_rels_approved.community_id = :community_id
                        and dotlrn_member_rels_approved.user_id = persons.person_id
        </querytext>
    </fullquery>     

</queryset>   
