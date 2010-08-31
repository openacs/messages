//----------------- dialog delete

YAHOO.namespace("delete_msg.container");
function init_delete() {
	// Define various event handlers for Dialog
	var handleYes = function() {
            document.getElementById('msg_system').style.display = 'none';
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
            if (break_p) {
                document.getElementById('msg_action_p').value = 't';
                move_to(3);
                this.hide();
            } else {
                document.getElementById('msg_action_p').value = 'f';
                document.getElementById('msg_action').style.display = '';
                document.getElementById('msg_actions').innerHTML = document.getElementById('msg_select_msg').value;
                var folder_id_state = document.getElementById('folder_id').value;
                if (document.getElementById('folder_id_state') != null ) {
                    var folder_id_state = document.getElementById('folder_id_state').value;
                }
                get_messages_folder('more_actions');
                this.hide();
            }
	};
	var handleNo = function() {
            document.getElementById('msg_system').style.display = 'none';
            this.hide();
	};

	// Instantiate the Dialog
	YAHOO.delete_msg.container.delete_dialog = new YAHOO.widget.SimpleDialog("delete_dialog", 
                                        { modal: true,
				          visible: false,
				          fixedcenter: true,
				          constraintoviewport: true,
                                          iframe: true,
                                          close: false,
                                          width: "300px",
               				  text: document.getElementById('delete_confirm').value,
					  buttons: [ { text:document.getElementById('msg_yes').value, handler:handleYes, isDefault:true },
                                                      { text:"No",  handler:handleNo } ]
					 } );
	// Render the Dialog
	YAHOO.delete_msg.container.delete_dialog.render("container");
	YAHOO.util.Event.addListener("show_delete", "click", YAHOO.delete_msg.container.delete_dialog.show, null,YAHOO.delete_msg.container.delete_dialog);
}

YAHOO.util.Event.addListener(window, "load", init_delete);