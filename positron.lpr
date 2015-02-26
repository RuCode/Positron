program positron;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  synuni,
  MainForm,
  CustomPosMemo,
  FindText,
  ReplaceText,
  PositronUtils,
  ThemeManagers,
  FileTreeViews,
  ConfigManagers,
  pl_virtualtrees;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
