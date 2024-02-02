{
  GeoGet 2 Installation script for GIP packages
  www: http://geoget.ararat.cz/doku.php/user:skript:igoprimo
  autor: mikrom, http://mikrom.cz
  version: 0.0.0.3
}

{Do install tasks here.}
function InstallWork: string;
begin
  {changelog}
  if FileExists(GEOGET_SCRIPTDIR + '\igoprimo\igoprimo.changelog.txt') then ShowLongMessage('Changelog', FileToString(GEOGET_SCRIPTDIR + '\igoprimo\igoprimo.changelog.txt'));

  Result := '';  // probehlo bez chyby
end;

{Do Uninstall tasks here.}
function UninstallWork: string;
begin
  Result := '';
end;
