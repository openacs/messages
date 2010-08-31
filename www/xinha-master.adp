<slave>
<p id="advancedMessagesEditor" style="display: none;">
xinha_editors = null;
xinha_init = null;
xinha_config = null;
xinha_plugins = [@xinha_plugins@];
Xinha.loadPlugins(xinha_plugins,null);
xinha_editors = xinha_editors ? xinha_editors :[ @htmlarea_ids@ ];
xinha_config = xinha_config ? xinha_config() : new Xinha.Config();
@xinha_params@
@xinha_options@
xinha_editors =
Xinha.makeEditors(xinha_editors, xinha_config, xinha_plugins);
Xinha.startEditors(xinha_editors);
</p>
<p id="advancedMessagesIds" style="display: none;">
@htmlarea_ids@
</p>