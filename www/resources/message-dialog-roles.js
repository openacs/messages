YAHOO.namespace("example.container");

YAHOO.util.Event.onDOMReady(function () {
	
	// Define various event handlers for Dialog
    var handleSubmit = function() {
        var formObject = document.getElementsByName('members_list');
        var form = formObject[0];
        var elements = form.elements;
        var member_ids = "";
        var count = 0;
        for ( var i = 0; i < elements.length ; i++) {
            if (elements[i].checked && elements[i].name != '_dummy')  {
                    count = count + 2;
                    member_ids = member_ids + elements[i].value + "," + elements[i+1].value + ",";
            }
        }
        var total_members = document.getElementById('total_rel_members').value;
        member_ids = member_ids.substring(0,member_ids.length-1);
        member_ids = member_ids.split(',');
        var recipients = "";
        var recipients_exists = document.getElementsByName('ids[]');
        var recipients_exists_ids = "";
        for ( var i = 0; i < document.getElementsByName('ids[]').length; i++) {
            recipients_exists_ids = recipients_exists_ids + document.getElementsByName('ids[]')[i].value + ",";
        }
        for ( var i = 0; i < count; i = i + 2 ) {
            var party_id = member_ids[i];
            var party_name = member_ids[i+1];
            if (recipients_exists_ids.match(party_id) == null) {
                recipients = recipients + "<span id=span_" + party_id + " class=\"token\"><span><span><span><span><input type=\"hidden\" value=" + party_id + " name=\"ids[]\"/>" + party_name + "<span class=\"x\" onclick=id_delete(" + party_id + ")>&nbsp;</span></span></span></span></span></span>";
            }
        }
        var recipients_old = document.getElementById('contact_reply').innerHTML;
        document.getElementById('contact_reply').innerHTML = recipients_old + recipients;
        this.cancel();
    };
	var handleCancel = function() {
		this.cancel();
	};
	var handleSuccess = function(o) {
		var response = o.responseText;
		response = response.split("<!")[0];
		document.getElementById("resp").innerHTML = response;
	};
	var handleFailure = function(o) {
		alert("Submission failed: " + o.status);
	};

    // Remove progressively enhanced content class, just before creating the module
    YAHOO.util.Dom.removeClass("dialog1", "yui-pe-content");

	// Instantiate the Dialog
	YAHOO.example.container.dialog1 = new YAHOO.widget.Dialog("dialog1", 
							{ width : "30em",
							  fixedcenter : true,
							  visible : false, 
							  constraintoviewport : true,
                                                          modal: true,
							  buttons : [ { text:document.getElementById('add').value, handler:handleSubmit, isDefault:true },
								      { text:"Cancel", handler:handleCancel } ]
							});

	// Validate the entries in the form to require that both first and last name are entered
	YAHOO.example.container.dialog1.validate = function() {
		var data = this.getData();
		if (data.firstname == "" || data.lastname == "") {
			alert("Please enter your first and last names.");
			return false;
		} else {
			return true;
		}
	};

	// Wire up the success and failure handlers
	YAHOO.example.container.dialog1.callback = { success: handleSuccess,
						     failure: handleFailure };
	
	// Render the Dialog
	YAHOO.example.container.dialog1.render();

}); 
