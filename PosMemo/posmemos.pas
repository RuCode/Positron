{
  Главный компонент для редактирования текста
}

unit PosMemos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Graphics, ExtCtrls, Dialogs, CustomPosMemos, FileTreeViews, MiniMaps;

type

  { TPosMemo }

  TPosMemo = class(TCustomPanel)
  private
    fMemo: TCustomPosMemo;
    fOnChangeActiveTab: TNotifyEvent;
    fTree: TFileTreeView;
    fLeftSplit: TSplitter;
    fMiniMap: TMiniMap;
    function GetActiveItem: TTabData;
    function GetAvaibleData: boolean;
    function GetCount: integer;
    function GetEmpty: boolean;
    function GetFileName: string;
    function GetItemIndex: integer;
    function GetLines: TStrings;
    function GetModified: boolean;
    function GetOnChangeActiveTab: TNotifyEvent;
    function GetOnCloseAllTab: TNotifyEvent;
    function GetOnCloseOtherTab: TNotifyEvent;
    function GetOnCloseTab: TQuestionEvent;
    function GetTabData(Index: integer): TTabData;
    procedure SetItemIndex(AValue: integer);
    procedure SetLines(AValue: TStrings);
    procedure SetModified(AValue: boolean);
    procedure SetOnChangeActiveTab(AValue: TNotifyEvent);
    procedure SetOnCloseAllTab(AValue: TNotifyEvent);
    procedure SetOnCloseOtherTab(AValue: TNotifyEvent);
    procedure SetOnCloseTab(AValue: TQuestionEvent);
  protected
    procedure ChangeTab(Sender: TObject);
    procedure OpenFileFromTree(FileName: String);
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  public
    function New: integer;
    function Open(FileName: string): integer;
    procedure Save(FileName: string);
    procedure Close(Index: integer);
    procedure Close;
    procedure CloseAll;
    procedure CloseOther;
    procedure Undo;
    procedure Redo;
    procedure Cut;
    procedure Copy;
    procedure Paste;
    procedure Delete;
    procedure SelectAll;
    procedure MarkLine(ALine: integer; AColor: TColor);
    property Items[Index: integer]: TTabData read GetTabData;
  published
    property AvaibleData: boolean read GetAvaibleData;
    property IsEmpty: boolean read GetEmpty;
    property ActiveItem: TTabData read GetActiveItem;
    property ItemIndex: integer read GetItemIndex write SetItemIndex;
    property Count: integer read GetCount;
    property Lines: TStrings read GetLines write SetLines;
    property Modified: boolean read GetModified write SetModified;
    property FileName: string read GetFileName;
    property OnCloseTab: TQuestionEvent read GetOnCloseTab write SetOnCloseTab;
    property OnCloseAllTab: TNotifyEvent read GetOnCloseAllTab write SetOnCloseAllTab;
    property OnCloseOtherTab: TNotifyEvent read GetOnCloseOtherTab write SetOnCloseOtherTab;
    property OnChangeActiveTab: TNotifyEvent read fOnChangeActiveTab write SetOnChangeActiveTab;
  end;

implementation

{ TPosMemo }

constructor TPosMemo.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  fTree := TFileTreeView.Create(self);
  with fTree do
  begin
    Name := 'PosMemo_Tree';
    Parent := Self;
    Align := alLeft;
    Width := 200;
    OnOpenFile := @OpenFileFromTree;
  end;
  fLeftSplit := TSplitter.Create(Self);
  with fLeftSplit do
  begin
    Name := 'PosMemo_LeftSplitter';
    Parent := Self;
    Left := fTree.Width;
    Align := alLeft;
  end;
  fMemo := TCustomPosMemo.Create(Self);
  with fMemo do
  begin
    Name := 'PosMemo_Editor';
    Parent := Self;
    Height := 100;
    Width := 100;
    Left := fTree.Width + 4;
    Align := alClient;
  end;
  fMiniMap := TMiniMap.Create(self);
end;

destructor TPosMemo.Destroy;
begin
  fMemo.Free;
  fLeftSplit.Free;
  fTree.Free;
  fMiniMap.Free;
  inherited Destroy;
end;

function TPosMemo.New: integer;
begin
  Result := fMemo.New;
  fTree.Update(fMemo.FileName);
end;

function TPosMemo.Open(FileName: string): integer;
begin
  Result := fMemo.Open(FileName);
  fTree.Update(ExtractFilePath(fMemo.FileName));
end;

procedure TPosMemo.Save(FileName: string);
begin
  fMemo.Save(FileName);
end;

procedure TPosMemo.Close(Index: integer);
begin
  fMemo.Close(Index);
end;

procedure TPosMemo.Close;
begin
  fMemo.Close;
end;

procedure TPosMemo.CloseAll;
begin
  fMemo.CloseAll;
end;

procedure TPosMemo.CloseOther;
begin
  fMemo.CloseOther;
end;

procedure TPosMemo.Undo;
begin
  fMemo.Undo;
  fTree.Update(FileName);
end;

procedure TPosMemo.Redo;
begin
  fMemo.Redo;
  fTree.Update(FileName);
end;

procedure TPosMemo.Cut;
begin
  fMemo.Cut;
  fTree.Update(FileName);
end;

procedure TPosMemo.Copy;
begin
  fMemo.Copy;
end;

procedure TPosMemo.Paste;
begin
  fMemo.Paste;
  fTree.Update(FileName);
end;

procedure TPosMemo.Delete;
begin
  fMemo.Delete;
  fTree.Update(FileName);
end;

procedure TPosMemo.SelectAll;
begin
  fMemo.SelectAll;
end;

procedure TPosMemo.MarkLine(ALine: integer; AColor: TColor);
begin
  fMemo.MarkLine(ALine, AColor);
end;

function TPosMemo.GetOnChangeActiveTab: TNotifyEvent;
begin
  Result := fMemo.OnChangeActiveTab;
end;

function TPosMemo.GetActiveItem: TTabData;
begin
  Result := fMemo.ActiveItem;
end;

function TPosMemo.GetAvaibleData: boolean;
begin
  Result := fMemo.AvaibleData;
end;

function TPosMemo.GetCount: integer;
begin
  Result := fMemo.Count;
end;

function TPosMemo.GetEmpty: boolean;
begin
  Result := fMemo.IsEmpty;
end;

function TPosMemo.GetFileName: string;
begin
  Result := fMemo.FileName;
end;

function TPosMemo.GetItemIndex: integer;
begin
  Result := fMemo.ItemIndex;
end;

function TPosMemo.GetLines: TStrings;
begin
  Result := fMemo.Lines;
end;

function TPosMemo.GetModified: boolean;
begin
  Result := fMemo.Modified;
end;

function TPosMemo.GetOnCloseAllTab: TNotifyEvent;
begin
  Result := fMemo.OnCloseAllTab;
end;

function TPosMemo.GetOnCloseOtherTab: TNotifyEvent;
begin
  Result := fMemo.OnCloseOtherTab;
end;

function TPosMemo.GetOnCloseTab: TQuestionEvent;
begin
  Result := fMemo.OnCloseTab;
end;

function TPosMemo.GetTabData(Index: integer): TTabData;
begin
  Result := fMemo.Items[Index];
end;

procedure TPosMemo.SetItemIndex(AValue: integer);
begin
  fMemo.ItemIndex := AValue;
  fTree.Update(fMemo.FileName);
end;

procedure TPosMemo.SetLines(AValue: TStrings);
begin
  fMemo.Lines := AValue;
  fTree.Update(fMemo.FileName);
end;

procedure TPosMemo.SetModified(AValue: boolean);
begin
  fMemo.Modified := AValue;
end;

procedure TPosMemo.SetOnChangeActiveTab(AValue: TNotifyEvent);
begin
  fOnChangeActiveTab := AValue;
  fMemo.OnChangeActiveTab := @ChangeTab;
end;

procedure TPosMemo.SetOnCloseAllTab(AValue: TNotifyEvent);
begin
  fMemo.OnCloseAllTab := AValue;
end;

procedure TPosMemo.SetOnCloseOtherTab(AValue: TNotifyEvent);
begin
  fMemo.OnCloseOtherTab := AValue;
end;

procedure TPosMemo.SetOnCloseTab(AValue: TQuestionEvent);
begin
  fMemo.OnCloseTab := AValue;
end;

procedure TPosMemo.ChangeTab(Sender: TObject);
begin
  if Assigned(fOnChangeActiveTab) then
    fOnChangeActiveTab(Sender);
  fTree.Update(fMemo.FileName);
end;

procedure TPosMemo.OpenFileFromTree(FileName: String);
// Открытие файла при двойном клике по директории в fTree
var
  RootPath: String;
begin
  if ExtractLastDir(ExtractFilePath(fMemo.FileName)) = FileName then
    Exit;
  if DirectoryExists(FileName) then
    Exit;
  fTree.Update(ExtractFilePath(fMemo.FileName));
  {$MESSAGE 'Не работает открытие директории в процедуре Update'}
  { TODO : 1. Следует открыть директории до текущего файла
           2. Следует проверить FileName, что бы открытие было на 3-х и более уровнях }
  RootPath := ExtractFilePath(fMemo.FileName);
  Open(RootPath + FileName);
end;

end.

