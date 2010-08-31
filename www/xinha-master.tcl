  set ::xinha_dir /resources/acs-templating/xinha-nightly/
  set ::xinha_lang [lang::conn::language]

  # We could add site wide Xinha configurations (.js code) into xinha_params
  set xinha_params ""

  # Per call configuration
  set xinha_plugins $::acs_blank_master(xinha.plugins)
  set xinha_options $::acs_blank_master(xinha.options)
  # HTML ids of the textareas used for Xinha
  set htmlarea_ids '[join $::acs_blank_master__htmlareas "','"]'
