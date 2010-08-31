ad_page_contract {
    General page, list inbox, sent, draft, trash.

    @author pedro@viaro.net
    @creation-date 2009-11-12
    @cvs-id $Id$
} {
    {community_id ""}
    {page_number ""}
}

set page_title "[_ messages.folders]"
set context [list $page_title]
set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]

set ::acs_blank_master(xinha) 1
set ::acs_blank_master(xinha.plugins) "'OacsFs'"
set ::acs_blank_master(xinha.options) ""
set ::acs_blank_master__htmlareas ""

template::head::add_javascript -src "/resources/ajaxhelper/yui/yahoo-dom-event/yahoo-dom-event.js" -order "-1"
template::head::add_javascript -src "/resources/ajaxhelper/yui/yahoo/yahoo-min.js" -order "-14"
template::head::add_javascript -src "/resources/ajaxhelper/yui/element/element-beta-min.js" -order "-13"
template::head::add_javascript -src "/resources/ajaxhelper/yui/event/event-min.js" -order "-15"
template::head::add_javascript -src "/resources/ajaxhelper/yui/dom/dom-min.js" -order "-16"
template::head::add_javascript -src "/resources/ajaxhelper/yui/button/button-beta-min.js" -order "-17"
template::head::add_javascript -src "/resources/ajaxhelper/yui/utilities/utilities.js" -order "-18"
template::head::add_javascript -src "/resources/ajaxhelper/yui/history/history-beta-min.js" -order "-19"
template::head::add_javascript -src "/resources/ajaxhelper/yui/button/button-min.js" -order "-2"
template::head::add_javascript -src "/resources/ajaxhelper/yui/dragdrop/dragdrop-min.js" -order "2"
template::head::add_javascript -src "/resources/ajaxhelper/yui/container/container-min.js" -order "3"
template::head::add_javascript -src "/resources/messages/prototype.js" -order "4"
template::head::add_javascript -src "/resources/messages/effects.js" -order "5"
template::head::add_javascript -src "/resources/ajaxhelper/yui/dragdrop/dragdrop.js" -order "6"
template::head::add_javascript -src "/resources/messages/controls.js" -order "7"
template::head::add_javascript -src "/resources/messages/builder.js" -order "8"
template::head::add_javascript -src "/resources/messages/application.js" -order "9"
template::head::add_javascript -src "/resources/messages/messages.js" -order "10"
template::head::add_javascript -src "/resources/messages/dispatcher.js"
template::head::add_javascript -src "/resources/messages/dispatcher-min.js"
template::head::add_javascript -src "/resources/messages/menu.js" -order "11"
template::head::add_javascript -src "/resources/messages/delete-dialog.js" -order "12"
template::head::add_javascript -src "/resources/messages/message-attachment.js" -order "13"
template::head::add_css -href "/resources/messages/menu.css" -order "-2"
template::head::add_css -href "/resources/ajaxhelper/yui/fonts/fonts-min.css" -order "-3"
template::head::add_css -href "/resources/ajaxhelper/yui/button/assets/skins/sam/button.css" -order "-4"
template::head::add_css -href "/resources/ajaxhelper/yui/container/assets/skins/sam/container.css" -order "-5"
template::head::add_css -href "/resources/messages/messages.css" -order "-6"
template::head::add_css -href "/resources/messages/send.css" -order "1"
template::head::add_javascript -src "/resources/ajaxhelper/yui/connection/connection-min.js"




