//------------------------------------------------------------------------------
// Project: EZ MP3 Creator
// Unit:    ezmp3c.dpr
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: Main Program
//
// 2006-05-07
// - Initial release with comments 
//------------------------------------------------------------------------------

program ezmp3c;

uses
  Forms,
  Windows,
  Messages,
  akrip32,
  ezutils,
  wmaenc,
  Main in 'Main.pas' {frmMain},
  DiscInfo in 'DiscInfo.pas' {frmDiscInfo},
  TrackInfo in 'TrackInfo.pas' {frmTrackInfo},
  CDDBConfig in 'CDDBConfig.pas' {frmCDDBConfig},
  GetCDDB in 'GetCDDB.pas' {frmGetCDDB},
  Matches in 'Matches.pas' {frmMatches},
  Log in 'Log.pas' {frmLog},
  About in 'About.pas' {frmAbout},
  RipUnit in 'RipUnit.pas',
  Routine in 'Routine.pas',
  CFGParam in 'CFGParam.pas',
  Languages in 'Languages.pas';

{$R ezmicon.res}

var
  PrevHandle: THandle;

begin
  // Allow only one instance to run
  PrevHandle := FindWindow(EZMP3CONLYONECLASS, nil);
  if PrevHandle > 0 then
  begin
    PostMessage(PrevHandle, WM_EZMP3CONLYONE, 0, 0);
    Exit;
  end;

  // Load dynamic libraries
  if not InitEZUtils then
  begin
    MsgDlg('The application has failed to start because some libraries could ' +
      'not be loaded. Re-installing the application may fix this problem.',
      MB_OK or MB_ICONERROR);
    Exit;
  end;
  AkripInited := AkripInit;
  WMAInstalled := InitWMAENC;

  // Run
  LoadParam;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
  SaveParam;

  // Unload dynamic libraries
  UninitWMAENC;
  AkripDeinit;
  UninitEZUtils;
end.

