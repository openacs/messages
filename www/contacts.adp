<if @option@ eq "reply">
    <span id=span_@contact_id@ class="token">
        <span><span><span><span>
            <input type="hidden" value=@contact_id@ name="ids[]">@contact_name@
            <span class="x" onclick=id_delete(@contact_id@)>&nbsp;</span>
        </span></span></span></span>
    </span>
</if>
<if @option@ eq "reply_all">
    <multiple name="contact">
        <span id=span_@contact.party_id@ class="token">
            <span><span><span><span>
                <input type="hidden" value=@contact.party_id@ name="ids[]"/>@contact.party_name@
                <span class="x" onclick=id_delete(@contact.party_id@)>&nbsp;</span>
            </span></span></span></span>
        </span>
    </multiple>
</if>
<if @option@ eq "forward">forward</if>