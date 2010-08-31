<if @data_search@ eq "">
    <input type="text" id="search_name" >
    <input type="button" id="search_button" value="#messages.search#" onclick="search_members_rel_type();">
    <input type="hidden" id="rel_type" value="@rel_type@">
</if>
<div id="members_list_div">
    <form name="members_list" method="GET">
        <div id="list_members" style="weight:100%">
            <listtemplate name="members"></listtemplate>
        </div>
        <input type="hidden" id="total_rel_members" value="@rowscount@">
    </form>
</div>
