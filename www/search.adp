<input type="hidden" id="page_number" value=@page_number@>
<input type="hidden" id="folder_id" value=@folder_id@>
<input type="hidden" id="folder_id_state" value="@folder_id@">
<input type="hidden" id="msg_continue_empty" value="#messages.msg_continue_empty#">
<input type="hidden" id="number_messages" value=@total_messages@>

<div align="right">
    <if @total_messages@ gt @show_messages@>
        <if @page_number@ eq 2>
            <a href="#" onClick="paginate(@folder_id@,@page_number@,'newer');update_numbers(@folder_id@,@user_id@)">#messages.newer# </a>
        </if>
        <if @page_number@ ge 3>
            <a href="#" onClick="paginate(@folder_id@,1,'newest');update_numbers(@folder_id@,@user_id@)">#messages.newest# </a>
            <a href="#" onClick="paginate(@folder_id@,@page_number@,'newer');update_numbers(@folder_id@,@user_id@)">#messages.newer# </a>
        </if>
        #messages.range_messages_show#
        <if @page_number@ lt @total_pages@>
            <a href="#" onClick="paginate(@folder_id@,@page_number@,'older');update_numbers(@folder_id@,@user_id@)">#messages.older# </a>
            <if @page_number@ ne @oldest_page@>
                <if @page_number@ lt @oldest_page@>
                    <a href="#" onClick="paginate(@folder_id@,@total_pages@,'oldest');update_numbers(@folder_id@,@user_id@)">#messages.oldest# </a>
                </if>
            </if>
        </if>
    </if>
    <else>
        <if @total_messages@ ne 0>  #messages.range_messages_show# </if>
    </else>
</div>
<if @folder_id@ eq 3>
    <div id="folder_trash_msg" style="font-size:12px;" align="center">
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <if @total_messages@ ne 0>
            <a href="#" onclick="empty_trash()">#messages.empty_trash#</a>
        </if>
         #messages.folder_trash_msg# &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </div>
</if>

<form name="messages_list" method="GET">
    <div id="list_messages" style="weight:100%">
        <listtemplate name="messages"></listtemplate>
    </div>
</form> 
