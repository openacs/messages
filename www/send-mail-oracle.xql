<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>
   
        <fullquery name="set_file_content">
              <querytext>

                update cr_revisions
                set filename = :file_name,
                mime_type = :mime_type,
                content_length = :content_length
                where revision_id = :revision_id
                    
              </querytext>
        </fullquery>
              
            <fullquery name="lob_content">
                <querytext>
                
                        update cr_revisions 
                        set content = empty_blob(),
                        filename = :filename
                        where revision_id = :revision_id
                        returning content into :1   
                        
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
                crr.filename
                from cr_items cri, cr_revisions crr
                where crr.revision_id = :attachment_id
                        and crr.item_id = cri.item_id
            
              </querytext>
        </fullquery>
        
</queryset> 
