//color azul #D4E4FF -- #C9D7F1
var normal_color = '#C0C0C0';
var select_color = '#F0F0F0';
//hidden all messages action when the user make some action
function hidden_msg_actions () {
    document.getElementById('msg_system').style.display = 'none';
    if (document.getElementById('message_action_p').value == 't' && document.getElementById('message_action') != null) {
        document.getElementById('message_action').style.display = 'none';
    }
    if (document.getElementById('msg_action_send_p').value == 't') {
    var msg_id = document.getElementById('msg_id_new_send').value;
        if (document.getElementById('msg_action_'+msg_id) != null ) {
            document.getElementById('msg_action_'+msg_id).style.display = '';
        }
        document.getElementById('msg_action_send_p').value = 'f';
    }
    if (document.getElementById('msg_action_p').value == 'f') {
        document.getElementById('msg_action').style.display = 'none';
    }
}

//this function make a request and loading the messages in folder option
function get_messages_folder (option) {
    document.getElementById('search_data').value = "";
    document.getElementById('search_button').disabled = true;
    document.getElementById('option').value = option;
    if (option == 'more_actions') {
        var option = document.getElementById('folder_id').value;
    } else {
        hidden_msg_actions();
        loading();
        document.getElementById('inbox_select_p').value = 't';
    }
    var folder_active_old = document.getElementById('folder_active').value;
    document.getElementById('reply_dialog_active').value = 'f';
    if (document.getElementById('background_' + folder_active_old).style.background != null ) {
           document.getElementById('background_' + folder_active_old).style.background = '#FFFFFF'; 
    }
    if (document.getElementById('background_' + option) != null ) {
        document.getElementById('background_' + option).style.background = normal_color;
    }
    document.getElementById('folder_active').value = option;
    document.getElementById('delete_message').style.display = 'none';
    document.getElementById('select_msg').style.display = 'none';
    document.getElementById('top_menu').style.display = '';
    if (document.getElementById('page_number') != null && folder_active_old == option) {
        var page_number = document.getElementById('page_number').value;
    } else {
        var page_number = 1;
    }
    var url = "inbox?folder_id="+option + "&page_number=" + page_number;
    var request = YAHOO.util.Connect.asyncRequest('GET', url, callback_get_messages_folder);
}


var handleSuccess_get_messages_folder = function(o){
    window.location.hash = "#";
    if (document.getElementById('inbox_select_p') != null && document.getElementById('inbox_select_p').value == 't') {
        document.getElementById('inbox_select_p').value = 'f';
        document.getElementById('msg_action').style.display = 'none';
        document.getElementById('msg_actions').innerHTML = '';
    }
    document.getElementById('folder_section_display').innerHTML = o.responseText;
    document.getElementById('return').style.display = 'none';
    document.getElementById('move_to').style.display = '';
    document.getElementById('more_actions_span').style.display = '';
    document.getElementById('delete_message_trash').style.display = 'none';
    if (document.getElementById('folder_id').value == 3) {
        document.getElementById('delete').style.display = 'none';
        document.getElementById('delete_message_trash').style.display = '';
    } else if  (document.getElementById('option').value == 1) {
        document.getElementById('move_to').style.display = 'none';
        document.getElementById('delete').style.display = 'none';
        document.getElementById('delete_message_trash').style.display = 'none';
    } else {
        document.getElementById('move_to').style.display = '';
        document.getElementById('more_actions_span').style.display = '';
        document.getElementById('delete').style.display = '';
        document.getElementById('delete_message_trash').style.display = 'none';
    }
    if (document.getElementById('move_to_p').value == 't') {
        move_to_action ()
    }

    if (document.getElementById('more_actions_p').value == 't') {
        more_action_do ()
    }
};

var handleFailure_get_messages_folder= function(o){ };

var callback_get_messages_folder = {success:handleSuccess_get_messages_folder,failure:handleFailure_get_messages_folder};

function show_members_rol (id) {
    if (id != 'dotlrn_student_rel' || id == 'rel_types_all') {
        var url_rols = "members-rol";
        var postData = "rel_type=" + id
        var request = YAHOO.util.Connect.asyncRequest('POST', url_rols, callback_rols,postData);
    }
}

var handleSuccess_rols = function(o) {
    document.getElementById('info_members_rols').innerHTML = o.responseText;
    YAHOO.roles.container_roles.dialog2.show();
}

var handleFailure_rols = function(o) { };

var callback_rols = {success:handleSuccess_rols,failure:handleFailure_rols};



function show_members_rol_index (id) {
    if (id != 'dotlrn_student_rel' || id == 'rel_types_all') {
        var url_rols = "members-rol";
        var postData = "rel_type=" + id
        var request = YAHOO.util.Connect.asyncRequest('POST', url_rols, callback_rols_index,postData);
    }
}

var handleSuccess_rols_index = function(o) {
    document.getElementById('rols_info_area').innerHTML = o.responseText;
    YAHOO.example.container.rols_container.show();
}

var handleFailure_rols_index = function(o) { };

var callback_rols_index = {success:handleSuccess_rols_index,failure:handleFailure_rols_index};

function move_to_action () {
    var count_msg_ids = document.getElementById('count_msg_ids').value;
    if ( count_msg_ids != 0 ) {
        document.getElementById('msg_action_p').value = 'f';
        document.getElementById('msg_action').style.display = '';
    } else {
        document.getElementById('msg_action_p').value = 't';
    }
    var folder_name = document.getElementById('folder_name').value;
    if (count_msg_ids == 1) {
        document.getElementById('msg_actions').innerHTML = document.getElementById('msg_moved_to').value + " \"" + folder_name + "\"";
    } else {
        document.getElementById('msg_actions').innerHTML = count_msg_ids + " "+ document.getElementById('more_msg_moved_to').value + " \"" + folder_name + "\"";
    }
    document.getElementById('move_to_p').value = 'f';
    document.getElementById('more_actions_p').value = 'f';
}

function more_action_do () {
    var ids_length = document.getElementById('ids_length').value;
    if (document.getElementById('more_actions_option').value == "t") {
        if (ids_length == 1) {
        var msg_action =  document.getElementById('msg_read').value;
        } else {
        var msg_action =  ids_length + " " + document.getElementById('more_msg_read').value;
        }
    } else {
        if (ids_length == 1) {
        var msg_action = document.getElementById('msg_unread').value;
        } else {
        var msg_action = ids_length + " " + document.getElementById('more_msg_unread').value;
        }
    }
    document.getElementById('msg_actions').innerHTML = msg_action;
    document.getElementById('more_actions_p').value = 'f';
}

//show loading image up the message send.
function showLoading(container) {
    if (container == 'send_mail') {
        var text_action = document.getElementById('sending').value;
    }
    document.getElementById(container+"_loading").style.display = '';
    document.getElementById(container+"_wait").innerHTML =  text_action + " <image src=/resources/ajaxhelper/images/indicator.gif>";
}

//this function make de submit form when send massage
function submit_normal() {
        var alert_p = 0
        var formObject = document.getElementsByName('compose_message');
        var form = formObject[0];
        var elements = form.elements;
        var rel_types_checked_p = 0;
        for ( var i = 0; i < elements.length ; i++) {
            if (elements[i].name == 'rel_types' && elements[i].checked) {
                rel_types_checked_p = 1;
                break;
            }
        }
        if (document.getElementsByName('ids[]').length == 0 && rel_types_checked_p == 0) {
            var continue_send = false;
            var msg_empty = document.getElementById("recipients_empty").value;
            alert(msg_empty);
            alert_p = 1;
            var continue_send = false;
        } else {
            var subject = document.getElementById('subject_field').value;
            if (subject.trim() == "") {
                var alert_p = 1;
                var continue_send = confirm(document.getElementById("subject_empty").value);
            } else {
                var continue_send = true;
                var alert_p = 0;
            }
            if (alert_p == 0) {
                var editor = Xinha.getEditor("message");
                var message = editor.getEditorContent();
                if (message.length == 0) {
                    var continue_send =  confirm(document.getElementById("body_empty").value);
                } else {
                    var continue_send = true;
                }
            }
        }
    if (!continue_send ) {
        self.close
    } else {
            showLoading('send_mail');
            var contact_length = document.getElementsByName('ids[]').length;
            var contact_ids = "";
            for (i=0; i< contact_length; i++) {
                    if ((i+1) == contact_length) {
                    contact_ids = contact_ids + document.getElementsByName('ids[]')[i].value;
                    } else {
                    contact_ids = contact_ids + document.getElementsByName('ids[]')[i].value + ",";
                    }
            }
            document.getElementById('total_attachment').value = number;
            document.getElementById('contacts_ids').value = contact_ids;
            document.getElementById('subject').value = subject;           
            document.compose_message.submit();
    }
}

var handleSuccess_send = function(o){
    window.location = "messages";
};

var handleUpload_send = function(o){
    window.location = "messages";
}

var handleFailure_send= function(o){
};

var callback_send={success:handleSuccess_send,failure:handleFailure_send,upload:handleUpload_send};
//finish submit function, send message normal


function show_div(divName) {
    document.getElementById(divName).style.display = '';
}

//this function make the move option
function move_to(option) {
    document.getElementById('msg_system').style.display = 'none';
    document.getElementById('option_move_to').value = option;
    document.getElementById('fileMenu').style.display = 'none';
    if (document.getElementById('message_action') != null) {
        document.getElementById('message_action').innerHTML = '';
        document.getElementById('message_action').style.display = '';
    }
    var formObject = document.getElementsByName('messages_list');
    var form = formObject[0];
    var elements = form.elements;
    var break_p = 0;
    for ( var i = 0; i < elements.length ; i++){
        if (elements[i].name == 'subject_id' && elements[i].checked) {
            break_p = 1;
            break;
        }
    }
    if (!break_p) {
        document.getElementById('msg_action_p').value = 'f';
        document.getElementById('msg_action').style.display = '';
        document.getElementById('msg_actions').innerHTML = document.getElementById('msg_select_msg').value;
        var folder_id_state = document.getElementById('folder_id').value;
        if (document.getElementById('folder_id_state') != null ) {
            var folder_id_state = document.getElementById('folder_id_state').value;
        }
    } else {
        var msg_ids = "";
        var count_msg_ids = 0;
        for ( var i = 0; i < elements.length ; i++) {
            if ( elements[i].name == 'subject_id' && elements[i].checked )  {
                    msg_ids = msg_ids + elements[i].value + ",";
                    count_msg_ids = count_msg_ids + 1;
            }
        }
        msg_ids = msg_ids.substring(0,msg_ids.length-1);
        document.getElementById('count_msg_ids').value = count_msg_ids;
        document.getElementById('folder_name').value = document.getElementById(option).innerHTML;
        loading();
        var url_move = "move-to?msg_ids=" + msg_ids + "&folder_id=" + option;
        var request = YAHOO.util.Connect.asyncRequest('GET', url_move, callback_move_to);
    }
}

var handleSuccess_move_to = function(o) {
    var owner_id = document.getElementById('owner_id').value;
    var folder_id_state = document.getElementById('folder_id').value;
    update_numbers();
    document.getElementById('move_to_p').value = 't';
    document.getElementById('checkbox_general').checked = false;
    if (document.getElementById('search_data').value == "") {
        get_messages_folder('more_actions');
    } else {
        var page_number = document.getElementById('page_number').value;
        search(page_number)
    }
};

var handleFailure_move_to = function(o){
};

var callback_move_to={success:handleSuccess_move_to,failure:handleFailure_move_to};


function update_numbers() {
    var formObject = document.getElementsByName('messages');
    var url_update_numbers = "update-numbers";
    var request = YAHOO.util.Connect.asyncRequest('GET', url_update_numbers, callback_update_numbers);
}

var handleSuccess_update_numbers = function(o){
    var response = o.responseText.split(',');
    var get_messages_folder_p = 0;
    if (document.getElementById('folder_id') != null) {
        var active_folder = document.getElementById('folder_id').value;
    } else {
        var active_folder = 0;
    }
    if (o.responseText != "" ) {
        for (var i=0; i < response.length; i= i+3) {
            if ( response[i+1] == active_folder) {
                get_messages_folder_p = 1
            }
            if (response[i] != "" && document.getElementById('new_msg_folder_'+response[i+1]) != null) {
                document.getElementById('new_msg_folder_'+response[i+1]).value = response[i];
                //if (document.getElementById('new_msg_folder_'+response[i+1]).value > 0 ) {
                    if ( response[i] > 0 ) {
                        document.getElementById('number_'+response[i+1]).innerHTML = "(<strong>" + response[i] + "</strong>/" + response[i+2] + ")";
                    } else {
                        document.getElementById('number_'+response[i+1]).innerHTML = "(" + response[i] + "/" + response[i+2] + ")";
                    }
                //} else {
                    //document.getElementById('number_'+response[i+1]).innerHTML = "";
                //}
            }
        }
    }
    if (get_messages_folder_p == 0 ) {
        if (document.getElementById('new_msg_folder_'+active_folder) != null) {
            document.getElementById('new_msg_folder_'+active_folder).value = 0;
        }
        if (document.getElementById('number_'+active_folder) != null ) {
            document.getElementById('number_'+active_folder).innerHTML = "";
        }
    }
};

var handleFailure_update_numbers= function(o){
};

var callback_update_numbers={success:handleSuccess_update_numbers,failure:handleFailure_update_numbers};


function paginate(folder_id,page_number,option) {
    document.getElementById('msg_action_p').value = 'f';
    hidden_msg_actions();
    loading();
    document.getElementById('inbox_select_p').value = 't';
    var formObject = document.getElementsByName('messages');
    if (option == 'newer') {
        var page_number = page_number - 1;
    }
    if (option == 'older') {
        var page_number = page_number + 1;
    }
    document.getElementById('page_number').value = page_number;
    if (document.getElementById('search_data').value == "") {
        var url_paginate = "inbox?folder_id=" + folder_id + "&page_number=" + page_number;
        var request = YAHOO.util.Connect.asyncRequest('GET', url_paginate, callback_paginate);
    } else {
        search(page_number);
    }
}

var handleSuccess_paginate = function(o){
    if (document.getElementById('inbox_select_p') != null && document.getElementById('inbox_select_p').value == 't') {
        document.getElementById('inbox_select_p').value = 'f';
        document.getElementById('msg_action').style.display = 'none';
        document.getElementById('msg_actions').innerHTML = '';
    }
    document.getElementById('folder_section_display').innerHTML = o.responseText;
};

var handleFailure_paginate= function(o){
};

var callback_paginate={success:handleSuccess_paginate,failure:handleFailure_paginate};

function read_message(msg_id,folder_id,page_number,action) {
    if (YAHOO.env.ua.ie) {
        scrollTo(0,document.getElementById('msg_action_'+msg_id).offsetTop);
    } else {
        if (document.getElementById('msg_action_'+msg_id) == null) {
            document.getElementById('scroll_top').scrollTo();
        } else {
            var msg_id_reply_action = document.getElementById('msg_id_action_reply').value;
            document.getElementById('reply_'+msg_id_reply_action).scrollTo();
        }
    }
    if ( document.getElementById('number_messages') != null) {
        var total_messages = document.getElementById('number_messages').value;
        document.getElementById('total_messages').value = document.getElementById('number_messages').value;
    } else {
        var total_messages = document.getElementById('total_messages').value;
    }
    document.getElementById('more_actions_span').style.display = 'none';
    document.getElementById('msg_action_p').value = 'f';
    hidden_msg_actions();
    document.getElementById('delete_message').style.display = 'none';
    loading();
    document.getElementById('inbox_select_p').value = 't';
    document.getElementById('return').style.display = '';
    document.getElementById('delete').style.display = 'none';
    document.getElementById('move_to').style.display = 'none';
    if (action == "new_msg") {
        document.getElementById('msg_action_send_p').value = 't';
    }
    var url = "read-message";
    var postData = "msg_id="+msg_id+"&folder_id="+folder_id+"&page_number="+page_number+"&total_messages="+total_messages;
    var request = YAHOO.util.Connect.asyncRequest('POST', url, callback_read_message,postData);
}


var handleSuccess_read_message = function(o){
    if (o.responseText.trim() == "false") {
        alert(document.getElementById('not_permission_read').value);
        get_messages_folder(0);
    } else {
        if (document.getElementById('msg_action_'+msg_id) != null) {
            document.getElementById('msg_action_'+msg_id).style.display = 'none';
        }
        if (document.getElementById('inbox_select_p') != null && document.getElementById('inbox_select_p').value == 't') {
            document.getElementById('inbox_select_p').value = 'f';
            document.getElementById('msg_action').style.display = 'none';
            document.getElementById('msg_actions').innerHTML = '';
        }
        document.getElementById('folder_section_display').innerHTML = o.responseText;
        if (document.getElementById('option_reply').value == 'forward') {
            document.getElementById('msg_action_send_p').value = 't';
            var msg_id = document.getElementById('msg_id_reply').value;
            document.getElementById('option_reply').value = '';
        } else {
            var msg_id = document.getElementById('msg_id_new_send').value;
        }
        if (document.getElementById('msg_action_send_p').value == 't') {
            if (document.getElementById('msg_action_'+msg_id) != null) {
                document.getElementById('msg_action_'+msg_id).style.display = '';
                document.getElementById('msg_action_id').value = msg_id;
                if (YAHOO.env.ua.ie) {
                    scrollTo(0,document.getElementById('msg_action_'+msg_id).offsetTop);
                } else {
                    document.getElementById('msg_action_'+msg_id).scrollTo();
                }
            }
        }
        if (document.getElementById('older_msg_id').value == '-1') {
            document.getElementById('msg_older').style.display = 'none';
        } else {
            document.getElementById('msg_older').style.display = '';
        }
        if (document.getElementById('newer_msg_id').value == '-1') {
            document.getElementById('msg_newer').style.display = 'none';
        } else {
            document.getElementById('msg_newer').style.display = '';
        }
        document.getElementById('select_msg').style.display = '';
        var owner_id = document.getElementById('owner_id').value;
        var folder_id_state = document.getElementById('folder_id').value;
        update_numbers();
        (new Image()).src='inbox/images/token.gif';
        (new Image()).src='inbox/images/token_selected.gif';
        (new Image()).src='inbox/images/token_hover.gif';
        (new Image()).src='inbox/images/token_x.gif';
        contact_users();
    }
};

var handleFailure_read_message = function(o){
};

var callback_read_message = {success:handleSuccess_read_message,failure:handleFailure_read_message};


function mostrardiv(msg_id) {
    document.getElementById('contact_list_'+msg_id).style.display = 'none';
    document.getElementById('msg_action_p').value = 'f';
    hidden_msg_actions();
    if (msg_id == undefined) {
        var msg_id = document.getElementById('msg_id_new_send').value;
    }
    if (document.getElementById('msg_action_'+msg_id) != null ) {
        document.getElementById('msg_action_'+msg_id).style.display = 'none';
    }
    document.getElementById('details_'+msg_id).style.display = '';
    document.getElementById('show_details_'+msg_id).style.display = 'none';
    document.getElementById('from_'+msg_id).style.display = '';
    document.getElementById('close_details_'+msg_id).style.display = '';
}

function close_dialog(msg_id) {
    div = document.getElementById('details_'+msg_id);
    div.style.display='none';
    div = document.getElementById('close_details_'+msg_id);
    div.style.display='none';
    div = document.getElementById('show_details_'+msg_id);
    div.style.display = '';
    document.getElementById('from_'+msg_id).style.display = 'none';
    document.getElementById('contact_list_'+msg_id).style.display = '';
}

function reply_message(option,msg_id) {
    document.getElementById('msg_reply').value = msg_id;
    if (option != "forward") {
        var url = "contacts?msg_id="+msg_id+"&option=" + option;
        var request = YAHOO.util.Connect.asyncRequest('GET', url, callback_reply);
    } else if (option == "forward") {
       document.getElementById('contact_reply').innerHTML = '';
        var url = "contacts?msg_id="+msg_id+"&option=" + option;
        var request = YAHOO.util.Connect.asyncRequest('GET', url, callback_reply);
    }
}


var handleSuccess_reply = function(o){
    var msg_id = document.getElementById('msg_reply').value;
    var parent_id = document.getElementById('parent_id_reply').value;
    if (o.responseText == "forward") {
        html_xinha_editor('forward');
        document.getElementById('submit_reply').innerHTML = "<a  class=button name=send_button value=Send type=button href=\"javascript:submit_reply(0,0)\" >"+document.getElementById('send_msg').value+"</a>";
    } else {
        html_xinha_editor('reply');
        document.getElementById('contact_reply').innerHTML = o.responseText;
        document.getElementById('submit_reply').innerHTML = "<a  class=button name=send_button value=Send type=button href=\"javascript:submit_reply("+msg_id+","+parent_id+");\" > " + document.getElementById('send_msg').value + "</a>";
    }
    initEditors();
}

var handleFailure_reply = function(o){
};

var callback_reply = {success:handleSuccess_reply,failure:handleFailure_reply};

function return_msg(owner_id) {
    document.getElementById('msg_action_p').value = 'f';
    hidden_msg_actions();
    var folder_id = document.getElementById('folder_id').value;
    var page_number = document.getElementById('page_number').value;
    div = document.getElementById('select_msg');
    div.style.display = 'none';
    if (document.getElementById('search_data').value == "") {
        var url = "inbox?page_number="+page_number+"&folder_id=" + folder_id;
        var request = YAHOO.util.Connect.asyncRequest('GET', url, callback_return_msg);
    } else {
        search(page_number);
    }
}

var handleSuccess_return_msg = function(o){
    var folder_id = document.getElementById('folder_id').value;
    if (YAHOO.env.ua.ie) {
        scrollTo(0,document.getElementById('scroll_top').offsetTop);
    } else {
        document.getElementById('scroll_top').scrollTo();
    }
    get_messages_folder(folder_id);
}

var handleFailure_return_msg = function(o){
};

var callback_return_msg = {success:handleSuccess_return_msg,failure:handleFailure_return_msg};

function cancel(msg_id) {
    var continue_cancel = confirm (document.getElementById('msg_cancel').value);
    if ( continue_cancel ) {
        document.getElementById('reply_dialog_active').value = 'f';
        if (YAHOO.env.ua.ie) {
            scrollTo(0,document.getElementById('show_details_'+msg_id).offsetTop);
        } else {
            document.getElementById('show_details_'+msg_id).scrollTo();
        }
        document.getElementById('response_reply_mail_' + msg_id).innerHTML = '';
        document.getElementById('reply_' + msg_id).style.background = normal_color;
        if ( document.getElementById('reply_all_' + msg_id) != null) { 
            document.getElementById('reply_all_'+ msg_id).style.background = normal_color;
        }
        document.getElementById('forward_'+ msg_id).style.background = normal_color;
    } else {
        self.close;
    }
}

function submit_reply(msg,parent_id) {
    document.getElementById('msg_action_p').value = 't';
    hidden_msg_actions();
    document.getElementById('msg_id_action_reply').value = msg;
    var subject = document.getElementById('subject_field').value;
    var msg_id = document.getElementById('msg_id').value;
    var editor = Xinha.getEditor("message");
    var message = editor.getEditorContent(); 
    var contact_length = document.getElementsByName('ids[]').length;
    var formObject = document.getElementsByName('compose_message');
    var form = formObject[0];
    var elements = form.elements;
    var rel_types_checked_p = 0;
    for ( var i = 0; i < elements.length ; i++) {
        if (elements[i].name == 'rel_types' && elements[i].checked) {
            rel_types_checked_p = 1;
            break;
        }
    }
    var alert_p = 0
    if (document.getElementsByName('ids[]').length == 0 && rel_types_checked_p == 0) {
        var continue_send = false;
        var msg_empty = document.getElementById("recipients_empty").value;
        alert(msg_empty);
        alert_p = 1;
        var continue_send = false;
    } else {
        if (message.length == 0) {
            var continue_send = false;
            var continue_send =  confirm(document.getElementById("body_empty").value);
        } else {
            var continue_send = true;
        }
    }
    if (!continue_send ) {
            self.close
    } else {
        showLoading('send_mail');
        document.getElementById('reply_dialog_active').value = 'f';
        var contact_ids = "";
        for (i=0; i< contact_length; i++) {
            if ((i+1) == contact_length) {
                contact_ids = contact_ids + document.getElementsByName('ids[]')[i].value;
            } else {
                contact_ids = contact_ids + document.getElementsByName('ids[]')[i].value + ",";
            }
        }
        if (YAHOO.env.ua.ie) {
                YAHOO.util.Connect.setForm(form,true,true);
        } else {
                YAHOO.util.Connect.setForm(form,true);
        }
        var elements = form.elements;
        var attachment_ids = "";
        for ( var i = 0; i < elements.length ; i++) {
            if ( elements[i].name == 'attachment_checkbox' && elements[i].checked )  {
                    attachment_ids = attachment_ids + elements[i].id + ",";
            }
        }
        attachment_ids = attachment_ids.substring(0,attachment_ids.length-1);
        var msg_id_old = document.getElementById('msg_id_reply').value;
        var url_send_mail = "send-mail";
        var postData= "parent_id=" + msg_id +  "&contacts_ids=" + contact_ids + "&total_attachment=" + number + "&subject=" + subject+"&reply=true&general_parent_id=" + parent_id + "&msg_id_old=" + msg_id_old + "&attachment_ids=" + attachment_ids;
        var request = YAHOO.util.Connect.asyncRequest('POST', url_send_mail, callback_send_mail, postData);
    }
}

var handleSuccess_send_mail = function(o){ };

var handleUpload_send_mail = function(o){
    document.getElementById('msg_id_new_send').value = o.responseText;
    if (document.getElementById('read') == null) {
        window.location = "messages";
    } else {
        document.getElementById('autocomplete_loding').innerHTML = "<div tabindex=\"-1\" id=ids class=\"clearfix tokenizer\" onclick=\"$('autocomplete_input').focus()\"> <span class=\"tokenizer_stretcher\">^_^</span> <span class=\"tab_stop\"><input type=\"text\" id=\"hidden_input\" tabindex=\"-1\"></span> <span id=contact_reply> </span> <div id=\"autocomplete_display\" class=\"tokenizer_input\"> <input type=\"text\" size=\"1\" tabindex=\"\" id=\"autocomplete_input\" /> </div> </div> <div id=\"autocomplete_populate\" class=\"clearfix autocomplete typeahead_list\" style=\"width: 358px; height: auto; overflow-y: hidden;display:none\"> <div class=\"typeahead_message\">Type the name of a member</div></div>"
        var msg_id = document.getElementById('msg_id').value;
        var folder_id = document.getElementById('folder_id').value;
        var page_number = document.getElementById('page_number');
        read_message(msg_id,folder_id,page_number,'new_msg');
    }
};

var handleFailure_send_mail= function(o){ };

var callback_send_mail={success:handleSuccess_send_mail,failure:handleFailure_send_mail,upload:handleUpload_send_mail};

function select_message(option) {
    document.getElementById('msg_action_p').value = 'f';
    hidden_msg_actions();
    var folder_id = document.getElementById('folder_id').value;
    var page_number = document.getElementById('new_page_number').value;
    var div = document.getElementById('return');
    div.style.display='';
    if (option == 'older') {
        var older_msg_id = document.getElementById('older_msg_id').value;
        var newer_msg_id = document.getElementById('msg_id').value;
        var newest_msg_id = document.getElementById('newest_msg_id').value;
        var oldest_msg_id = document.getElementById('oldest_msg_id').value;
        var msg_id = older_msg_id;
        if (oldest_msg_id == '-1') {
            document.getElementById('msg_older').style.display = 'none';
        } else {
            document.getElementById('msg_older').style.display = '';
        }
        if (newer_msg_id == '-1') {
            document.getElementById('msg_newer').style.display = 'none';
        } else {
            document.getElementById('msg_newer').style.display = '';
        }

    } else if (option == 'newer') {
        var older_msg_id = document.getElementById('msg_id').value;
        var newer_msg_id = document.getElementById('newer_msg_id').value;
    var newest_msg_id = document.getElementById('newest_msg_id').value;
    var oldest_msg_id = document.getElementById('oldest_msg_id').value;
        var msg_id = newer_msg_id;
        if (newest_msg_id == '-1') {
            document.getElementById('msg_newer').style.display = 'none';
        } else {
            document.getElementById('msg_newer').style.display = '';
        }
    if (older_msg_id == '-1') {
            document.getElementById('msg_older').style.display = 'none';
        } else {
            document.getElementById('msg_older').style.display = '';
        }
    }
    loading();
    var url = "read-message?msg_id="+msg_id+"&folder_id="+folder_id+"&page_number="+page_number;
    var request = YAHOO.util.Connect.asyncRequest('GET', url, callback_select_message);
}

var handleSuccess_select_message = function(o){
    document.getElementById('folder_section_display').innerHTML = o.responseText;
    var owner_id = document.getElementById('owner_id').value;
    var folder_id_state = document.getElementById('folder_id').value;
    update_numbers();
    (new Image()).src='inbox/images/token.gif';
    (new Image()).src='inbox/images/token_selected.gif';
    (new Image()).src='inbox/images/token_hover.gif';
    (new Image()).src='inbox/images/token_x.gif';
    contact_users();
    loading_cancel();
};

var handleFailure_select_message = function(o){ };

var callback_select_message = {success:handleSuccess_select_message,failure:handleFailure_select_message};

function more_actions_select(){
    document.getElementById('msg_action_p').value = 'f';
    hidden_msg_actions();
    var formObject = document.getElementsByName('messages_list');
    var form = formObject[0];
    var elements = form.elements;
    var break_p = 0;
    var new_p = 0;
    for ( var i = 0; i < elements.length ; i++){
        if (elements[i].name == 'subject_id' && elements[i].checked) {
            break_p = 1;
            if (document.getElementById('new_p.'+elements[i].value) != null) {
                new_p = 1;
                break;
            }
        }
    }
    if (break_p) {
        if (document.getElementById('more_actions_options') != null) {
            document.getElementById('action_as_unread').style.display = '';
        }
    } else {
        if (document.getElementById('more_actions_options') != null) {
            document.getElementById('more_actions_options').style.display = 'none';
        }
    }
}

function delete_select_msg () {
    document.getElementById('msg_system').style.display = 'none';
    document.getElementById('more_actions').style.display = 'none';
    document.getElementById('msg_action_p').value = 'f';
    var formObject = document.getElementsByName('messages_list');
    var form = formObject[0];
    var elements = form.elements;
    var msg_ids = "";
    var count_msg_ids_select = 0
    for ( var i = 0; i < elements.length ; i++) {
        if ( elements[i].name == 'subject_id' && elements[i].checked )  {
                msg_ids = msg_ids + elements[i].value + ",";
                count_msg_ids_select = count_msg_ids_select + 1;
        }
    }
    if (!count_msg_ids_select) {
        document.getElementById('msg_action_p').value = 'f';
        document.getElementById('msg_action').style.display = '';
        document.getElementById('msg_actions').innerHTML = document.getElementById('msg_select_msg').value;
        var folder_id_state = document.getElementById('folder_id').value;
        if (document.getElementById('folder_id_state') != null ) {
            var folder_id_state = document.getElementById('folder_id_state').value;
        }
        alert("debe de seleccionar al menos un mensaje para borrar");
    } else {
        msg_ids = msg_ids.substring(0,msg_ids.length-1);
        document.getElementById('ids_more_actions').value = msg_ids;
        var url_delete_msg = "delete-message";
        var postData = "msg_ids=" + msg_ids;
        document.getElementById('msg_action').style.display = '';
        loading();
        document.getElementById('ids_length').value = count_msg_ids_select;
        var request = YAHOO.util.Connect.asyncRequest('POST', url_delete_msg, callback_delete_msg,postData);
    }
}

var handleSuccess_delete_msg = function(o){
    get_messages_folder(3);
    update_numbers();
};

var handleFailure_delete_msg = function(o){
};

var callback_delete_msg={success:handleSuccess_delete_msg,failure:handleFailure_delete_msg};

function more_actions(option,folder_id,owner_id) {
    document.getElementById('msg_system').style.display = 'none';
    document.getElementById('more_actions').style.display = 'none';
    document.getElementById('msg_action_p').value = 'f';
    var formObject = document.getElementsByName('messages_list');
    var form = formObject[0];
    var elements = form.elements;
    var msg_ids = "";
    var count_msg_ids_select = 0
    for ( var i = 0; i < elements.length ; i++) {
        if ( elements[i].name == 'subject_id' && elements[i].checked )  {
                msg_ids = msg_ids + elements[i].value + ",";
                count_msg_ids_select = count_msg_ids_select + 1;
        }
    }
    if (!count_msg_ids_select) {
        document.getElementById('msg_action_p').value = 'f';
        document.getElementById('msg_action').style.display = '';
        document.getElementById('msg_actions').innerHTML = document.getElementById('msg_select_msg').value;
        var folder_id_state = document.getElementById('folder_id').value;
        if (document.getElementById('folder_id_state') != null ) {
            var folder_id_state = document.getElementById('folder_id_state').value;
        }
    } else {
        msg_ids = msg_ids.substring(0,msg_ids.length-1);
        document.getElementById('ids_more_actions').value = msg_ids;
        var url_more_actions = "more-actions";
        var postData = "msg_ids=" + msg_ids + "&option_select=" + option;
        document.getElementById('msg_action').style.display = '';
        loading();
        document.getElementById('ids_length').value = count_msg_ids_select;
        var request = YAHOO.util.Connect.asyncRequest('POST', url_more_actions, callback_more_actions,postData);
    }
}


var handleSuccess_more_actions = function(o){
    var folder_id_state = document.getElementById('folder_id').value;
    var owner_id = document.getElementById('owner_id').value;
    document.getElementById('more_actions_option').value = o.responseText;
    var ids = (document.getElementById('ids_more_actions').value).split(',');
    if (o.responseText == 't') {
        var option_style = 'bold';
    } else {
        var option_style = '';
    }
    var count_new_msg = 0;
    var count_read_msg = 0;
    for (var count=0; count < ids.length; count++) {
        if (document.getElementById('new_p_style.' + ids[count]) != null) {
            if (document.getElementById('new_p_style.' + ids[count]).style.fontWeight == '') {
                if (o.responseText == 't') {
                    count_new_msg = count_new_msg+1;
                }
            } else {
                if (o.responseText == 'f') {
                    count_read_msg = count_read_msg+1;
                }
            }
            document.getElementById('new_p_style.' + ids[count]).style.fontWeight = option_style;
            document.getElementById('new_p_sub.' + ids[count]).style.fontWeight = option_style;
            if (document.getElementById('new_p_comm.' + ids[count]) != null ) {
                document.getElementById('new_p_comm.' + ids[count]).style.fontWeight = option_style;
            }
            document.getElementById('new_p_date.' + ids[count]).style.fontWeight = option_style;
        }
        if (document.getElementById('check_box_msg.' + ids[count]) != null) {
            document.getElementById('check_box_msg.' + ids[count]).checked = 0;
        }
    }
    document.getElementById('msg_action').style.display = '';
    if (ids == "") {
        document.getElementById('msg_actions').innerHTML = document.getElementById('msg_select_msg').value;
    } else {
        if (o.responseText == 't') {
            if (count_new_msg > 1) {
                document.getElementById('msg_actions').innerHTML = count_new_msg + " " + document.getElementById('more_msg_unread').value;
            } else {
                document.getElementById('msg_actions').innerHTML = document.getElementById('msg_unread').value;
            }
        } else {
            if(count_read_msg > 1) {
                document.getElementById('msg_actions').innerHTML = count_read_msg + " " + document.getElementById('more_msg_read').value;
            } else {
                document.getElementById('msg_actions').innerHTML = document.getElementById('msg_read').value;
            }
        }
    }
    var total_new_msg = document.getElementById('new_msg_folder_'+ folder_id_state).value;
    if (o.responseText == 't') {
        var new_messages = (parseInt(total_new_msg)+parseInt(count_new_msg));
    } else {
        var new_messages = (parseInt(total_new_msg)-parseInt(count_read_msg));
    }
    document.getElementById('new_msg_folder_'+ folder_id_state).value = new_messages;
    document.getElementById('more_actions_p').value = 't';
    if (document.getElementById('checkbox_general') != null ) {
        document.getElementById('checkbox_general').checked = false;
    }
    update_numbers();
};

var handleFailure_more_actions= function(o){
};

var callback_more_actions={success:handleSuccess_more_actions,failure:handleFailure_more_actions};

function loadEditors(editorTag){
    var editorContent = document.getElementById(editorTag);
    if (editorContent != null && editorContent.innerHTML != "") {
        var content = editorContent.innerHTML;
        eval(editorContent.innerHTML);
        editorContent.innerHTML = "";
    }
}

var xinhaTimer;
var initEditorsTry = 0;
var iframe_id = "";

function initEditors(){
    var ids = document.getElementById('advancedMessagesIds');
    var no_ids = document.getElementById('noTabsEditors');
    if (ids != null) {
        var id = ids.innerHTML;
        var id = id.trim();
        var id = id.replace(/\'/g,"");
        loadEditors('advancedMessagesEditor');
    } else {
        if (no_ids == null && initEditorsTry < 20) {
            initEditorsTry++;
            xinhaTimer = window.setTimeout("initEditors()",500);
            return false;
        }
    }
    initEditorsTry = 0;
    window.clearTimeout(xinhaTimer);
}

String.prototype.trim = function () {
    return this.replace(/^\s*/, "").replace(/\s*$/, "");
}


function reply_dialog (option,msg_id,general_parent_id){
    var msg_action_id = document.getElementById('msg_action_id').value;
    document.getElementById('msg_action_p').value = 'f';
    hidden_msg_actions();
    if (document.getElementById('msg_action_' + msg_action_id) != null ) {
        document.getElementById('msg_action_' + msg_action_id).style.display = 'none';
    }
    if (document.getElementById('reply_dialog_active').value == 't') {
        var msg_id_reply = document.getElementById('msg_id_reply').value;
        if (msg_id_reply != msg_id) {
            var continue_reply = confirm(document.getElementById("other_msg_reply").value + "  " + document.getElementById("msg_cancel").value);
        } else {
            var continue_reply = 'false';
        }
    } else {
        document.getElementById('reply_dialog_active').value = 't';
        var continue_reply = 'false';
    }
    if (!continue_reply ) {
            self.close
    } else {
        document.getElementById('autocomplete_loding').innerHTML = '';
        document.getElementById('msg_action_p').value = 'f';
        hidden_msg_actions();
        document.getElementById('reply_'+msg_id).focus();
        number = 0;
        document.getElementById('parent_id_reply').value = general_parent_id;
        document.getElementById('msg_action_' + msg_id).style.display = 'none';
        var msg_id_reply = document.getElementById('msg_id_reply').value;
        //pasar lo de los colores a variables y colocarlas hasta arriba
        if (msg_id_reply != msg_id && msg_id_reply != "" && document.getElementById('response_reply_mail_'+msg_id_reply) != null) {
            document.getElementById('response_reply_mail_'+msg_id_reply).innerHTML = "";
            document.getElementById('reply_' + msg_id_reply).style.background = normal_color;
            if ( document.getElementById('reply_all_' + msg_id_reply) != null) { 
                document.getElementById('reply_all_'+ msg_id_reply).style.background = normal_color;
            }
            document.getElementById('forward_'+ msg_id).style.background = normal_color;
        }
        if (option == "reply") {
            document.getElementById('reply_'+msg_id).style.background = select_color;
        } else {
            document.getElementById('reply_'+msg_id).style.background = normal_color;
        }
        if (option == "reply_all") {
            document.getElementById('reply_all_'+msg_id).style.background = select_color;
        } else {
            if ( document.getElementById('reply_all_'+msg_id) != null) { 
                document.getElementById('reply_all_'+msg_id).style.background = normal_color;
            }
        }
        if (option == "forward") {
            document.getElementById('forward_'+msg_id).style.background = select_color;
        } else {
            document.getElementById('forward_'+msg_id).style.background = normal_color;
        }
        document.getElementById('option_reply').value = option;
        if (document.getElementById('response_reply_mail_'+msg_id).innerHTML.length < 14 ) { 
            document.getElementById('top_menu').style.display = 'none';
            document.getElementById('msg_id_reply').value = msg_id;
            var url = "send?reply_p=1&reply_send=0&msg_id="+msg_id+ "&general_parent_id=" + general_parent_id + "&reply_option=" + option;
            var request = YAHOO.util.Connect.asyncRequest('GET', url, callback_reply_dialog);
        } else {
            var option = document.getElementById('option_reply').value;
            if (option == "forward") {
                document.getElementById('attachment_forward').style.display = '';
            }  else {
                document.getElementById('attachment_forward').style.display = 'none';
            }
            var rel_types_checked = document.getElementById('rel_types_checked').value.split(",");
            if (option == "reply_all" ) {
                for (var i=0;i < rel_types_checked.length; i = i + 1) {
                    if (document.getElementById(rel_types_checked[i]) != null) {
                        document.getElementById(rel_types_checked[i]).checked = true;
                    }
                }
            } else {
                for (var i=0;i < rel_types_checked.length; i = i + 1) {
                    if (document.getElementById(rel_types_checked[i]) != null) {
                        document.getElementById(rel_types_checked[i]).checked = false;
                    }
                }
            }
            if (YAHOO.env.ua.ie) {
                var offset = document.getElementById('scroll_message_'+msg_id).offsetTop;
                scrollTo(0,offset + 200);
            } else {
                document.getElementById('scroll_message_'+msg_id).scrollTo();
            }
            reply_message(option,msg_id);
        }
    }
}

var handleSuccess_reply_dialog = function(o){
    var msg_id = document.getElementById('msg_id_reply').value;
    if (YAHOO.env.ua.ie) {
        var offset = document.getElementById('scroll_message_'+msg_id).offsetTop;
        scrollTo(0,offset + 200);
    } else {

        document.getElementById('scroll_message_'+msg_id).scrollTo();
    }
    var option = document.getElementById('option_reply').value;
    document.getElementById('response_reply_mail_'+msg_id).innerHTML = o.responseText;
    document.getElementById('top_menu').style.display = '';
    //window.location.hash = "#scroll_message_"+msg_id;
    if (option == "forward") {
        document.getElementById('attachment_forward').style.display = '';
    }  else {
        document.getElementById('attachment_forward').style.display = 'none';
    }
    if (document.getElementById('rel_types_checked').value != "" ) {
        var rel_types_checked = document.getElementById('rel_types_checked').value.split(",");
        if (option == "reply_all" ) {
            for (var i=0;i < rel_types_checked.length; i = i + 1) {
                try { 
                    document.getElementById(rel_types_checked[i]).checked = true;
                } catch(err) {}
            }
        } else {
            for (var i=0;i < rel_types_checked.length; i = i + 1) {
                try {
                    document.getElementById(rel_types_checked[i]).checked = false;
                } catch(err) {}
            }
        }
    }
    reply_message(option,msg_id);
    contact_users();
    initEditors();
    (new Image()).src='inbox/images/token.gif';
    (new Image()).src='inbox/images/token_selected.gif';
    (new Image()).src='inbox/images/token_hover.gif';
    (new Image()).src='inbox/images/token_x.gif';
};

var handleFailure_reply_dialog = function(o){
};

var callback_reply_dialog = {success:handleSuccess_reply_dialog,failure:handleFailure_reply_dialog};

function valid_search(value) {
    if (value != "") {
        document.getElementById('search_button').disabled = false;
    } else {
        document.getElementById('search_button').disabled = true;
    }
}

function checkKey(key,value) {
    var unicode
    if (key.charCode) {
        unicode=key.charCode;
    } else {
        unicode=key.keyCode;
    }
    if (unicode == 13){
        valid_search(value);
        search();
    }
}

function search(page_number) {
    document.getElementById('show_delete').style.display = '';
    document.getElementById('move_to').style.display = '';
    document.getElementById('show_delete').style.display = '';
    document.getElementById('msg_system').style.display = 'none';
    var data_search = document.getElementById('search_data').value;
    var url_search = "search";
    if (page_number == undefined ) {
        var postData = "data_search=" + data_search;
    } else {
        var postData = "data_search=" + data_search + "&page_number=" + page_number;
    }
    document.getElementById('msg_action').style.display = '';
    loading();
    var request = YAHOO.util.Connect.asyncRequest('POST', url_search, callback_search,postData);
}

var handleSuccess_search = function(o){
    document.getElementById('msg_action').style.display = 'none';
    document.getElementById('msg_actions').innerHTML = '';
    document.getElementById('folder_section_display').innerHTML = o.responseText;
};

var handleFailure_search = function(o){
};

var callback_search = {success:handleSuccess_search,failure:handleFailure_search};


function delete_text_input (name) {
    var text_length = document.getElementById('autocomplete_input').value.length;
    if ( text_length > 0 && this.focus() != undefined) {
        alert(document.getElementById('autocomplete_input').value + "  " + document.getElementById('msg_invalid_user').value);
    }
    document.getElementById('autocomplete_input').value = '';
}

function loading() {
    document.getElementById('msg_action').style.display = '';
    var text_action = document.getElementById('msg_loading').value;
    document.getElementById('msg_actions').innerHTML = text_action + " <image src=/resources/ajaxhelper/images/indicator.gif>";
}

function loading_cancel() {
    document.getElementById('msg_action').style.display = 'none';
    document.getElementById('msg_actions').innerHTML = '';
}

function empty_trash() {
    var continue_empty = confirm(document.getElementById("msg_continue_empty").value);
    if (!continue_empty ) {
        self.close
    } else {
        loading();
        var url = "empty-trash";
        var request = YAHOO.util.Connect.asyncRequest('GET', url, callback_empty_trash);
    }
}

var handleSuccess_empty_trash = function(o){
    document.getElementById('folder_id').value = 3;
    get_messages_folder('more_actions');
    document.getElementById('msg_action_p').value = 't';
    document.getElementById('msg_action').style.display = '';
    var text_action = document.getElementById('confirm_trash_empty').value;
    document.getElementById('msg_actions').innerHTML = text_action;
};

var handleFailure_empty_trash = function(o){ };

var callback_empty_trash = {success:handleSuccess_empty_trash,failure:handleFailure_empty_trash};

function id_delete (contact_id) {
    document.getElementById('span_' + contact_id).innerHTML = '';
    var add = document.getElementById('contact_reply');
    var olddiv = document.getElementById('span_' + contact_id);
    add.removeChild(olddiv);
}

function select_all(form,option){
    var formObject = document.getElementsByName(form.name);
    var form = formObject[0];
    var elements = form.elements;
    for ( var i = 0; i < elements.length ; i++){
        if (elements[i].name == 'subject_id' && elements[i].type == "checkbox") {
            elements[i].checked = option;
        }
    }
} 

function select_all_rel_types(option){
    var formObject = document.getElementsByName('compose_message');
    var form = formObject[0];
    var elements = form.elements;
    var rel_types_checked_p = 0;
    for ( var i = 0; i < elements.length ; i++) {
        if (elements[i].name == 'rel_types') {
            elements[i].checked = option;
        }
    }
}

function semuestra (name) {
    document.getElementById(name).style.visible = '';
}

function html_xinha_editor (option) {
    var editor = Xinha.getEditor("message");
    if ( editor._doc != null) {
        var message = editor.getEditorContent();
        var position = message.search('id="history_conversation">');
        if (option == 'forward') {
            var history_conversation = document.getElementById('history_conversation').innerHTML;
            var signature_text_position = message.search('id="signature"');
            if ( signature_text_position > 0) {
                var message = message.substring(0,signature_text_position-5);
            }
            var signature = document.getElementById('signature').innerHTML;
            editor._doc.body.innerHTML = history_conversation + "<br><br>" + signature;
        } else {
            var signature = document.getElementById('signature').innerHTML;
            if ( position > 0) {
                var message = message.substring(0,position-15);
            }
            editor._doc.body.innerHTML = "<br><br><br>" +signature;
        }
    }
}
