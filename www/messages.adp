<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>
<script type="text/javascript">
document.documentElement.className = "yui-pe";
document.body.className += 'yui-skin-sam';
</script>
<input type="hidden" id="dialog_rol_set" value="0">
<script type="text/javascript" src="/resources/messages/dispatcher.js"></script>
<script type="text/javascript" src="/resources/messages/rol-dialog.js"></script>
<script type="text/javascript" src="/resources/messages/message-dialog-roles.js"></script>

<include src="messages-actions">
<input type="hidden" id="add" value="#messages.add#">
<input type="hidden" id="owner_id" value="@user_id;noquote@">
<input type="hidden" id="not_permision_read" value="#messages.not_permision_read#">
<span id="scroll_top"></span>


<div id="mydynamicarea">
    <div style="height:auto;text-align:center">
        <span id="msg_action" style="display:none">
            <span class="alert">
                <strong>
                    <span id="msg_actions"></span>
                </strong>
            </span>
        </span>
    </div>
</div>

<script type="text/javascript">
    loading();
    YAHOO.plugin.Dispatcher.fetch ( 'mydynamicarea', 'messages-folders' );
</script>

<div id="dialog1" class="yui-pe-content">
    <div class="bd">
        <div id="info_members_rols" "style="width:28em;height:30em;overflow:auto"> 
        </div>
    </div>
</div>
 