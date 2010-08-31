<?xml version="1.0"?>
<queryset>

    <fullquery name="get_members">
        <querytext>
            select p.first_names||' '||p.last_name  as party_name,
                   p.person_id
            from persons p,
                acs_rels map
            where map.object_id_one = :community_id
                and map.object_id_two = p.person_id
                and map.rel_type = :rel_type
                $where_clause_user
            order by party_name
        </querytext>
    </fullquery>

</queryset>

