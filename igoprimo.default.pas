const
  SOURCE = 'list'; //Exportovat: list - zobrazen�, "nic" - vybran�
  EXPORT_GEOCACHES = '1'; //Exportovat ke�e: 1 - ano, 0 - ne
  EXPORT_WAYPOINTS = '1'; //Exportovat waypointy: 1 - ano, 0 - ne
  EXPORT_ONLY_FINAL_WAYPOINTS_WHEN_FOUND = '1'; //Exportovat pouze fin�ln� waypointy u nalezen�ch: 1 - ano, 0 - exportuje v�echny waypointy u nalezen�ch
  EXPORT_FOLDER = ''; //Cesta k ulo�en� v�sledn�ch soubor� (C:\Documents and Settings\mikrom\Plocha\BeOnRoad\)
  EMPTY_EXPORT_FOLDER = '0'; //1 - Pred zapocetim exportu vymazat vsechny soubory z ciloveho adresare.
  ICONS_FOLDER = 'icons\igo'; //Cesta k ikon�m
  EXPORT_ICONS = '1'; //Exportovat i ikony? Exportuj� se v�echny a v�stup se za�ad� do slo�ek
  GEOCACHE_NAME = '%REPLACEFULL("%IDTAG% %IF("%ISOWNER%"="true";"O";"")%%IF("%ISFOUND%" = "true";"F";"")%%IF("%ISARCHIVED%" = "true";"A";"%IF("%ISDISABLED%" = "true";"D";"")%")% %NAME%";"  ";" ")%'; //N�zev bodu (VarSubst)
  GEOCACHE_DESCRIPTION = '%IF("%HINT%"<>"";"Hint:#CRLF#%HINT%";"")%%IF("%COMMENT%"<>"";"#CRLF##CRLF#Pozn�mka:#CRLF#%COMMENT%";"")%'; //Popis bodu (VarSubst)
  WAYPOINT_NAME = '%REPLACEFULL("%IDTAG%/%WPTPREFIXID% %IF("%ISOWNER%"="true";"O";"")%%IF("%ISFOUND%" = "true";"F";"")%%IF("%ISARCHIVED%" = "true";"A";"%IF("%ISDISABLED%" = "true";"D";"")%")% %NAME% (%WPTNAME%)";"  ";" ")%'; //N�zev waypointu (VarSubst)
  WAYPOINT_DESCRIPTION = '%IF("%HINT%"<>"";"Hint:#CRLF#%HINT%";"")%%IF("%WPTDESCRIPTION%"<>"";"#CRLF##CRLF#Pozn�mka:#CRLF#%WPTDESCRIPTION%";"")%%IF("%WPTCOMMENT%"<>"";"#CRLF##CRLF#Pozn�mka:#CRLF#%WPTCOMMENT%";"")%'; //Popis waypointu (VarSubst)
