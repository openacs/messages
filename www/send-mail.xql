<?xml version="1.0"?>

<queryset>

<fullquery name="lob_size">
    <querytext>
        update cr_revisions
        set content_length = :content_length
        where revision_id = :revision_id
    </querytext>
</fullquery>

</queryset>