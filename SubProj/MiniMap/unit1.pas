unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynMemo, SynHighlighterPas, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, Menus, StdCtrls, SynMiniMap, SynEdit;

type

  { TMainForm }

  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Panel: TPanel;
		ScrollBar1: TScrollBar;
    SynFreePascalSyn1: TSynFreePascalSyn;
    SynMemo: TSynMemo;
    procedure FormCreate(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
  private
    { private declarations }
  public
    SynMiniMap: TSynMiniMap;
    { public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  SynMiniMap := TSynMiniMap.Create(Panel);
  SynMiniMap.Parent := Panel;
  SynMiniMap.Align := alClient;
  {$Warnings OFF}
  SynMiniMap.Editor := TSynEdit(SynMemo);
  {$Warnings ON}
  SynMemo.CaretY := 100;
  SynMiniMap.Options.AllowScroll := True;
end;

procedure TMainForm.MenuItem2Click(Sender: TObject);
begin
  SynMiniMap.ResetInternals;
end;

end.

