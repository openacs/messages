ad_page_contract {
    Inbox Page

    @author pedro@viaro.net
    @creation-date 2009-11-11
    @cvs-id $Id$
} {
    {page_number ""}
    {data_search ""}
} 

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]

if {[empty_string_p $page_number]} {
    set page_number 1
}

if { [exists_and_not_null data_search] } {
    set data_search_list [string trim [split $data_search " "]]
    set count 0
    foreach data_search $data_search_list {
        set sql_keyword "%[string tolower $data_search]%"
        if { $count == 0 } {
            append where_clause_user "lower(first_names || ' ' || last_name) like '$sql_keyword'"
        } else {
            append where_clause_user " or lower(first_names || ' ' || last_name) like '$sql_keyword'"        
        }
        incr count
        append search_clause "or lower(msg_content) like '%'||lower('$data_search')||'%'"
        append search_clause " or lower(subject) like '%'||lower('$data_search')||'%'"
    }
    set where_clause_user "where $where_clause_user"
} else {
    set where_clause_user ""
    set search_clause ""
}

#####################################################################
#get the total messages and calculate how many pages have in folder show
#First and last row are calculate based on the total messages show per page
set total_messages [db_string get_total_messages {}]
set show_messages [db_string get_max_show_msg {} -default 25]
#Round to the next integer because the las page include some messages.
set total_pages [expr ceil([expr [expr $total_messages + 0.0] / [expr $show_messages + 0.0]])]
set oldest_page [expr $total_pages - 1]
set count_messages 0
if { $page_number != 1} {
    set first_row [expr [expr [expr $page_number - 1] * $show_messages] + 1]
    set last_row [expr [expr $first_row + $show_messages] - 1]
} else {
    set first_row [expr [expr $page_number - 1] * $show_messages]
    set last_row [expr $first_row + $show_messages]
    set first_row [expr $first_row + 1]
}
######################################################################

set elements [list  msg_ids \
                [list label { <input type="checkbox" id="checkbox_general" name="_dummy" onclick="select_all(this.form,this.checked);" title="[_ acs-templating.lt_Checkuncheck_all_rows]">} \
                display_template {<input type="checkbox" id="check_box_msg.@messages.msg_id@" name="subject_id" value="@messages.msg_id@" id="msg_ids.@messages.msg_id@" title="[_ acs-templating.lt_Checkuncheck_this_row]" onclick="more_actions_select();">} \
                sub_class {narrow} \
                html { align center }] \
            ]

lappend elements contacts \
            [list html { align left style "font-size: smaller; width:20%"} \
                label [_ messages.from] \
                display_template { <a href="#" onclick="read_message(@messages.msg_id@,@messages.folder_id@,$page_number)"> <if @messages.new_p;literal@ true>\
                                     <span id="new_p.@messages.msg_id@"><span id="new_p_style.@messages.msg_id@"  style="font-weight: bold;">@messages.contacts@ \
                                        <if @messages.folder_id@ ne 1> (@messages.number_conversation@) </if></span>\
                                    </if><else><span id="new_p_style.@messages.msg_id@" style="font-weight:;">@messages.contacts@ (@messages.number_conversation@)</span></else></a>} \
            ] \
    folder_id \
        [list html { align center style "font-size: smaller; width:5%"} \
            label "" \
                display_template { <input type="button" value="@messages.folder_name@" href="#" onclick="read_message(@messages.msg_id@,@messages.folder_id@,$page_number)"> }] \
    attachment_mail \
        [list html { align center style "font-size: smaller; width:5%"} \
            label "" \
                display_template { <a href="#" onclick="read_message(@messages.msg_id@,@messages.folder_id@,$page_number)">\
                                    <if @messages.attachment_p@ gt 0><span style="font-weight: bold;"><img src="/resources/messages/attachment.png" width="20" height="20"></span> \
                                   </if></a>} \
        ] \
    subject_mail \
        [list html { align left style "font-size: smaller; width:65%"} \
            label [_ messages.subject] \
                display_template { <a href="#" onclick="read_message(@messages.msg_id@,@messages.folder_id@,$page_number)">\
                                    <if @messages.new_p;literal@ true><span id="new_p_sub.@messages.msg_id@" style="font-weight: bold;">@messages.subject_mail@</span> \
                                   </if><else><span id="new_p_sub.@messages.msg_id@" style="font-weight:;">@messages.subject_mail@</span></else></a>} \
        ] \
    date \
        [list html { align left style "font-size: smaller;width:10%"} \
            label [_ messages.date] \
                display_template { <a href="#" onclick="read_message(@messages.msg_id@,@messages.folder_id@,$page_number)">\
                                    <if @messages.new_p;literal@ true><span id="new_p_date.@messages.msg_id@" style="font-weight: bold;">@messages.date@</span> \
                                    </if><else><span id="new_p_date.@messages.msg_id@" style="font-weight:;">@messages.date@</span></else></a>} \
        ]


template::list::create \
    -name messages \
    -multirow messages \
    -main_class "list-table" \
    -html { width=100% } \
    -orderby_name orderby \
    -no_data "[_ messages.no_messages_found]" \
    -elements $elements 

set msg_id_list [list]
set last_msg_ids_list [list]
db_foreach get_msg_ids {} {
    set last_msg_ids_array($msg_id) $last_msg_id
    lappend last_msg_ids_list $last_msg_id
    lappend msg_id_list $msg_id
}

set msg_ids [join $msg_id_list ","]
set last_msg_ids [join $last_msg_ids_list ","]

if { ![exists_and_not_null $msg_ids] } {
    set folder_id 0
}

if { [empty_string_p $msg_ids] } {
    set msg_ids 0
}

if { [empty_string_p $last_msg_ids] } {
    set last_msg_ids 0
}

db_foreach get_attachment_p { } {
   set get_attachment_array($parent_id) $count_attachment
}

db_foreach get_new_p {} {
   set new_p_array($parent_id) $new_p
}

db_foreach get_msg_info {} {
    set msg_content_array($parent_id) $msg_content
    set date_sent_array($parent_id) $sent_date_ansi
}

db_multirow -extend { subject_mail date attachment_p new_p folder_name} messages get_messages { *SQL* } {
    set folder_name [db_string get_folder_name {}]
    if { [info exists get_attachment_array($msg_id)]} {
        set attachment_p $get_attachment_array($msg_id)
    } else {
        set attachment_p 0
    }
    set msg_content $msg_content_array($msg_id)
    set sent_date_ansi $date_sent_array($msg_id)
    set content [ad_html_to_text [template::util::richtext::get_property contents $msg_content]]
    append subject_mail $subject "-" [string_truncate -len 80 -ellipsis "..." " $content"]
    set cur_time [clock format [clock seconds] -format "%Y %m %d"]
    set sent_time_seconds [clock format [clock scan $sent_date_ansi] -format "%Y %m %d"]
    #compare the sent date with the current date and display the message according to the date.
    if { [lindex $cur_time 0] > [lindex $sent_time_seconds 0]} {
        set date [lc_time_fmt $sent_date_ansi "%D"]
    } else {
        if {[lindex $cur_time 1] >= [lindex $sent_time_seconds 1] && [lindex $cur_time 2] == [lindex $sent_time_seconds 2]} {
            set date [_ messages.today]
        } else {
            set date [lc_time_fmt $sent_date_ansi "%d,%b,%Y %H:%M"]
        }
    }
    if { [info exists new_p_array($msg_id)]} {
        set new_p $new_p_array($msg_id)
    } else {
        set new_p 0
    }
    incr count_messages
}

set last_number [expr [expr $count_messages + $first_row] - 1]
