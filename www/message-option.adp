<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>
<include src="messages-actions">
<br>
<div class="yui-skin-sam">
    <div>
        <a class="button" id="show" style="cursor:pointer">#messages.new_folder#</a> 
    </div>
    <div id="dialog1" class="yui-pe-content">
        <div class="hd">#messages.name_new_folder#</div>
        <div class="bd">
            <form method="GET" action="create-folder">
                <label for="folder_name">#messages.folder_name#:</label><input type="text" name="folder_name" />
            </form>
        </div>
    </div>
</div>
<br>
<if @folder:rowcount@ gt 0>
    <strong> #messages.folders_created# </strong><br>#messages.edit_folder#<br><br>
</if>

<multiple name="folder">
    <span id="span_folder_@folder.folder_id@" onclick="convert_input('@folder.folder_id@')">
        <img src="/resources/messages/folder.png" width="20" height="20">
        <span id="folder_@folder.folder_id@">
             @folder.folder_name@
        </span>
    </span>
    <span id="span_folder_delete_@folder.folder_id@">
        <a href="javascript:delete_folder();" title="Borrar">
            <img src="/resources/messages/Delete16-on.gif">
            <span class="class="button" onclick="update_folder(@folder.folder_id@,'delete')">
                #messages.delete#
            </span>
        </a>
    </span>
    <br>
</multiple>
<br><br>
<formtemplate id="options_mail"></formtemplate>