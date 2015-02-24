{
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
  Dialogs, ComCtrls, ExtCtrls, LResources;

const
  IMAGES_FOLDER = 'folder';
  IMAGES_FILEPAS = 'text-x-pascal';

type
  TTreeViewState = (tvsFolder, tvsProject, tvsForms, tvsUnit);

  { TFileTreeView }

  TFileTreeView = class(TTreeView)
  private
    fState: TTreeViewState;
    fImages: TImageList;
  protected
    procedure DblClick; override;
  public
    constructor Create(AnOwner: TComponent); override;
    destructor Destroy; override;
    procedure OpenFolder(APath: string; ParentNode: TTreeNode = nil);
    procedure OpenProject(APath: string);
    procedure OpenForms(APath: string);
    procedure OpenUnit(APath: string);
  end;

function ExtractLastDir(DirPath: string): string;

implementation

function ExtractLastDir(DirPath: string): string;
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

procedure TFileTreeView.DblClick;
begin
  inherited DblClick;
  if (tvsFolder = fState) and Assigned(Selected) then
  begin
    ShowMessage(Selected.Text);
    {$Message 'Тут следует вызвать событие для открытия файла по двойному клику'}
  end;
end;

constructor TFileTreeView.Create(AnOwner: TComponent);
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
end;

destructor TFileTreeView.Destroy;
begin
  fImages.Free;
  inherited Destroy;
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
          //  StateIndex := 1;
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
