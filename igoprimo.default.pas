const
  SOURCE = 'list'; //Exportovat: list - zobrazené, "nic" - vybrané
  EXPORT_GEOCACHES = '1'; //Exportovat keše: 1 - ano, 0 - ne
  EXPORT_WAYPOINTS = '1'; //Exportovat waypointy: 1 - ano, 0 - ne
  EXPORT_ONLY_FINAL_WAYPOINTS_WHEN_FOUND = '1'; //Exportovat pouze finální waypointy u nalezených: 1 - ano, 0 - exportuje všechny waypointy u nalezených
  EXPORT_FOLDER = ''; //Cesta k uložení výsledných souborù (C:\Documents and Settings\mikrom\Plocha\BeOnRoad\)
  EMPTY_EXPORT_FOLDER = '0'; //1 - Pred zapocetim exportu vymazat vsechny soubory z ciloveho adresare.
  //ICONS_FOLDER = 'icons\igo'; //Cesta k ikonám
  PREFIX = ''; //Prefix pøed názvem keše ("GC-" -> "GC-Traditional Cache")
  SEPARATE_DISABLED = '0'; //Oddìlit disablované keše šedou ikonkou
  GEOCACHE_NAME = '%REPLACEFULL("%IDTAG% %IF("%ISOWNER%"="true";"O";"")%%IF("%ISFOUND%" = "true";"F";"")%%IF("%ISARCHIVED%" = "true";"A";"%IF("%ISDISABLED%" = "true";"D";"")%")% %NAME%";"  ";" ")%'; // Definuje se pøes promìnnou VarSubst
  GEOCACHE_DESCRIPTION = '%IF("%HINT%"<>"";"Hint:#CRLF#%HINT%";"")%%IF("%COMMENT%"<>"";"#CRLF##CRLF#Poznámka:#CRLF#%COMMENT%";"")%'; // Definuje se pøes promìnnou VarSubst
  WAYPOINT_NAME = '%REPLACEFULL("%IDTAG%/%WPTPREFIXID% %IF("%ISOWNER%"="true";"O";"")%%IF("%ISFOUND%" = "true";"F";"")%%IF("%ISARCHIVED%" = "true";"A";"%IF("%ISDISABLED%" = "true";"D";"")%")% %NAME% (%WPTNAME%)";"  ";" ")%'; // Definuje se pøes promìnnou VarSubst
  WAYPOINT_DESCRIPTION = '%IF("%HINT%"<>"";"Hint:#CRLF#%HINT%";"")%%IF("%WPTDESCRIPTION%"<>"";"#CRLF##CRLF#Poznámka:#CRLF#%WPTDESCRIPTION%";"")%%IF("%WPTCOMMENT%"<>"";"#CRLF##CRLF#Poznámka:#CRLF#%WPTCOMMENT%";"")%'; // Definuje se pøes promìnnou VarSubst
