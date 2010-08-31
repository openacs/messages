<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>
   
<fullquery name="set_file_content">      
      <querytext>

        update cr_revisions
        set content = :file_name,
        mime_type = :mime_type,
        content_length = :content_length
        where revision_id = :revision_id
            
      </querytext>
</fullquery>   

<fullquery name="lob_content">      
      <querytext>

        update cr_revisions 
        set lob = [set __lob_id [db_string get_lob_id "select empty_lob()"]]
        where revision_id = :revision_id
    
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