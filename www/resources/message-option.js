var browser = navigator.appName;

function convert_input(folder_id) {
    if (document.getElementById('active').value == 'f') {
        var msg_cancel = document.getElementById('cancel').value;
        var msg_save = document.getElementById('save_info').value;
        var name = document.getElementById('folder_' + folder_id).innerHTML;
        document.getElementById('folder_' + folder_id).innerHTML = "<input id=input_folder_" + folder_id + " value=\"" + name +  "\"><a  class=button name=send_button value=Send type=button href=\"#\" onclick=\"update_folder(" + folder_id + ",'save');\" > " + msg_save + "</a>  <a  class=button name=cancel_button value=Cancel type=button href=\"#\" onclick=\"update_folder(" + folder_id + ",'cancel');\" > " + msg_cancel + "</a>";
        document.getElementById('active').value = 't';
        document.getElementById('name_cancel').value = document.getElementById('input_folder_' + folder_id).value;
    }
}

function cancel_folder(folder_id) {
    if (document.getElementById('delete_p').value == 't') {
        document.getElementById('span_folder_' + folder_id).innerHTML = '';
        document.getElementById('span_folder_delete_' + folder_id).innerHTML = '';
        document.getElementById('delete_p').value == 'f';
    } else {
        if (document.getElementById('cancel_p').value == 't') {
            document.getElementById('folder_' + folder_id).innerHTML = document.getElementById('name_cancel').value;
        } else {
            if (document.getElementById('input_folder_' + folder_id) != null) {
                var name = document.getElementById('input_folder_' + folder_id).value;
                document.getElementById('folder_' + folder_id).innerHTML = '';
                document.getElementById('active').value = 'f';
                document.getElementById('folder_' + folder_id).innerHTML = name;
            }
        }
    }
}

function update_folder (folder_id,option) {
    var url = "update-name"
    if (option == 'save' ) {
        document.getElementById('delete_p').value = 'f';
        document.getElementById('cancel_p').value == 'f';
        var postData = "name=" + document.getElementById('input_folder_' + folder_id).value + "&folder_id=" + folder_id;
    } else if (option == 'cancel') {
        document.getElementById('delete_p').value = 'f';
        document.getElementById('cancel_p').value = 't';
        var postData = "folder_id=" + folder_id;
    } else if (option == 'delete') {
        var continue_send = confirm(document.getElementById("msg_delete_folder").value);
        if (!continue_send ) {
		self.close
	} else {
            document.getElementById('delete_p').value = 't';
            var postData = "delete=t&folder_id=" + folder_id;
        }
    }
    var request = YAHOO.util.Connect.asyncRequest('POST', url, callback, postData);
}

var handleSuccess = function(o){
    cancel_folder(o.responseText);
};

var handleFailure= function(o){
};

var callback = {success:handleSuccess,failure:handleFailure};

function delete_folder(){
    dialog1.show();
}

var handleYes1 = function() {
    dialog1.hide();
}
var handleNo1 = function() { dialog1.hide(); return false; }

var dialog1 = new YAHOO.widget.Dialog("confirm_dialog1",
                    { width: "450px",
                    fixedcenter: true,
                    visible: true,
                    draggable: false,
                    close: false,
                    modal: true,
                    buttons: [ { text:'Confirm', handler:handleYes1 },
                               { text:'Cancel',  handler:handleNo1 } ]
                    } );
dialog1.render();
