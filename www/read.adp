<script src="/resources/messages/messages.js" type="text/javascript"></script>
<input type="hidden" id="folder_id" value="@folder_id@">
<input type="hidden" id="read" value="true">
<input type="hidden" id="msg_reply" value="">
<input type="hidden" id="parent_id_reply" value="">
<input type="hidden" id="msg_action_id" value="">
<multiple name="messages">
    <span id="msg_action_@messages.msg_id@" style="display:none">
        <span id=alert-message> 
            <span class="alert">
                <strong>#messages.msg_has_been_sent#</strong>
            </span>
        </span>
    </span>
    <div style="border-style:ridge;border-width:1px;">
        <table width="98%" valign="top" style="margin-left:10px;margin-left:15px;">
            <tr>
                <th valign="top" align="left">
                    <span id="from_@messages.msg_id@" style="float: left;text-align:left;display:none;"> <font color="#888888">#messages.from#: &nbsp;</font></span>
                    <strong>@messages.name_user@</strong>
                    <if @messages.rel_type_user@ ne "">
                        <span style="background-color:#F06040;color:white;padding:2px;font-size:10px;"> #messages.message_sent_by#: @messages.rel_type_user@ </span>
                    </if>
                    <div style="overflow:hidden;width:100%;height:20px;" id="contact_list_@messages.msg_id@">
                        <font color="#888888">#messages.to# @messages.first_name_contacts@ </font>
                    </div>
                    <span style="text-align:left;display:none;font-size: x-small;" id="details_@messages.msg_id@" > 
                        <font color="#888888">
                            <br>
                            #messages.to#: @messages.contact_names;noquote@ <br>
                            #messages.date#: @messages.ansi_time@ <br>
                            #messages.subject#: @messages.subject@
                        </font>
                    </span>
                    <span style="margin-left:20px;font-size: 12px;color:#6E6E6E">
                        <br><br>
                            @messages.msg_content;noquote@
                        <br>
                    </span>
                </th>
                <th width="20%" valign="top" align="left">
                    <div style="margin-left:20px;margin-left:18px;">
                        <span class="margin-form">
                            <span style="float: right;text-align:right;">
                                &nbsp;&nbsp;@date@ &nbsp;&nbsp;
                            </span>
                            <span style="float: right;text-align:right;" id="show_details_@messages.msg_id@">
                                <a href="javascript:mostrardiv(@messages.msg_id@);">  #messages.show_details#</a>&nbsp;&nbsp;
                            </span>
                            <span style="float: right;text-align:right;display:none;" id="close_details_@messages.msg_id@">
                                <br>
                                <a href="javascript:close_dialog(@messages.msg_id@);">#messages.hide_details#</a>&nbsp;&nbsp;
                            </span>
                        </span>
                        <br><br>
                        <span>
                            @messages.download_file;noquote@
                        </span>
                    </div>
                </th>
            </tr>
        </table>
        <br>
        <span id="scroll_message_@messages.msg_id@"></span>
        <div style="background-color:@color@">
            <table>
                <th>
                    <td id="reply_@messages.msg_id@" style="background-color:@color@;">
                        <a href="javascript:reply_dialog('reply',@messages.msg_id@,@general_parent_id@);update_numbers(@folder_id@,@user_id@);"><img src="/resources/messages/reply.png" width="15px" height="15px">#messages.reply#&nbsp;&nbsp;</a>
                    </td>
                    <if @messages.total_recipients@ gt 1>
                        <td id="reply_all_@messages.msg_id@" style="background-color:@color@;">
                            <a href="javascript:reply_dialog('reply_all',@messages.msg_id@,@general_parent_id@);update_numbers(@folder_id@,@user_id@);"><img src="/resources/messages/reply-all.png" width="15px" height="15px">#messages.reply_all#</a>
                        </td>
                    </if>
                    <td id="forward_@messages.msg_id@" style=background-color:@color@;>
                        <a href="javascript:reply_dialog('forward',@messages.msg_id@,@general_parent_id@);update_numbers(@folder_id@,@user_id@);"><img src="/resources/messages/forward.png" width="15px" height="15px">#messages.forward#</a>
                    </td>
                </th>
            </table>
        </div>
        <span id=response_reply_mail_@messages.msg_id@ style="display:;">
        </span>
    </div>
    <br>
</multiple>

<input type="hidden" id="rel_types_checked" value="@rel_types_checked@">
