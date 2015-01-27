unit CustomPosMemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynMemo, SynHighlighterPas, SynHighlighterAny,
  SynCompletion, SynUniHighlighter, Forms, Controls, Graphics, Dialogs,
  ComCtrls, fgl;

type

  TTabData = record
    FileName: TFileName;
    Memo: TSynMemo;
  end;

type

  { TCustomPosMemo }

  TCustomPosMemo = class(TPageControl)
  private
    fTabs: fgl.
    function GetCountFiles: Integer;
    function GetTabData(Index: Integer): TTabData;
  protected
  public
    // Работа с файлами
    procedure New;
    procedure Open(FileName: TFileName);
    procedure Save(FileName: TFileName);
    procedure Close;
    procedure CloseOther;
    // Редактирование
    procedure Undo;
    procedure Redo;
    procedure Cut;
    procedure Copy;
    procedure Paste;
    procedure Delete;
    procedure SelectAll;
    // Поиск и замена текста
    procedure FindText(AText: String);
    procedure ReplaceText(ATemplateText, AForReplaceText: String);
    // Настройки редактора
    // SetTheme, SetConfig, Set[Автозамена, Автонабор] и т.д.
  public
    property CountFiles: Integer read GetCountFiles;
    property TabData[Index: Integer]: TTabData read GetTabData;

  end;

implementation

{ TCustomPosMemo }

function TCustomPosMemo.GetCountFiles: Integer;
begin

end;

function TCustomPosMemo.GetMemoFile(Index: Integer): TMemoFile;
begin

end;

function TCustomPosMemo.GetTabData(Index: Integer): TTabData;
begin

end;

procedure TCustomPosMemo.New;
begin

end;

procedure TCustomPosMemo.Open(FileName: TFileName);
begin

end;

procedure TCustomPosMemo.Save(FileName: TFileName);
begin

end;

procedure TCustomPosMemo.Close;
begin

end;

procedure TCustomPosMemo.CloseOther;
begin

end;

procedure TCustomPosMemo.Undo;
begin

end;

procedure TCustomPosMemo.Redo;
begin

end;

procedure TCustomPosMemo.Cut;
begin

end;

procedure TCustomPosMemo.Copy;
begin

end;

procedure TCustomPosMemo.Paste;
begin

end;

procedure TCustomPosMemo.Delete;
begin

end;

procedure TCustomPosMemo.SelectAll;
begin

end;

procedure TCustomPosMemo.FindText(AText: String);
begin

end;

procedure TCustomPosMemo.ReplaceText(ATemplateText, AForReplaceText: String);
begin

end;

end.

