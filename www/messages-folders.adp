<input type="hidden" id="add" value="#messages.add#">
<input type="hidden" id="contacts" value="@contacts_list;noquote@">
<input type="hidden" id="owner_id" value="@user_id;noquote@">
<input type="hidden" id="not_permision_read" value="#messages.not_permision_read#">
<span id="scroll_top"></span>

<div id="autocomplete_loding" style="display:none">
    <div tabindex="-1" id="ids" class="clearfix tokenizer" onclick="$('autocomplete_input').focus()">
        <span class="tokenizer_stretcher">^_^</span>
        <span class="tab_stop"><input type="text" id="hidden_input" tabindex="-1"></span>
            <span id=contact_reply>
            </span>
        <div id="autocomplete_display" class="tokenizer_input">
            <input type="text" size="1" tabindex="" id="autocomplete_input" />            
        </div>
    </div>
    <div id="autocomplete_populate" class="clearfix autocomplete typeahead_list" style="width: 358px; height: auto; overflow-y: hidden;display:none">
        <div class="typeahead_message">Type the name of a member</div>
    </div>
</div>

<script type="text/javascript">
    update_numbers();
    var contacts = [@contacts_list;noquote@];
    var typeahead = new Autocompleter.LocalAdvanced('autocomplete_input', 'autocomplete_populate', contacts, {
        frequency: 0.1,
        updateElement: addContactToList,
        search_field: "name"
    });
    var hidden_input = new HiddenInput('hidden_input',typeahead);
    function contact_users() {
        var typeahead = new Autocompleter.LocalAdvanced('autocomplete_input', 'autocomplete_populate', contacts, {
            frequency: 0.1,
            updateElement: addContactToList,
            search_field: "name"
        });
        var hidden_input = new HiddenInput('hidden_input',typeahead);
    }

</script>

<div style="height:auto;text-align:center">
    <span id="msg_system">
    </span>
    <span id="msg_action" style="display:none">
        <span class="alert">
            <strong>
                <span id="msg_actions"></span>
            </strong>
        </span>
    </span>
</div>
<br>
<table cellspacing="0" cellpadding="0" border="0" width="100%">
    <tr>
        <th></th>
        <th valign="top">
            <div id="top_menu">
                <div class="menuBar">
                    <span id="return" style="display:none">
                        <span onclick="return_msg(@user_id@);" style="cursor:pointer;">#messages.back#</span>
                    </span>
                    <span id="delete">
                        <span class="yui-skin-sam">
                            <span id="container">
                                <input id="show_delete" type="button" value="#messages.delete#"> 
                            </span>
                        </span>
                    </span>
                    <span id="delete_message_trash" style="display:none">
                        <span class="yui-skin-sam">
                            <span id="container">
                                <input id="show_delete_trash" type="button" value="#messages.delete#" onclick="delete_select_msg()"> 
                            </span>
                        </span>
                    </span>
                    <span id="delete_message" style="display:none">
                        <a class="menuButton" href="" onclick="return move_to(3);"></a>
                    </span>
                    <span id="select_msg" style="position:absolute;right:0;display:none;align:right">
                        <span id="msg_newer" style="text-align:right;cursor:pointer;">
                            <span class="menuButton" onclick="select_message('newer');">#messages.newer#  </span>
                        </span>
                        <span id="msg_older" style="text-align:right;cursor:pointer;">
                            <span class="menuButton" onclick="select_message('older');"> #messages.older#</span>
                        </span>
                    </span> 
                    <span>
                        <span id="move_to" sytle="display:true;">
                            <input  type="button" href="" onclick="show_div('fileMenu');return buttonClick(event, 'fileMenu');show_div('fileMenu');" value="#messages.move_to#  &darr;">
                    </span>
             </span>
                    <span id="more_actions_span">
                        <input type="button"  href="" onclick="show_div('more_actions');return buttonClick(event, 'more_actions');show_div('more_actions');" value="#messages.more_actions# &darr;">
                    </span>
                    <span id="search" class="menu">
                        <input type="text" size="40" id="search_data" onKeyUp="valid_search(this.value);" onKeyPress="checkKey(event,this.value);" title="#messages.search_tooltip_text#">
                        <input type="button" id="search_button" href="" onclick="search();" value="#messages.search#" disabled>
                    </span>
                </div>
                <div id="fileMenu" class="menu" onmouseover="menuMouseover(event);">
                    <multiple name="folders">
                        <if @folders.folder_id@ ne 1  and @folders.folder_id@ ne 4>
                            <a class="menuItem" href="javascript:onClick=move_to(@folders.folder_id@)" id="@folders.folder_id@">@folders.folder_name@</a>
                        </if>
                    </multiple>
                </div>
                <div id="more_actions" class="menu" onmouseover="menuMouseover(event);">
                    <span id="action_as_unread" align="left">
                        <a class="menuItem" href="javascript:more_actions('t',@folder_id@,@user_id@);" id="as_unread">#messages.as_unread#</a>
                    </span>
                    <span id="action_as_read">
                        <a class="menuItem" href="javascript:more_actions('f',@folder_id@,@user_id@);" id="as_read">#messages.as_read#</a>
                    </span>
                </div>
            </div>
        </th>
    </tr>
</table>
<table cellspacing="0" cellpadding="0" border="0" width="100%">
    <tr>
        <td valign="top">
            <br><br>
            <b><u><a href="send" >#messages.compose_mail#</a></u></b><br><br>
                <multiple name="folders">
                    <div id="background_@folders.folder_id@"  style="background-color:@folders.color@;weigth=100%;">
                        <a href="javascript:get_messages_folder(@folders.folder_id@);update_numbers(@folders.folder_id@,@user_id@);"> 
                            @folders.folder_name@ 
                            <input type="hidden" value="@folders.total_new_msg@" id="new_msg_folder_@folders.folder_id@">
                            <span id="number_@folders.folder_id@">
                            </span>
                        </a>
                    </div>
                </multiple>
            <br>
             &nbsp;<a class="button" href="message-option" >#messages.configuration#</a><br><br>
        </td>
        <td width="88%" valign="top" style="padding-left:10px">
            <script type="text/javascript">
                if (window.location.hash == "") {
                    get_messages_folder(0);
                } else {
                    var url_msg = window.location.hash.split('a');
                    var msg_id = url_msg[0].substring(1,url_msg[0].length);
                    read_message(msg_id,url_msg[1],url_msg[2]);
                }
            </script>
            <span id="folder_section_display">
            </span>
        </td>
    </tr>
</table>

