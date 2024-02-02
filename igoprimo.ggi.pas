{
  GeoGet 2
  Installation script for GIP packages
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
