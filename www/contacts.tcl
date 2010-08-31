ad_page_contract {
    Update numbers of new messages in the menu

    @author pedro@viaro.net
    @creation-date 2009-11-17
    @cvs-id $Id$
} {
    msg_id
    {option ""}
}

set community_id [dotlrn_community::get_community_id]

if { [string equal $option "reply"]} {
    db_1row owner_info {}
}

if { [string equal $option "reply_all"]} {
    #gets all the recipients included in the message
    db_multirow contact recipient_ids { *SQL* } { }
}

if { [string equal $option "forward"]} {
    #when select forward, return only forward because in the javascript,
    #this option is write nothing in the recipients.
    set contacts_reply "forward"
}