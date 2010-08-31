ad_page_contract {
    Message Options

    @author pedro@viaro.net
    @creation-date 2009-11-13
    @cvs-id $Id$
} {
    {return_url "messages"}
} 

set page_title "[_ messages.configuration]"
set context [list "[_ messages.configuration]"]
set owner_id [ad_conn user_id]
set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set save_sent_p 1
set signature_p 0
set signature ""
set max_messages "25"

append folders_id_standar [messages::get_folder_id -folder_name "inbox"] ","\
                          [messages::get_folder_id -folder_name "sent"] ","\
                          [messages::get_folder_id -folder_name "save"] ","\
                          [messages::get_folder_id -folder_name "trash"]

db_multirow -extend { folder_p } folder get_folders_data { *SQL* } { }

if { ![db_0or1row select_options {} ] } {
    db_dml create_options {}
}

set signature [ad_html_to_text $signature]

if { [empty_string_p $signature] } {
    set signature ""
} else {
    set signature [string trim $signature]
}

ad_form -name options_mail -cancel_url "messages" -form {
    {max_messages:naturalnum {label "[_ messages.max_show_messages]:"} 
        {html {size 3}} {value $max_messages}
    }
    {save_sent_p:text(radio) {label "[_ messages.save_sent_message]:"} 
        {options {{[_ messages.yes] 1} {[_ messages.no] 0}}} {value $save_sent_p}
    }
    {signature_p:text(radio) {label "[_ messages.insert_signature]:"} 
        {options {{[_ messages.yes] 1} {No 0}}} {value $signature_p}
    }
    {signature_text:richtext(richtext),optional,nospell {label "[_ messages.signature]:"}
        {options {editor xinha }}
        {value "$signature"} {html {id "signature" cols 80 rows 3 onload "loadEditors('advancedMessagesEditor'); return false;"}} 
    }
} -on_submit {
    set signature [string trim [ad_convert_to_html $signature_text]]
    db_dml update_options {}
} -after_submit {
    ad_returnredirect "$return_url"
    ad_script_abort
}

template::head::add_javascript -src "/resources/ajaxhelper/yui/yahoo/yahoo-min.js" -order "-3"
template::head::add_javascript -src "/resources/ajaxhelper/yui/yahoo-dom-event/yahoo-dom-event.js" -order "-1"
template::head::add_javascript -src "/resources/ajaxhelper/yui/element/element-beta-min.js" -order "-2"
template::head::add_javascript -src "/resources/ajaxhelper/yui/event/event-min.js" -order "-4"
template::head::add_javascript -src "/resources/ajaxhelper/yui/dom/dom-min.js" -order "-5"
template::head::add_javascript -src "/resources/ajaxhelper/yui/button/button-beta-min.js" -order "-7"
template::head::add_javascript -src "/resources/ajaxhelper/yui/utilities/utilities.js" -order "-8"
template::head::add_javascript -src "/resources/ajaxhelper/yui/connection/connection-min.js" -order "-9"
template::head::add_javascript -src "/resources/ajaxhelper/yui/button/button-min.js"
template::head::add_javascript -src "/resources/ajaxhelper/yui/dragdrop/dragdrop-min.js"
template::head::add_javascript -src "/resources/ajaxhelper/yui/container/container-min.js"
template::head::add_javascript -src "/resources/ajaxhelper/yui/yuiloader/yuiloader-min.js"
template::head::add_javascript -src "/resources/messages/folder-new.js"
template::head::add_css -href "/resources/ajaxhelper/yui/button/assets/skins/sam/button.css" -order "-3"
template::head::add_css -href "/resources/ajaxhelper/yui/container/assets/skins/sam/container.css" -order "-4"
template::head::add_css -href "/resources/ajaxhelper/yui/fonts/fonts-min.css"
template::head::add_css -href "/resources/ajaxhelper/yui/button/assets/skins/sam/button.css"
template::head::add_css -href "/resources/ajaxhelper/yui/assets/skins/sam/container.css"
template::head::add_javascript -src "/resources/messages/messages.js" -order "3"
template::head::add_javascript -src "/resources/messages/message-option.js" -order "4"


set ::acs_blank_master(xinha) 1
set ::acs_blank_master(xinha.plugins) "'OacsFs'"
set ::acs_blank_master(xinha.options) ""
set ::acs_blank_master__htmlareas ""