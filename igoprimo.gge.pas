{
  GeoGet 2 Export Script
  www: http://geoget.ararat.cz/doku.php/user:skript:igoprimo
  autor: mikrom, http://mikrom.cz
  version: 0.0.0.2
}

{$INCLUDE igoprimo.ggp.pas}

function ExportExtension: string;
begin
  Result := '';
end;

function ExportDescription: string;
begin
  Result := PluginCaption();
end;

function ExportHint: string;
begin
  Result := _('Export specially designed for iGO Primo for Android.<br><font size="small"><br>Installation:<br>1. Copy BMP icons from GEOGET_SCRIPTDIR\igoprimo\icons\igo to /iGo/content/userdata/usericon<br>2. Copy exported KML files in /iGO/content/userdata/poi<br>3. Enable POI category Geocaching in map settings</font>');
end;

function ExportHeader: string;
begin
  Result := '';
  PluginStart;
end;

function ExportPoint: string;
begin
  Result := '';
  PluginWork;
end;

function ExportAfter(value: string): string;
begin
  Result := '';
  PluginStop;
end; 
