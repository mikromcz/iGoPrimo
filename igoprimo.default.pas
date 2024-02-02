const
  SOURCE = 'list'; //Exportovat: list - zobrazené, "nic" - vybrané
  EXPORT_GEOCACHES = '1'; //Exportovat keše: 1 - ano, 0 - ne
  EXPORT_WAYPOINTS = '1'; //Exportovat waypointy: 1 - ano, 0 - ne
  EXPORT_ONLY_FINAL_WAYPOINTS_WHEN_FOUND = '1'; //Exportovat pouze finální waypointy u nalezených: 1 - ano, 0 - exportuje všechny waypointy u nalezených
  EXPORT_FOLDER = ''; //Cesta k uložení výsledných souborù (C:\Documents and Settings\mikrom\Plocha\BeOnRoad\)
  ICONS_FOLDER = 'icons\igo'; //Cesta k ikonám
  PREFIX = ''; //Prefix pøed názvem keše ("GC-" -> "GC-Traditional Cache")
  SEPARATE_DISABLED = '0'; //Oddìlit disablované keše šedou ikonkou
  GEOCACHE_NAME = '%REPLACEFULL("%IDTAG% %IF("%ISOWNER%"="true";"O";"")%%IF("%ISFOUND%" = "true";"F";"")%%IF("%ISARCHIVED%" = "true";"A";"%IF("%ISDISABLED%" = "true";"D";"")%")% %NAME%";"  ";" ")%'; // Definuje se pøes promìnnou VarSubst
  WAYPOINT_NAME = '%REPLACEFULL("%IDTAG%/%WPTPREFIXID% %IF("%ISOWNER%"="true";"O";"")%%IF("%ISFOUND%" = "true";"F";"")%%IF("%ISARCHIVED%" = "true";"A";"%IF("%ISDISABLED%" = "true";"D";"")%")% %NAME% (%WPTNAME%)";"  ";" ")%'; // Definuje se pøes promìnnou VarSubst
