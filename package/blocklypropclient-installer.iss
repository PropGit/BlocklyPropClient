; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "BlocklyPropClient"
#define MyAppVersion "0.6.3"
#define MyAppPublisher "Parallax Inc."
#define MyAppURL "http://blockly.parallax.com/"
#define MyAppExeName "BlocklyPropClient.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{68253492-3191-4F74-B077-379DD3235D37}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DisableProgramGroupPage=yes
OutputDir=..\dist
OutputBaseFilename=BlocklyPropClient-setup
SetupIconFile=..\dist\BlocklyPropClient.windows\blocklyprop.ico
Compression=lzma
SolidCompression=yes
DisableWelcomePage=no
WizardImageFile=win-resources\BlocklyPropClient-windows-installer-background.bmp

[Messages]
BeveledLabel=BlocklyPropClient Setup

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Components]
Name: "program"; Description: "Program Files"; Types: full compact custom; Flags: fixed
Name: "driver"; Description: "FTDI driver"; Types: full

[Files]
Source: "..\dist\BlocklyPropClient.windows\BlocklyPropClient.exe"; DestDir: "{app}"; Flags: ignoreversion; Components: program
Source: "..\dist\BlocklyPropClient.windows\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: program
Source: "win-resources\readme.txt"; DestDir: "{app}"; Flags: isreadme; Components: program
Source: "..\drivers\Install-Parallax-USB-Drivers-v2.12.16.exe"; DestDir: "{app}\drivers"; AfterInstall: RunDriverInstaller; Flags: ignoreversion; Components: driver
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{commonprograms}\Parallax Inc\BlocklyProp\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{userdesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
procedure RunDriverInstaller;
var
  ResultCode: Integer;
begin
  if not Exec(ExpandConstant('{app}\drivers\Install-Parallax-USB-Drivers-v2.12.16.exe'), '/UpperLeft /Immediate', '', SW_SHOWNORMAL,
    ewWaitUntilTerminated, ResultCode)
  then
    MsgBox('USB Driver Installer failed to run!' + #13#10 +
      SysErrorMessage(ResultCode), mbError, MB_OK);
end;

