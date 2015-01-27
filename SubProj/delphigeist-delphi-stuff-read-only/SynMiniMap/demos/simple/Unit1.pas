unit Unit1;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, SynMiniMap, SynEdit, SynEditHighlighter,
  SynHighlighterPas;

type
  TForm1 = class(TForm)
    SynMiniMap1: TSynMiniMap;
    PageControl1: TPageControl;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SynPasSyn1: TSynPasSyn;
    procedure Open1Click(Sender: TObject);
    procedure SynMiniMap1Click(Sender: TObject; Data: PSynMiniMapEventData);
  private
    procedure OnTabShow(Sender: TObject);
  public
    { Public declarations }
  end;

  TDGTabSheet = class(TTabSheet)
  public
    Editor: TSynEdit;
    FileName: string;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.OnTabShow(Sender: TObject);
begin
  SynMiniMap1.Editor := TDGTabSheet(Sender).Editor;
  Caption := TDGTabSheet(Sender).FileName;
end;

procedure TForm1.Open1Click(Sender: TObject);
var
  Index: Integer;

    procedure CreateTabSheet;
    var
      LTabSheet: TDGTabSheet;
      LEditor: TSynEdit;
      LFileName: string;
    begin
      LFileName := OpenDialog1.Files[Index];
      LTabSheet := TDGTabSheet.Create(PageControl1);
      LTabSheet.Caption := ExtractFileName(LFileName);
      LTabSheet.FileName := LFileName;
      LTabSheet.PageControl := PageControl1;
      LTabSheet.OnShow := OnTabShow;
      LEditor := TSynEdit.Create(LTabSheet);
      LEditor.Parent := LTabSheet;
      LEditor.Align := alClient;
      LEditor.Highlighter := SynPasSyn1;
      LTabSheet.Editor := LEditor;
      LEditor.Lines.LoadFromFile(LFileName);
      PageControl1.ActivePageIndex := PageControl1.PageCount -1;
      if OpenDialog1.Files.Count = 1 then
        LTabSheet.OnShow(LTabSheet);
    end;

begin
  if OpenDialog1.Execute then
    for Index := 0 to OpenDialog1.Files.Count -1 do
      CreateTabSheet;
end;

procedure TForm1.SynMiniMap1Click(Sender: TObject; Data: PSynMiniMapEventData);
begin
  if SynMiniMap1.Editor <> NIL then begin
    SynMiniMap1.Editor := TDGTabSheet(Sender).Editor;
  Caption := TDGTabSheet(Sender).FileName;
    SynMiniMap1.ResetInternals;
  end;
  SynMiniMap1.ReAlign;
end;

end.