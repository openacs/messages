# /packages/messages/tcl/apm-callback-procs.tcl

ad_library {

    Messages Package APM callbacks library

    Procedures that deal with installing, instantiating, mounting.

    @author pedro@viaro.net
    @creation-date 2009-11-26

}

namespace eval messages {}
namespace eval messages::apm {}

ad_proc -public messages::apm::package_install {

} {
    Does the integration with the notifications package.
} {
    db_transaction {
        #Create the conten types
        content::type::new -content_type {messages_attachments} -supertype {content_revision} -pretty_name {Message Attachment} -pretty_plural {Message Attachments} -table_name {messages_attachments} -id_column {attachment_id}

        #Create content type attributes for content type messages
        content::type::attribute::new -content_type {messages_attachments} -attribute_name {attachment_item_id} -datatype {number} -pretty_name {Attachment Item ID} -column_spec {integer}
        content::type::attribute::new -content_type {messages_attachments} -attribute_name {msg_id} -datatype {number} -pretty_name {Message ID} -column_spec {integer}
     }
}

ad_proc -public messages::apm::package_instantiate {
    -package_id:required
} {

    Define Message folders

} {
    # create a content folder
    set folder_id [content::folder::new -name "messages_attachments_$package_id" -label "messages_attachments_$package_id" -package_id $package_id ]
    # register the allowed content types for a folder
    content::folder::register_content_type -folder_id $folder_id -content_type messages_attachments -include_subtypes t
}
