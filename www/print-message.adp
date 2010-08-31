<script type="text/javascript">
    window.print();
</script>

<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<span style="float:left;text-align:left;"> </span>
    <span style="float:right;font-size:small;"><a class=button href="javascript:window.close()">#messages.close_window#</a></span><br>
    <span style="float: right;text-align:right;">@owner_name@</span>
<br><br><br>
<hr>
    <span style="float:left;text-align:left;font-size: large;">@subject@</span>
<br><br>
    <span style="float:left;text-align:left;font-size: x-small;">#messages.messages#:@print:rowcount@</span>
<br>
<hr>
<multiple name="print">
    <span style="float:left;text-align:left;font-size: small;">
        <strong> @print.contact_names@ </strong> 
    </span>
    <span style="float:right;text-align:left;font-size: small;"> 
        @print.ansi_time@
    </span>
    <br><br> 
        @print.content;noquote@
    <br><hr>
</multiple>



