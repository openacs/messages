drop sequence messages_msg_sequence;
drop index messages_community_id_index;
drop index messages_parent_id_index;
drop table  messages_recipients;
drop table messages_recipients_roles;
drop table messages_attachments;
drop table messages_user_messages;
drop index user_messages_user_id_index;
drop sequence messages_folders_sequence;
drop table messages_folders;
drop table messages_options;
drop table messages_messages cascade;