{
  GeoGet 2 General Plugin Script
  www: http://geoget.ararat.cz/doku.php/user:skript:igoprimo
  autor: mikrom, http://mikrom.cz
  version: 0.0.2.1

  KML in iGO
  - https://dl.dropboxusercontent.com/u/4555713/GeoGet/igoprimo/Using%20POIs%20with%20IGO8%20Navigation%20Devices.pdf
  - https://dl.dropboxusercontent.com/u/4555713/GeoGet/igoprimo/NavNGo_iGO8_working_with_KML_v22Feb2008.pdf

  KML tutorial
  - https://developers.google.com/kml/documentation/kml_tut

  XML znaky
  - http://www.w3.org/TR/xml/#charsets
  - http://xml.silmaril.ie/specials.html
  - vpodstate hlavne & < > " ' ale nemely by vadit pokud to bude v CDATA

  VarSubst neumi %CRLF%, iGO v KML neumi \n. Jediny co zvladne pro odradkovani je cistokrevne CRLF
  ZMENA! Varsubs neumi %CRLF%, ale umi &CRLF&, takze ho lze pouzit na odradkovani
}

uses VarSubstUnit, RelToAbsPathUnit;

{$INCLUDE igoprimo.config.pas}
{$INCLUDE category.lib.pas}

var
  exportFolder,exportData,lastCategory: String;
  counter: integer;

{Name of plugin}
function PluginCaption: String;
begin
  Result := _('POI iGO Primo');
end;

{What will be displayed as hint in case of icon on the toolbar?}
function PluginHint: String;
begin
  Result := _('Export for iGO Primo navigation');
end;

{Icon data.}
function PluginIcon: String;
begin
  Result := DecodeBase64('iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAACVElEQVQ4jZWSu2tUQRTGfzNzHzOb16qLrkQQG1+IioUPhAQhooWNiDaCXcRXISgGxEKxsFSwsfMPEFFEYpVGLUQhoo1NQARDEE2UuNl75z5mLG52N5Y51Qyc+c13zvcJ7z0A8cSUl9oQqhBXDwhtAIDr0wBIrcjiGIBES9ypjQJAeO8RV555ZQxKhuQBeKMhUqgwQkYKFwaUQQyhRNRMBZQhxcmGqL4ByiQBAzIDB3g0ZZYABtnpIca3E0TN4FwOQABgkhQbRoi5BYrGGhQ5fv4PTtcogXKpAqg+Qzk0iG8nxDKqlHQUyJbl9NGt7GhEDNmUyasjPL+wn4GyoBlJXp/dwcMjmxhcyjhYD7Au6wFkatF2ie11w+aBiOk7x5hvWb7/+sulvQ2mL+7j8+wiY8N9vDzR5MPML8hdDyCynLyds2Wt5viuJlEgGb/9AoCbx7aRFY5r9yYZefyZPRsH0Uqg0nYP4JJqIQe3N/n2O6GVFkyMjzLoSwBqkeLq+VFentvNp7lF2j8W6I4OEC7Luf/qC0/ezHDo2lMObFuPMjHNy0/YeXeKM/uGeTfzk7FHHyubbUE3B2uPPvQA7UgBkBlNlKR4pRAbhshViGxZXH+MX1evAIC/dVgs22hJTEwtK7FxD6K0Ri1LLeoGZQwiy3H0qmujSSxSlMS2xKRpFZw0pUwcYZkjC1eFDZBZ3gUEAEHWYRaUQeeckmhNmaaARmKhP64ggUaxIomSKr4dkCksEP8HUVojW7bq7XcUD06JLmDlLLNvrwtWUXLl5ev7G6t6DPAPTzDuQLx8sfoAAAAASUVORK5CYII=');
end;

{How Geoget can handle this plugin?}
function PluginFlags: String;
begin
  if SOURCE = '' then Result := 'toolbar'
  else Result := 'toolbar,'+SOURCE; // toolbar, global, list
end;

{Method for choosing folder}
procedure ChooseFolder;
begin
  if EXPORT_FOLDER = '' then begin
    exportFolder := SelectDir('', _('Select destination folder'));
    if exportFolder = '' then begin
      ShowMessage(_('Cancel pressed'));
      GeoAbort;
    end;
  end
  else
    exportFolder := RelToAbsPath(AnsiToUtf(EXPORT_FOLDER),GEOGET_DATADIR);

  ForceDirectories(exportFolder); // If it not exist
  if (copy(exportFolder, length(exportFolder), 1) <> '\') then exportFolder := exportFolder + '\'; // If it not ends with backslash
end;

{This method return header of KML file}
function GetExportHeader: String;
begin
  Result := '<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://www.opengis.net/kml/2.2">' + CRLF +
            '<Document><name>Geocaching</name><metadata><igoicon><filename>Geocaching.bmp</filename></igoicon></metadata>' + CRLF;
end;

{This method make String structured like part of ASC document}
function FormatPoint(wLat, wLon, wName, wID, wDesc: String): String;
begin
  Result := '';
  {
  <Placemark>
    <name><![CDATA[UO5B Cestovateluv poklad - Explorer's treasure [Final]]]></name>
    <description><![CDATA[WP: FI44NPN, Type: Final Location, Name: Final, Desc: , Parent: Cestovateluv poklad - Explorer's treasure]]></description>
    <phoneNumber>+49</phoneNumber>
    <Point>
      <coordinates>15.90725,50.5571,0</coordinates> // lon,lat[,ele]
    </Point>
  </Placemark>
  }
  Result := '  <Placemark>' + CRLF +
            '    <name>' + CData(wName) + '</name>' + CRLF;
  if wDesc <> '' then Result := Result + '    <description>' + CData(wDesc) + '</description>' + CRLF;
  Result := Result + '    <phoneNumber>' + wID + '</phoneNumber>' + CRLF +
                     '    <Point><coordinates>' + wLon + ',' + wLat + '</coordinates></Point>' + CRLF +
                     '  </Placemark>';
end;

{This method returns True if passed point is geocache}
function IsGeocache(geo: TGeo): boolean;
begin
  Result := IsValidGC(geo.ID);
end;

{Metoda zpracuje predany bod TGeo a vrati naformatovany kod GPX}
function ProcessGeo(geo: TGeo): String;
var
  wLat, wLon, wName, wID, wDesc: String;
begin
  wLat := geo.Lat;
  wLon := geo.Lon;
  wID := geo.ID;
  VarSubstGeo(geo, GEOCACHE_NAME, VARSUBST_UTF, wName); // zavolame knihovnu VarSubst ktera vrati zformatovany vysledek
  VarSubstGeo(geo, GEOCACHE_DESCRIPTION, VARSUBST_UTF, wDesc); // zavolame knihovnu VarSubst ktera vrati zformatovany vysledek
  //wDesc := ReplaceString(wDesc, '#CRLF#', CRLF); // VarSubs nejak neumi %CRLF% - ALE UMI &CRLF&
  Result := FormatPoint(wLat, wLon, wName, wID, wDesc); // potom nechame logiku bod zpracovat
end;

{Metoda zpracuje predany bod TWpt a vrati naformatovany kod GPX}
function ProcessWpt(wpt: TWpt): String;
var
  geo: TGeo;
  wLat, wLon, wName, wID, wDesc: String;
begin
  geo := wpt.ParentGeo; // ziskame referenci na materskou kesku
  wLat := wpt.Lat;
  wLon := wpt.Lon;
  wID := wpt.ID;
  VarSubstWpt(wpt, WAYPOINT_NAME, VARSUBST_UTF, wName); // zavolame knihovnu VarSubst ktera vrati zformatovany vysledek
  VarSubstWpt(wpt, WAYPOINT_DESCRIPTION, VARSUBST_UTF, wDesc); // zavolame knihovnu VarSubst ktera vrati zformatovany vysledek
  //wDesc := ReplaceString(wDesc, '#CRLF#', CRLF); // VarSubs nejak neumi %CRLF% - ALE UMI &CRLF&
  Result := FormatPoint(wLat, wLon, wName, wID, wDesc); // potom nechame logiku bod zpracovat
end;

{Called when plugin is started}
procedure PluginStart;
begin
  Counter := 0;
  GeoBusyCaption(_('Setting destination folder'));
  GeoBusyKind('');
  ChooseFolder; // zavola funkci pro vyber exportFolder
  if (EMPTY_EXPORT_FOLDER = '1') then DelTree(exportFolder); // Smazeme exportFolder
  CatInit; // Prikazeme knihovne Category, aby si pripravila databazi
  CatbeginUpdate; // Prikazeme knihovne Category, aby se pripravila na prijimani kesi k zatrideni
  GeoBusyCaption(_('Sorting points into categories'));
end;

procedure OpenFile;
begin
  exportData := GetExportHeader;
end;

procedure CloseFile(category: String);
var
  exportFile: String;
begin
  if category <> null then begin
    if (EXPORT_ICONS = '1') then begin
      if not DirectoryExists(exportFolder + 'poi') then ForceDirectories(exportFolder + 'poi');
      exportFile := exportFolder + 'poi\' + category + '.kml';
    end
    else exportFile := exportFolder + category + '.kml';

    ForceDirectories(RegexExtract('^.*\\', exportFile));
    exportData := exportData + '</Folder>' + CRLF +
                               '</Document>' + CRLF +
                               '</kml>';
    exportData := ReplaceString(exportData, '<Folder><name>' + SeparateLeft(category, ' - ') + '</name><metadata><igoicon><filename>' + SeparateLeft(category, ' - ') + '.bmp</filename></igoicon></metadata>',
                                            '<Folder><name>' + category + '</name><metadata><igoicon><filename>' + category + '.bmp</filename></igoicon></metadata>'); // neskutecna prasarna!

    //if IsUtf(exportData) then showmessage('utf!');
    //StringToFile(UtfToAscii(exportData), exportFile);
    StringToFile(exportData, exportFile);
  end;
end;

{Proceduru vola knihovna Category. Po setrideni. Procedura si sama musi hlidat zmeny kategorii a ukoncovat a zapisovat soubory.}
procedure CatCallback(const geo: TGeo; const wpt: TWpt; category: String);
begin
  if not GeoBusyTest then begin
    Counter := Counter + 1;
    GeoBusyProgress(Counter, CatSize);

    if (category <> lastCategory) then begin
      CloseFile(lastCategory);
      OpenFile;
      if geo <> nil then exportData := exportData + '<Folder>' +
                                                    '<name>' + geo.CacheType + '</name>' +
                                                    '<metadata><igoicon><filename>' + geo.CacheType + '.bmp</filename></igoicon></metadata>' + CRLF;
      if wpt <> nil then exportData := exportData + '<Folder>' +
                                                    '<name>' + wpt.WptType + '</name>' +
                                                    '<metadata><igoicon><filename>' + wpt.WptType + '.bmp</filename></igoicon></metadata>' + CRLF;
      GeoBusyKind(category + ' (' + IntToStr(CatCategorySize(category)) + _(' points)'));
    end;
    lastCategory := category;

    if geo <> nil then exportData := exportData + ProcessGeo(geo) + CRLF;
    if wpt <> nil then exportData := exportData + ProcessWpt(wpt) + CRLF;
  end
  else GeoAbort;
end;

procedure PluginWork;
var
  cat: String;
  n: Integer;
begin
  if ((not GeoBusyTest) and GC.IsListed and (not GC.IsEmptyCoord)) then begin

    if (EXPORT_GEOCACHES = '1') and IsGeocache(GC) then begin // Export geocaches
      cat := GC.cachetype; // "Traditional Cache", "Multi-cache", "Unknown Cache", ...
      if GC.IsOwner then cat := cat + ' - Own' // Own chaches
      else if GC.IsFound then cat := cat + ' - Found'; // Found caches
      CatAddGC(GC, cat);
    end;

    if (EXPORT_WAYPOINTS = '1') then begin // Export waypoints
      for n := 0 to GC.Waypoints.Count - 1 do begin //for waypoints
        if GC.Waypoints[n].IsListed and (not GC.Waypoints[n].IsEmptyCoord) then begin // waypoints islisted and not empty coord

          cat := GC.Waypoints[n].WptType;

          if GC.IsOwner then cat := cat + ' - Own' // own
          else if GC.IsFound then begin // found
            if (EXPORT_ONLY_FINAL_WAYPOINTS_WHEN_FOUND = '1') and (GC.Waypoints[n].WptType = wp_final) then begin
              CatAddWpt(GC.Waypoints[n], cat + ' - Found');
              Exit;
            end
            else cat := cat + ' - Found';
          end
          else if not GC.IsFound and (GC.Waypoints[n].WptType = wp_final) then begin
            case GC.Waypoints[n].Comment of
              '{0}': cat := cat + ' - 0';
              '{1}': cat := cat + ' - 1';
              '{2}': cat := cat + ' - 2';
              '{3}': cat := cat + ' - 3';
              '{4}': cat := cat + ' - 4';
              '{5}': cat := cat + ' - 5';
              '{6}': cat := cat + ' - 6';
            end;
          end;

          CatAddWpt(GC.Waypoints[n], cat);

        end; // /waypoints islisted and not empty coord
      end; // /for waypoints
    end; // /exportwaypoints
  end
  else GeoAbort;
end;

{Called on the end}
procedure PluginStop;
begin
  Counter := 0;
  GeoBusyCaption(_('Generating output'));
  CatEndUpdate; // Tell the Category library, that we are finish, and we no export any other data

  {Tell the Category library to sort caches, and call CatCallback for every point}
  lastCategory := null;
  OpenFile;
  cat_callback := @CatCallback;
  CatSort;
  CloseFile(lastCategory);
  CatFinish; // Everything is done

  {copy icons}
  if (EXPORT_ICONS = '1') and (ICONS_FOLDER <> '') then
    CopyTree(ReplaceString(GEOGET_SCRIPTFULLNAME, GEOGET_SCRIPTNAME, '') + ICONS_FOLDER, exportFolder + 'usericon\');
end;
