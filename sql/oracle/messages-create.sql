--
-- Assessment Package
--
-- @author pedro@viaro.net
-- @creation-date 2009-10-30
--


create sequence messages_msg_sequence start with 1;
--messages
create table messages_messages  (
        msg_id               integer not null
                             constraint messages_messages_msg_id_pk
                             primary key,
        owner_id             integer not null,
        community_id         integer not null,
        sent_date            date default sysdate not null,
        parent_id            integer,
        mime_type           varchar2(200) default 'text/plain',
        subject             varchar2(200),
        msg_content         clob
);

create index messages_community_id_index on messages_messages(community_id);
create index messages_parent_id_index on messages_messages(parent_id);

--recipients mail

create table  messages_recipients (
    msg_id          integer not null
                    constraint recipients_party_id_fk
                    references messages_messages(msg_id)
                    on delete cascade,
    party_id        integer not null
                    constraint recipients_msg_id_fk
                    references parties(party_id)
                    on delete cascade,
    constraint messages_recipients_pk primary key (msg_id, party_id)
);

create table  messages_recipients_roles (
    msg_id          integer not null
                    constraint recipients_roles_msg_id_fk
                    references messages_messages(msg_id)
                    on delete cascade,
    rel_id          varchar(100) not null
                    constraint recipients_rel_id_fk
                    references acs_rel_types (rel_type)
                    on delete cascade,
    constraint messages_recipients_rel_pk primary key (msg_id, rel_id)
);

--Attachments
create table messages_attachments (
    msg_id          integer not null
                    constraint messages_attachment_msg_id_fk
                    references messages_messages
                    on delete cascade,
    attachment_id   integer not null,
    attachment_item_id integer not null,
    constraint msg_attachment_pk primary key (msg_id,attachment_id)
);

--user messages to specific folder
create table messages_user_messages (
    msg_id          integer not null
                    constraint user_messages_msg_id_fk
                    references messages_messages
                    on delete cascade,
    user_id         integer not null
                    constraint user_messages_user_id_fk
                    references users
                    on delete cascade,
    parent_id       integer
                    constraint user_msg_parent_id_fk
                    references messages_messages(msg_id)
                    on delete cascade,
    folder_id       integer default 0,
    new_p           char default 't'
                    check (new_p in ('t','f')),
    constraint messages_user_messages_pk primary key (msg_id,user_id,folder_id)
);

create index user_messages_user_id_index on messages_user_messages(user_id);

--user folders
create sequence messages_folders_sequence start with 5;
create table messages_folders (
    user_id         integer
                    constraint messages_folders_user_id_fk
                    references users
                    on delete cascade,
    folder_id       integer not null,
    folder_name     varchar(50) not null
);

insert into messages_folders values(0,0,'#messages.inbox#');
insert into messages_folders values(0,1,'#messages.sent#');
insert into messages_folders values(0,2,'#messages.save#');
insert into messages_folders values(0,3,'#messages.trash#');


--message configuration
create table messages_options (
        user_id             integer 
                            constraint messages_options_pk
                            primary key
                            constraint messages_options_user_fk
                            references users,
        max_messages        integer default 50,
        save_sent_p         integer default 1,
        signature_p         integer default 0,
        signature           varchar2(1000) default ''
);
