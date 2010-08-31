<?xml version="1.0"?>
<queryset>

    <fullquery name="create_new_folder">
        <querytext>
            insert into 
            messages_folders (user_id,folder_id,folder_name)
            values(:user_id,:folder_id,:folder_name)
        </querytext>
    </fullquery>

</queryset>