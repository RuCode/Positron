{
  Компонент предок PosMemo - осуществляет навигацию по файлам\коду
  Автор: RuCode

  TODO:

    Данный компонент должен предоставлять возможность отображения в виде дереве
  следующего набора данных:
  - Дерево файлов текущей директории (F1)
  - Дерево проекта (F2)
  - Дерево форм и фрэймов (F3)
  - Дерево классов и функций текущего модуля (F4)

    По двойному клику на дереве должен выполняться некий метод, например:
  - Открытие файла в редакторе
  - Открытие формы в редакторе форм (?)
  - Переход в редакторе к выбранному элементу
}

unit FileTreeViews;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics,
  Dialogs, ComCtrls, ExtCtrls, LResources, LCLProc;

const
  IMAGES_FOLDER = 'folder';
  IMAGES_FILEPAS = 'text-x-pascal';

type
  TTreeViewState = (tvsFolder, tvsProject, tvsForms, tvsUnit);
  TNotifyOpenFileEvent = procedure(FileName: string) of object;

  { TFileTreeView }

  TFileTreeView = class(TTreeView)
  private
    fNotifyOpenEvent: TNotifyOpenFileEvent;
    fState: TTreeViewState;
    fImages: TImageList;
  protected
    procedure DblClick; override;
    procedure ExpandTree(ARoot: TTreeNode; AList: TStringList);
    procedure ExpandToFile(APath: string);
  public
    constructor Create(AnOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateViewPort(APath: string);
    procedure OpenFolder(APath: string; ParentNode: TTreeNode = nil);
    procedure OpenProject(APath: string);
    procedure OpenForms(APath: string);
    procedure OpenUnit(APath: string);
    property OnOpenFile: TNotifyOpenFileEvent read fNotifyOpenEvent write fNotifyOpenEvent;
  end;

function ExtractLastDir(DirPath: string): string;

implementation

function ExtractLastDir(DirPath: string): string;
  // Получение имени последней директории
var
  i, fromDel: integer;
begin
  fromDel := -1;
  for i := Length(DirPath) downto 1 do
    if DirPath[i] = DirectorySeparator then
    begin
      if i = Length(DirPath) then
        Continue;
      fromDel := i;
      Break;
    end;
  SetLength(Result, Length(DirPath) - fromDel);
  for i := fromDel to Length(DirPath) - 1 do
    Result[i - fromDel + 1] := DirPath[i + 1];
end;

{ TFileTreeView }

function ExtractPathFromItem(Node: TTreeNode): string;
  // Возвращает путь от Root-директории до выбранного файла
var
  List: TStringList;
  CurrNode: TTreeNode;
  i: integer;
begin
  List := TStringList.Create;
  CurrNode := Node;
  while Assigned(CurrNode) do
  begin
    List.Add(CurrNode.Text);
    CurrNode := CurrNode.Parent;
  end;
  Result := '';
  for i := List.Count - 2 downto 0 do
    Result += List[i];
  List.Free;
end;

procedure TFileTreeView.DblClick;
begin
  inherited DblClick;
  if (tvsFolder = fState) and Assigned(Selected) then
  begin
    if Assigned(fNotifyOpenEvent) then
      fNotifyOpenEvent(ExtractPathFromItem(Selected));
  end;
end;

procedure TFileTreeView.ExpandTree(ARoot: TTreeNode; AList: TStringList);
// Рукурсивный обход
var
  i: integer;
  j: integer;
  Buf: string;
begin
  for i := 0 to ARoot.Count - 1 do
  begin
    for j := 0 to AList.Count - 1 do
    begin
      Buf := AList[j];
      if UTF8Pos(Buf, string(ARoot[i].Text)) <> 0 then
        Expand(ARoot[i]);
    end;
    if ARoot.Items[i].Count <> -1 then
      ExpandTree(ARoot.Items[i], AList);
  end;
end;

procedure TFileTreeView.ExpandToFile(APath: string);
// Линейная процедура
var
  list: TStringList;
  Buf: string;
  i: integer;
begin
  // Разбиваем путь на составляющие
  list := TStringList.Create;
  i := 1;
  Buf := '';
  repeat
    if APath[i] <> DirectorySeparator then
      Buf += APath[i]
    else
    begin
      list.Add(Buf);
      Buf := '';
    end;
    Inc(i);
  until i = Length(APath);
  Buf += APath[i];
  list.Add(Buf);
  // Открываем
  ExpandTree(Items[0], list);
  Expand(Items[0]);
  list.Free;
end;

constructor TFileTreeView.Create(AnOwner: TComponent);
var
  Opt: TTreeViewOptions;
begin
  inherited Create(AnOwner);
  fImages := TImageList.Create(self);
  fImages.Width := 24;
  fImages.Height := 24;
  fImages.AddLazarusResource(IMAGES_FOLDER);
  fImages.AddLazarusResource(IMAGES_FILEPAS);
  self.Images := fImages;
  self.StateImages := fImages;
  fState := tvsFolder;
  Opt := self.Options;
  Opt += [tvoReadOnly];
  self.Options := Opt;
end;

destructor TFileTreeView.Destroy;
begin
  fImages.Free;
  inherited Destroy;
end;

procedure TFileTreeView.UpdateViewPort(APath: string);
begin
  if APath = '' then
    Exit;
  case fstate of
    tvsFolder:
    begin
      OpenFolder(ExtractFilePath(APath));
      ExpandToFile(APath);
    end;

    else
      ShowMessage('Остальные варианты пока не реализованы');
  end;
  //  Items[0].Expand(False);
end;

procedure TFileTreeView.OpenFolder(APath: string; ParentNode: TTreeNode = nil);
var
  Info: TSearchRec;
  RootNode: TTreeNode;
begin
  // Если первый раз попали сюда
  if ParentNode = nil then
  begin
    Items.Clear;
    fState := tvsFolder;
    RootNode := Items.Add(nil, ExtractLastDir(APath));
    RootNode.ImageIndex := 0;
    RootNode.SelectedIndex := 0;
  end
  else
  begin
    RootNode := Items.AddChildFirst(ParentNode, ExtractLastDir(APath));
    RootNode.ImageIndex := 0;
    RootNode.SelectedIndex := 0;
  end;
  // Проходим по файлам
  if FindFirst(APath + '*', faAnyFile and faDirectory, Info) = 0 then
  begin
    repeat
      with Info do
      begin
        if (Name = '.') or (Name = '..') then
          Continue;
        if (Attr and faDirectory) = faDirectory then
          OpenFolder(APath + Name + DirectorySeparator, RootNode)
        else
          with Items.AddChild(RootNode, Name) do
          begin
            ImageIndex := 1;
            SelectedIndex := 1;
          end;
      end;
    until FindNext(info) <> 0;
  end;
  FindClose(Info);
end;

procedure TFileTreeView.OpenProject(APath: string);
begin

end;

procedure TFileTreeView.OpenForms(APath: string);
begin

end;

procedure TFileTreeView.OpenUnit(APath: string);
begin

end;

initialization
  {$I treeview.lrs}

end.
