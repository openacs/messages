<if @reply_p@>
    <master src="/packages/messages/www/xinha-master">
    <input type="hidden" id="dialog_rol_set" value="0">    
</if><else>
    <master>
        <property name="title">@page_title;noquote@</property>
        <property name="context">@context;noquote@</property>
        <input type="hidden" id="dialog_rol_set" value="1">        
        <script type="text/javascript" src="/resources/ajaxhelper/yui/button/button-min.js"></script>
        <script type="text/javascript" src="/resources/messages/rol-dialog.js"></script>
    <style>
        .composer{padding-top:10px;padding-left:10px;padding:10px 0 10px 10px;background:#FFFFFF;}
    </style>
    <a class="button" href="messages">#messages.back_folders#</a>
</else>


<span id="send_mail_loading" style="display:none">
    <span id=alert-message> 
        <span class="alert">
            <strong>
                <span id=send_mail_wait style=text-align:center></span>
            </strong>
        </span>
    </span>
</span>

<input type=hidden id="sending" value="#messages.sending#">
<input type=hidden id="add" value="#messages.add#">
<input type=hidden id="delete_confirm" value="#messages.delete_confirm#">
<input type="hidden" id="attachment_delete" value="#messages.delete#">
<input type="hidden" id="contacts_list" value="">
<input type=hidden id="subject_empty" value="#messages.subject_empty#">
<input type=hidden id="body_empty" value="#messages.body_empty#">
<span style='display:none' id="history_conversation">@history_conversation;noquote@</span>
<span style='display:none' id="signature">@signature;noquote@</span>
<if @reply_p@>
    <div id=background style="background-color:#FFFFFF">
</if>
<else>
    <div id=background style="background-color:#E0F8F7">
</else>
    <div id="autocomplete">
        <div class="composer">
        <form id="compose_message" name="compose_message" enctype="multipart/form-data" action="@action_send@" method="POST">
            <formtemplate id="compose_message">
                @rel_types_html;noquote@
                <if @reply_p@ eq 0>
                    <input type="hidden" id="total_attachment" name="total_attachment" value="0">
                    <input type="hidden" id="contacts_ids" name="contacts_ids" value="">
                    <input type="hidden" id="subject" name="subject" value="">
                </if>                
                <br><br>
                <dl class="clearfix">
                        <table width="100%" style="font-size:10px">
                            <tr>
                                <th width="5%" align="left">
                                    <label>#messages.to#:</label>
                                </th>
                                <th align="left">
                                    <div tabindex="-1" id="ids" class="clearfix tokenizer" onclick="$('autocomplete_input').focus()" width="600px">
                                        <span class="tokenizer_stretcher">^_^</span>
                                        <span class="tab_stop"><input type="text" id="hidden_input" tabindex="-1"></span>
                                        <span id=contact_reply></span>
                                        <div id="autocomplete_display" class="tokenizer_input">
                                            <input type="text" size="1" tabindex="" id="autocomplete_input" onblur="delete_text_input(this.name)" />
                                        </div>
                                    </div>
                                </th>
                            </tr>
                        </table>
                        <div id="autocomplete_populate" class="clearfix autocomplete typeahead_list" style="width: 358px; height: auto; overflow-y: hidden;display:none; z-index: 1000;">
                            <div class="typeahead_message">Type the name of a member</div>
                        </div> 
                        <script type="text/javascript">
                            (new Image()).src='inbox/images/token.gif';
                            (new Image()).src='inbox/images/token_selected.gif';
                            (new Image()).src='inbox/images/token_hover.gif';
                            (new Image()).src='inbox/images/token_x.gif';
                            <if @reply_p@ eq 0>
                                var contacts = [@contacts_list;noquote@];
                            </if>
                            var typeahead = new Autocompleter.LocalAdvanced('autocomplete_input', 'autocomplete_populate', contacts, {
                                frequency: 0.1,
                                updateElement: addContactToList,
                                search_field: "name"
                            });
                            var hidden_input = new HiddenInput('hidden_input',typeahead);
                        </script>
                        <label style="font-size:8pt">#messages.to_help#</label>
                        <br>
                    <if @reply_p@ eq 0>
                        <br>
                        <input type=hidden id="recipients_empty" value="#messages.recipients_empty#">
                        <table width="100%" style="font-size:12px">
                            <tr>
                                <th width="5%" align="left">
                                    <label>#messages.subject#:</label>
                                </th>
                                <th align="left" width="95%">
                                    <input width="600px" class="subject" id="subject_field">
                                </th>
                            </tr>
                        </table>
                    </if>
                    <else>
                        <input type=hidden id=@msg_id@_recipients_empty value="#messages.recipients_empty#">
                    </else>
                        <br>
                        <label>#messages.message#:</label>
                    <dd class="field">
                            <formwidget id=message>
                    </dd>
                    <dd>
                        <label>#messages.attachments#:</label>
                        <div id=attachment_forward style="display:none">
                            @download_file;noquote@
                        </div>
                        <a onclick="addField()" class="button">#messages.add_attachment#</a>
                    </dd>
                    <dd><div id="files"></div></dd><br>
                    <dd class="submits">
                        <div class="submits_wrap">
                            <if @reply_p@ ne 0>
                                <span id=submit_reply>
                                    <a  class="button" name="send_button" value="Send" type="button" onclick="submit_reply(@msg_id@,@general_parent_id@);Effect.ScrollTo('reply_@msg_id@');" >#messages.send#</a>
                                </span>
                                <a  href="javascript:cancel(@msg_id@);" class="button" name="cancel_button" value="Cancel" type="button" >#messages.discard#</a>
                            </if>
                            <else>
                                <a  class="button" name="send_button" value="Send" type="button" href="#" onclick="submit_normal();Effect.ScrollTo('send_mail_loading');" >#messages.send#</a>
                                <a  href="messages" class="button" name="cancel_button" value="Cancel" type="button" >#messages.discard#</a>
                            </else>
                        </div>
                        <div class="sub_controls"></div>
                    </dd>
                </dl>
           </formtemplate>
        </form>
        </div>
    </div> 
    
<if @reply_p@ eq 0>    
    <div id="dialog2" class="yui-pe-content">
        <div class="bd">
            <div id="info_members_rols" "style="width:28em;height:30em;overflow:auto"> 
            </div>
        </div>
    </div>
</if>