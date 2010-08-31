<if @permition_read_p@ eq "f">false</if>
<else>
    <input type="hidden" id="folder_id" value="@folder_id@">
    <input type="hidden" id="msg_id" value="@msg_id@">
    <input type="hidden" id="older_msg_id" value="@older_msg_id@">
    <input type="hidden" id="oldest_msg_id" value="@oldest_msg_id@">
    <input type="hidden" id="newer_msg_id" value="@newer_msg_id@">
    <input type="hidden" id="newest_msg_id" value="@newest_msg_id@">
    <input type="hidden" id="new_page_number" value="@new_page_number@">
    <br>
    <div style="margin-left:10px">
        <input type="hidden" id="subject_field" value="@subject@">
        <table width="100%">
            <tr>
                <th align="left">
                    <strong style="font-size:15px">
                        @subject@ 
                        <input type="hidden" id="subject_fw" value="@subject@">
                        <br>
                    </strong>
                </th>
                <th>
                    <span style="float: right;text-align:right;">
                        <a href="print-message?msg_id=@msg_id@" target="_blank">
                            &nbsp;&nbsp;<img src="/resources/messages/icono_imprimir.png" width="20" height="20">#messages.print#&nbsp;&nbsp;&nbsp;&nbsp;
                        </a>
                    </span>
                </th>
            </tr>
        </table>
        <span style="margin-right:10px;">
            <include src="read" folder_id="@folder_id@" page_number="@page_number@">
        </span>
    </div>
    <br>
</else>