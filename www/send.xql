<?xml version="1.0"?>

<queryset>

    <fullquery name="members">
        <querytext>
            select persons.first_names||' '||persons.last_name  as party_name,
                   persons.person_id
            from persons,
                    dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.community_id = :community_id
            and dotlrn_member_rels_approved.user_id = persons.person_id
            order by party_name
        </querytext>
    </fullquery> 

    <fullquery name="signature_p">
        <querytext>
            select signature_p
            from messages_options
            where user_id = :owner_id
        </querytext>
    </fullquery> 

    <fullquery name="get_signature">
        <querytext>
            select signature
            from messages_options
            where user_id = :owner_id
        </querytext>
    </fullquery>


    <fullquery name="get_attachment_id">
        <querytext>
            select attachment_id, attachment_item_id
            from messages_attachments
            where msg_id = :msg_id
        </querytext>
    </fullquery>

    <fullquery name="lob_size">
        <querytext>
            update cr_revisions
            set content_length = :content_length
            where revision_id = :revision_id
        </querytext>
    </fullquery>

<fullquery name="set_file_content">
      <querytext>

		update cr_revisions
		set title = :title,
		mime_type = :mime_type,
		content_length = :content_length
		where revision_id = :revision_id
			
      </querytext>
</fullquery>

</queryset>
