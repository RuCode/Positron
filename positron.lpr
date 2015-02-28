program positron;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  synuni,
  MainForm,
  FindText,
  ReplaceText,
  PositronUtils,
  ThemeManagers,
  ConfigManagers, filetreeviews,
  pl_virtualtrees, MiniMaps, CustomPosMemos, posmemos;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
