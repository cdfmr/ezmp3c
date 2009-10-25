//------------------------------------------------------------------------------
// Project: EZ MP3 Creator
// Unit:    Languages.pas
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: Multi-Language Support
//
// 2006-05-07
// - Initial release with comments 
//------------------------------------------------------------------------------

unit Languages;

interface

uses SysUtils, IniFiles;

const
  URL_HOMEPAGE = 'http://www.linasoft.com';
  URL_SUPPORT = 'http://www.linasoft.com/support.php';
  URL_ORDER = 'http://www.linasoft.com/order.php';
  URL_LANG = 'http://www.linasoft.com/ezmp3c.php#translation';
  URL_HELPFILE = 'ezmp3c.chm';
  STR_FULLVERSION = 'Full Version';

var

  // Language Variables
  LangName: string;
  LangFile: string;

  // WWW
  HomePage: string = URL_HOMEPAGE;
  SupportURL: string = URL_SUPPORT;
  OrderURL: string = URL_ORDER;
  LangURL: string = URL_LANG;
  CHMFile: string = URL_HELPFILE;

  // Buttons
  ButtonNextCaption: string = '&Next >';
  ButtonGOCaption: string = '&GO!';
  ButtonExitCaption: string = 'E&xit';
  ButtonPauseCaption: string = '&Pause';
  ButtonResumeCaption: string = '&Resume';
  ButtonAbortCaption: string = '&Abort';
  ButtonCloseCaption: string = 'Close';

  // Drive List
  NoDriver: string = '(None)';

  // Track List Page
  NoTrackSelected: string = 'You must select one track at least!';
  NoCDFound: string = 'Can''t detect CD in the selected CDROM unit!';

  // Query CDDB
  CDDBMsgConnect: string = 'Retrieving CD information from %s ...';
  CDDBMsgSuccess: string = 'CD information retrieved successfully!';
  CDDBMsgFailed: string = 'Failed retrieving CD information!';

  // Output Folder & File
  OutputFolderError: string = 'Output folder is invalid!';
  FileNameRuleError: string = 'Output filename is invalid!';
  CreateFolderError: string = 'Can''t create output directory!';

  // Audio Information
  UnknownArtist: string = 'Unknown Artist';
  UnkonwnAlbum: string = 'Unknown Album';

  // Processing
  ProgressLabel: string = 'Processing Track %d of %d:';

  // Quit Prompt
  QuitProcess: string = 'Do you want to terminate the operation?';

  // Log
  LogStart: string = 'Starting...';
  LogRip: string = 'Ripping %s...';
  LogEncode: string = 'Encoding %s...';
  LogSuccess: string = 'Success!';
  LogFailed: string = 'Failed!';
  LogCanceled: string = 'User cancelled.';
  LogFinish: string = 'Finish.';

  // Registration
  RegInfoNotComplete: string = 'Please enter your registration information!';
  RegFailed: string = 'Invalid serial number!';
  RegSuccess: string = 'Thank you for your registration!';

  // Play List
  PlaylistFilter: string = 'Playlists (*.m3u)|*.m3u';
  PlaylistFailed: string = 'Failed creating playlist!';

  // About
  FullVersion: string = STR_FULLVERSION;

// Update strings
procedure UpdateLanguage;

implementation

//------------------------------------------------------------------------------
// Procedure: UpdateLanguage
// Arguments: None
// Result:    None
// Comment:   Update strings
//------------------------------------------------------------------------------

procedure UpdateLanguage;
begin
  if not FileExists(LangFile) then Exit;
  with TIniFile.Create(LangFile) do
  try
    ButtonNextCaption := ReadString('Button', 'Next', ButtonNextCaption);
    ButtonGOCaption := ReadString('Button', 'GO', ButtonGOCaption);
    ButtonExitCaption := ReadString('Button', 'Exit', ButtonExitCaption);
    ButtonPauseCaption := ReadString('Button', 'Pause', ButtonPauseCaption);
    ButtonResumeCaption := ReadString('Button', 'Resume', ButtonResumeCaption);
    ButtonAbortCaption := ReadString('Button', 'Abort', ButtonAbortCaption);
    ButtonCloseCaption := ReadString('Button', 'Close', ButtonCloseCaption);

    NoDriver := ReadString('String', 'NoDriver', NoDriver);

    NoTrackSelected := ReadString('String', 'NoTrackSelected', NoTrackSelected);
    NoCDFound := ReadString('String', 'NoCDFound', NoCDFound);

    CDDBMsgConnect := ReadString('String', 'CDDBConnect', CDDBMsgConnect);
    CDDBMsgSuccess := ReadString('String', 'CDDBSuccess', CDDBMsgSuccess);
    CDDBMsgFailed := ReadString('String', 'CDDBFailed', CDDBMsgFailed);

    OutputFolderError := ReadString('String', 'OutputFolderError', OutputFolderError);
    FileNameRuleError := ReadString('String', 'FileNameRuleError', FileNameRuleError);
    CreateFolderError := ReadString('String', 'CreateFolderError', CreateFolderError);

    UnknownArtist := ReadString('String', 'UnknownArtist', UnknownArtist);
    UnkonwnAlbum := ReadString('String', 'UnkonwnAlbum', UnkonwnAlbum);

    ProgressLabel := ReadString('String', 'Progress', ProgressLabel);

    QuitProcess := ReadString('String', 'AbortOperation', QuitProcess);

    LogStart := ReadString('String', 'LogStart', LogStart);
    LogRip := ReadString('String', 'LogRip', LogRip);
    LogEncode := ReadString('String', 'LogEncode', LogEncode);
    LogSuccess := ReadString('String', 'LogSuccess', LogSuccess);
    LogFailed := ReadString('String', 'LogFailed', LogFailed);
    LogCanceled := ReadString('String', 'LogCanceled', LogCanceled);
    LogFinish := ReadString('String', 'LogFinish', LogFinish);

    RegInfoNotComplete := ReadString('String', 'RegInfoNotComplete', RegInfoNotComplete);
    RegFailed := ReadString('String', 'RegFailed', RegFailed);
    RegSuccess := ReadString('String', 'RegSuccess', RegSuccess);

    PlaylistFilter := ReadString('String', 'PlaylistFilter', PlaylistFilter);
    PlaylistFailed := ReadString('String', 'PlaylistFailed', PlaylistFailed);

    HomePage := ReadString('Other', 'HomePage', URL_HOMEPAGE);
    SupportURL := ReadString('Other', 'Support', URL_SUPPORT);
    OrderURL := ReadString('Other', 'OrderURL', URL_ORDER);
    CHMFile := ReadString('Other', 'HelpFile', URL_HELPFILE);

    FullVersion := ReadString('About', 'FullVersion', STR_FULLVERSION);
  finally
    Free;
  end;
end;

end.
