var number = 0;

tag= function (tag) {
    return document.createElement(tag);
}

tag_id = function (id) {
    return document.getElementById(id);
}

even = function (evt) {
    return (!evt) ? event : evt;
}

evt_src = function (evt) {
    return evt.srcElement ?  evt.srcElement : evt.target;
}

addField = function () {
	var container = document.getElementById('files');
    span = tag('SPAN');
	span.className = 'file';
	span.id = 'upload_file_' + (++number);

	field = tag('input');   
	field.name = 'upload_file_'+ number ;
	field.id = 'upload_file_' + number ;
	field.type = 'file';
   
	attachment = tag('A');
	attachment.name = span.id;
	attachment.onclick = function(){ removeField(this.name) };
	attachment.innerHTML = "&nbsp;&nbsp;" + document.getElementById('attachment_delete').value;

	img = tag('IMG');
	img.src ="/resources/messages/Delete16-on.gif";

    new_line = tag('br');

	span.appendChild(field);
	attachment.appendChild(img);
	span.appendChild(attachment);
    span.appendChild(new_line);    
	container.appendChild(span);
}

removeField = function (evt) {
    lnk = evt_src(even(evt));
    span = document.getElementById(evt);
    span.parentNode.removeChild(span);
}