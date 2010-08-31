<body bgcolor="#E0ECF8"> 

<script type="text/javascript" src="/resources/ajaxhelper/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
<script type="text/javascript" src="/resources/ajaxhelper/yui/container/container_core.js"></script>
<script type="text/javascript" src="/resources/ajaxhelper/yui/menu/menu.js"></script>
<script type="text/javascript" src="/resources/ajaxhelper/yui/element/element-beta-min.js"></script>
<script type="text/javascript" src="/resources/ajaxhelper/yui/yahoo/yahoo-min.js"></script>
<script type="text/javascript" src="/resources/ajaxhelper/yui/event/event-min.js"></script>
<script type="text/javascript" src="/resources/ajaxhelper/yui/dom/dom-min.js"></script>
<script type="text/javascript" src="/resources/ajaxhelper/yui/button/button-beta-min.js"></script>

<script type="text/javascript" src="/resources/ajaxhelper/yui/utilities/utilities.js"></script>
<script type="text/javascript" src="/resources/ajaxhelper/yui/connection/connection-min.js"></script>



<script src="/resources/messages/messages.js" type="text/javascript"></script>
<input type=hidden id=new_folder_name_error value="#messages.new_folder_name_error#">
<div align=center>
    <form>
        <label>#messages.name_new_folder#:</label><br>
        <input type=text id=new_folder_name><br><br>
        <input  class="button" name="send_button" value="#messages.create#" type="button" onclick=create_new_folder(); >
        <input  class="button" name="cancel_button" value="#messages.cancel#" type="button" onclick=window.close()>
    </form>
</div>  