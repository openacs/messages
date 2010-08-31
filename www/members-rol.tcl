ad_page_contract {
    Inbox Page

    @author pedro@viaro.net
    @creation-date 2010-05-17
    @cvs-id $Id$
} {
    {rel_type ""}
    {data_search ""}
} 

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]


if { [exists_and_not_null data_search] && ![string equal $data_search "none"]} {
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
    }
    set where_clause_user "and ($where_clause_user)"
} else {
    set where_clause_user ""
    set search_clause ""
}

set elements [list  msg_ids \
                [list label { <input type="checkbox" id="checkbox_general" name="_dummy" onclick="select_all(this.form,this.checked);" title="[_ acs-templating.lt_Checkuncheck_all_rows]">} \
                display_template {<input type="checkbox" id="check_box_msg.@members.person_id@" name="subject_id" value="@members.person_id@" id="person_id.@members.person_id@" title="[_ acs-templating.lt_Checkuncheck_this_row]">} \
                sub_class {narrow} \
                html { align center }] \
            ]

lappend elements party_name \
            [list html { align left style "font-size: smaller; width:95%"} \
                label [_ messages.from] \
                display_template {<input type="hidden" value="@members.party_name@" id="party_name.@members.person_id@"> @members.party_name@} \
            ] 



template::list::create \
    -name members \
    -multirow members \
    -main_class "list-table" \
    -html { width=100% } \
    -orderby_name orderby \
    -no_data "[_ messages.no_members_found]" \
    -elements $elements 
    
set rowscount 0    
db_multirow -extend { } members get_members { *SQL* } { incr rowscount}
