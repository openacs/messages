    YAHOO.namespace("new_folder.container");
    YAHOO.util.Event.onDOMReady(function () {
            // Define various event handlers for Dialog
            var handleSubmit = function() {
                    this.submit();
            };
            var handleCancel = function() {
                    this.cancel();
            };
            var handleSuccess = function(o) {
                    var response = o.responseText;
                    response = response.split("<!")[0];
                    var response_error = response.substring(0,5);
                    if ( response_error == 'error' ) {
                        alert(response.substring(5,response.length));
                    } else {
                        //alert(response);
                        //document.getElementById("resp").innerHTML = response;
                        window.location.reload();
                    }
            };
            var handleFailure = function(o) {
                    alert("Submission failed: " + o.status);
            };
        // Remove progressively enhanced content class, just before creating the module
        YAHOO.util.Dom.removeClass("dialog1", "yui-pe-content");
            // Instantiate the Dialog
            YAHOO.new_folder.container.dialog1 = new YAHOO.widget.Dialog("dialog1", 
                                        { modal: true,
				          visible: false,
				          fixedcenter: true,
				          constraintoviewport: true,
                                          iframe: true,
                                          close: false,
                                          width: "300px",
                                          buttons : [ { text:document.getElementById('msg_create').value, handler:handleSubmit, isDefault:true },
                                          { text:document.getElementById('cancel').value, handler:handleCancel } ]
                                        });
            // Validate the entries in the form to require that both first and last name are entered
            // Wire up the success and failure handlers
            YAHOO.new_folder.container.dialog1.callback = { success: handleSuccess,
                                                        failure: handleFailure };
            // Render the Dialog
            YAHOO.new_folder.container.dialog1.render("container");
            YAHOO.util.Event.addListener("show", "click", YAHOO.new_folder.container.dialog1.show, null, YAHOO.new_folder.container.dialog1);
    }); 
