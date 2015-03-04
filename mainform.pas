unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Menus, StdCtrls, ActnList, StdActns, LResources,
  FindText, ReplaceText, ConfigManagers, PosMemos;

type

  { TFormMain }

  TFormMain = class(TForm)
    MenuDebug: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuSelect: TMenuItem;
    MenuReplaceText: TMenuItem;
    SearchAndReplace: TAction;
    SearchText: TAction;
    FileCloseAllFiles: TAction;
    FileCloseOtherFiles: TAction;
    FileCloseFile: TAction;
    FileSaveAll: TAction;
    FileSave: TAction;
    FileNewForm: TAction;
    FileNewDynLibrary: TAction;
    FileNewUnit: TAction;
    FileNewBlank: TAction;
    EditRedo: TAction;
    ActionList: TActionList;
    EditCopy: TEditCopy;
    EditCut: TEditCut;
    EditDelete: TEditDelete;
    EditPaste: TEditPaste;
    EditSelectAll: TEditSelectAll;
    EditUndo: TEditUndo;
    FileExit: TFileExit;
    FileOpen: TFileOpen;
    FileSaveAs: TFileSaveAs;
    LabelInfo: TLabel;
    MainMenu: TMainMenu;
    MenuFile: TMenuItem;
    MenuCloseAll: TMenuItem;
    MenuCloseOther: TMenuItem;
    MenuEdit: TMenuItem;
    MenuItem1: TMenuItem;
    MenuFindText: TMenuItem;
    MenuNewDynLib: TMenuItem;
    MenuNewForm: TMenuItem;
    MenuNewUnit: TMenuItem;
    MenuSep6: TMenuItem;
    MenuNewBlank: TMenuItem;
    MenuUndo: TMenuItem;
    MenuRedo: TMenuItem;
    MenuSep4: TMenuItem;
    MenuCut: TMenuItem;
    MenuCopy: TMenuItem;
    MenuPaste: TMenuItem;
    MenuDel: TMenuItem;
    MenuSep5: TMenuItem;
    MenuNew: TMenuItem;
    MenuSelectAll: TMenuItem;
    MenuSep3: TMenuItem;
    MenuExit: TMenuItem;
    MenuClose: TMenuItem;
    MenuOpen: TMenuItem;
    MenuSave: TMenuItem;
    MenuSaveAll: TMenuItem;
    MenuSep1: TMenuItem;
    MenuSep2: TMenuItem;
    MenuSaveAs: TMenuItem;
    procedure EditCopyUpdate(Sender: TObject);
    procedure EditCutUpdate(Sender: TObject);
    procedure EditDeleteUpdate(Sender: TObject);
    procedure EditPasteUpdate(Sender: TObject);
    procedure EditRedoExecute(Sender: TObject);
    procedure EditRedoUpdate(Sender: TObject);
    procedure EditSelectAllUpdate(Sender: TObject);
    procedure EditUndoUpdate(Sender: TObject);
    procedure FileNewDynLibraryExecute(Sender: TObject);
    procedure FileNewUnitExecute(Sender: TObject);
    procedure FileOpenBeforeExecute(Sender: TObject);
    procedure FileSaveAsBeforeExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure IsFileUpdate(Sender: TObject);
    procedure FileCloseAllFilesExecute(Sender: TObject);
    procedure FileCloseFileExecute(Sender: TObject);
    procedure FileCloseOtherFilesExecute(Sender: TObject);
    procedure FileCloseOtherFilesUpdate(Sender: TObject);
    procedure FileNewBlankExecute(Sender: TObject);
    procedure FileOpenAccept(Sender: TObject);
    procedure FileSaveAsAccept(Sender: TObject);
    procedure FileSaveExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuSelectClick(Sender: TObject);
    procedure SearchAndReplaceExecute(Sender: TObject);
    procedure SearchTextExecute(Sender: TObject);
  private
    { private declarations }
    Panel: TPanel;
    procedure UpdateMainFormCaption;
    procedure ClosePanel;
    procedure OpenPanel;
    procedure StorePositionToConfig;
    procedure LoadPositionFromConfig;
    procedure StoreHistory;
    procedure LoadHistory;
  public
    { public declarations }
    Memo: TPosMemo;
    Config: TConfigManager;
    function LoadTextFromLazarusResource(AName: string): string;
    function OnCloseTab(Sender: TObject): integer;
    procedure OnCloseAllTab(Sender: TObject);
    procedure OnCloseOtherTab(Sender: TObject);
    procedure OnChangeActiveTab(Sender: TObject);
  end;

var
  FormMain: TFormMain;

implementation

{$R *.lfm}

{ TFormMain }

procedure TFormMain.FormShow(Sender: TObject);
// Открытие формы
var
  i: integer;
begin
  Memo := TPosMemo.Create(nil);
  with Memo do
  begin
    Parent := FormMain;
    Align := alClient;
  end;
  Memo.OnCloseTab := @OnCloseTab;
  Memo.OnCloseAllTab := @OnCloseAllTab;
  Memo.OnCloseOtherTab := @OnCloseOtherTab;
  Memo.OnChangeActiveTab := @OnChangeActiveTab;
  Caption := 'Positron';
  for i := 1 to Paramcount do
    Memo.Open(ParamStrUTF8(i));
  Application.Name := 'Positron';
  // Конфигурация
  Config := TConfigManager.Create;
  LoadPositionFromConfig;
  LoadHistory;
end;

procedure TFormMain.MenuItem2Click(Sender: TObject);
// Отладка - перемещение по тексту
begin
  with Memo.ActiveItem do
  begin
    Memo.CaretX := Memo.CaretX + 10;
    Memo.CaretY := Memo.CaretY + 10;
  end;
end;

procedure TFormMain.MenuItem3Click(Sender: TObject);
// Отладка - перемещение по тексту
begin
  Memo.ActiveItem.Memo.TopLine := 10;
end;

procedure TFormMain.MenuSelectClick(Sender: TObject);
// Отладка - выделение строк разным цветом
begin
  Memo.MarkLine(1, clBlack);
  Memo.MarkLine(2, clMaroon);
  Memo.MarkLine(3, clGreen);
  Memo.MarkLine(4, clOlive);
  Memo.MarkLine(5, clNavy);
  Memo.MarkLine(6, clPurple);
  Memo.MarkLine(7, clTeal);
  Memo.MarkLine(8, clGray);
  Memo.MarkLine(9, clSilver);
  Memo.MarkLine(10, clRed);
  Memo.MarkLine(11, clLime);
  Memo.MarkLine(12, clYellow);
  Memo.MarkLine(13, clBlue);
  Memo.MarkLine(14, clFuchsia);
  Memo.MarkLine(15, clAqua);
  Memo.MarkLine(16, clLtGray);
  Memo.MarkLine(17, clDkGray);
  Memo.MarkLine(18, clWhite);
end;

procedure TFormMain.SearchAndReplaceExecute(Sender: TObject);
// Поиск и замена текста
var
  FrameReplace: TFrameReplaceText;
begin
  if Memo.IsEmpty then
    exit;
  OpenPanel;
  if Assigned(Panel) then
  begin
    FrameReplace := TFrameReplaceText.Create(Panel);
    FrameReplace.Parent := Panel;
    Panel.Height := FrameReplace.Height;
    FrameReplace.Align := alClient;
    FrameReplace.EditSearch.SetFocus;
    FrameReplace.Memo := Memo.ActiveItem.Memo;
  end;
end;

procedure TFormMain.SearchTextExecute(Sender: TObject);
// Поиск текста
var
  FrameFind: TFrameFindText;
begin
  if Memo.IsEmpty then
    exit;
  OpenPanel;
  if Assigned(Panel) then
  begin
    FrameFind := TFrameFindText.Create(Panel);
    FrameFind.Parent := Panel;
    Panel.Height := FrameFind.Height;
    FrameFind.Align := alClient;
    FrameFind.Edit.SetFocus;
    FrameFind.Memo := Memo.ActiveItem.Memo;
  end;
end;

procedure TFormMain.UpdateMainFormCaption;
// Смена заголовка главной формы
begin
  exit;
  if Memo.IsEmpty then
    Caption := Application.Name
  else
  if Memo.FileName <> '' then
    Caption := Application.Name + ': ' + ExtractFileName(Memo.ActiveItem.FileName)
  else
    Caption := Application.Name;
end;

procedure TFormMain.ClosePanel;
// Закрытие панели
var
  i: integer;
begin
  if not Assigned(Panel) then
    exit;
  for i := 0 to Panel.ComponentCount - 1 do
  begin
    try
      Panel.Components[i].Free;
    except

    end;
  end;
  FreeAndNil(Panel);
end;

procedure TFormMain.OpenPanel;
// Открытие панели
begin
  ClosePanel;
  Panel := TPanel.Create(self);
  Panel.Parent := FormMain;
  Panel.Align := alBottom;
end;

procedure TFormMain.StorePositionToConfig;
// Сохранить положение главной формы
begin
  Config.BeginUpdate;
  Config.Left := Left;
  Config.Top := Top;
  Config.Width := Width;
  Config.Height := Height;
  Config.EndUpdate;
end;

procedure TFormMain.LoadPositionFromConfig;
// Восстановить положение главной формы
begin
  Config.BeginUpdate;
  Left := Config.Left;
  Top := Config.Top;
  Width := Config.Width;
  Height := Config.Height;
  Config.EndUpdate;
end;

procedure TFormMain.StoreHistory;
// Сохраняем открытые файлы

  function IsNewFile(Memo: TPosMemo; Index: integer): boolean;
  begin
    Result := (Memo.Items[Index].FileName = '');
    Result := Result and (Memo.Items[Index].TabSheet.Caption <> '');
  end;

var
  i: integer;
  HistoryItem: THistoryItem;
begin
  if not Assigned(Config) then
    exit;
  Config.BeginUpdate;
  Config.HistoryCount := Memo.Count;
  for i := 0 to Memo.Count - 1 do
  begin
    if IsNewFile(Memo, i) then
    begin
      Config.SaveTextFile(Memo.Items[i].Memo.Lines.Text, i);
      HistoryItem.FileName := Config.GetTmpFile(i);
    end
    else
    begin
      HistoryItem.FileName := Memo.Items[i].FileName;
    end;
    with Memo.Items[i] do
    begin
      HistoryItem.SelStart := Memo.SelStart;
      HistoryItem.SelLength := Memo.SelEnd;
      HistoryItem.TopLine := Memo.TopLine;
      HistoryItem.Caret := Memo.CaretXY;
      HistoryItem.SelAvail := Memo.SelAvail;
      Config.HistoryFiles[i] := HistoryItem;
    end;
  end;
  if Memo.AvaibleData then
    Config.ActiveTab := Memo.ItemIndex;
  Config.EndUpdate;
end;

procedure TFormMain.LoadHistory;
// Открываем файлы из истории
var
  i, Count, CurrentTab: integer;
  HistoryItem: THistoryItem;
begin
  if not Assigned(Config) then
    exit;
  Config.BeginUpdate;
  Count := Config.HistoryCount;
  if Count = -1 then
    exit;
  for i := 0 to Count - 1 do
  begin
    HistoryItem := Config.HistoryFiles[i];
    // Если файл не был сохранён
    if Config.IsTmpFile(HistoryItem.FileName) then
    begin
      CurrentTab := Memo.New;
      Memo.Items[CurrentTab].Memo.Lines.LoadFromFile(HistoryItem.FileName);
      Memo.Items[CurrentTab].Memo.Modified := True;
      DeleteFileUTF8(HistoryItem.FileName);
    end
    else
      // Если файл был сохранён
      CurrentTab := Memo.Open(HistoryItem.FileName);
    // Загрузска параметров
    {$Message 'Проблемы с восстановлением выделения текста'}
    if HistoryItem.SelAvail then
    begin
      Memo.Items[CurrentTab].Memo.SelStart := HistoryItem.SelStart;
      Memo.Items[CurrentTab].Memo.SelEnd := HistoryItem.SelLength;
    end
    else
      Memo.Items[CurrentTab].Memo.CaretXY := HistoryItem.Caret;
    Memo.Items[CurrentTab].Memo.TopLine := HistoryItem.TopLine;
  end;
  Memo.ItemIndex := Config.ActiveTab;
  Config.EndUpdate;
  DeleteFileUTF8(Config.ConfigName);
end;

function TFormMain.LoadTextFromLazarusResource(AName: string): string;
  // Загрузка текста из ресурсов
var
  r: TLResource;
begin
  r := LazarusResources.Find(AName);
  if r = nil then
    raise Exception.Create('Не найден ресурс: ' + AName);
  Result := r.Value;
end;

function TFormMain.OnCloseTab(Sender: TObject): integer;
  // Закрытие вкладки
var
  res: TModalResult;
begin
  Result := mrOk;
  if Memo.IsEmpty then
    exit;
  if Memo.Modified then
  begin
    res := MessageDlg('Вопрос', 'Файл ' + ExtractFileName(Memo.FileName) + ' был изменён, сохранить изменения?',
      mtConfirmation, mbYesNoCancel, '');
    case res of
      mrYes:
      begin
        Result := mrOk;
        if FileExistsUTF8(Memo.ActiveItem.FileName) then
          FileSave.Execute
        else
        begin
          FileSave.Execute;
          if not FileSaveAs.ExecuteResult then
            Result := mrAbort;
        end;
      end;
      mrNo: Result := mrOk;
      else
        Result := mrAbort;
    end;
  end;
end;

procedure TFormMain.OnCloseAllTab(Sender: TObject);
// Закрытие всех вкладок
var
  Modified: boolean;
  i: integer;
  res: TModalResult;
begin
  if Memo.IsEmpty then
    exit;
  // Узнаём наличие модифицированных файлов
  Modified := False;
  for i := 0 to Memo.Count - 1 do
    Modified := Modified or Memo.Items[i].Memo.Modified;
  // Вопрос и сохранение
  if not Modified then
    Exit;
  res := MessageDlg('Вопрос', 'Есть изменённые файлы, желаете сохранить?', mtConfirmation, mbYesNo, '');
  if res = mrYes then
    for i := 0 to Memo.Count - 1 do
      if Memo.Items[i].Memo.Modified then
      begin
        Memo.ItemIndex := i;
        FileSave.Execute;
      end;
end;

procedure TFormMain.OnCloseOtherTab(Sender: TObject);
// Закрытие всех вкладок кроме текущей
begin
  // Разницы в целом нет, всё равно закрытие происходит в классе
  OnCloseAllTab(Self);
end;

procedure TFormMain.OnChangeActiveTab(Sender: TObject);
// Действия при смене активной вкладки
begin
  UpdateMainFormCaption;
end;

procedure TFormMain.FileNewBlankExecute(Sender: TObject);
// Создать пустой файл
begin
  Memo.New;
end;

procedure TFormMain.FileOpenAccept(Sender: TObject);
// Открыть файл
begin
  Memo.Open(FileOpen.Dialog.FileName);
  UpdateMainFormCaption;
end;

procedure TFormMain.FileSaveAsAccept(Sender: TObject);
// Сохранить как
begin
  Memo.Save(FileSaveAs.Dialog.FileName);
  UpdateMainFormCaption;
end;

procedure TFormMain.FileSaveExecute(Sender: TObject);
// Сохранить
begin
  if Memo.IsEmpty then
    exit;
  if not FileExistsUTF8(Memo.ActiveItem.FileName) then
    FileSaveAs.Execute
  else
    Memo.Save(Memo.ActiveItem.FileName);
end;

procedure TFormMain.FileCloseAllFilesExecute(Sender: TObject);
// Закрыть все файлы
begin
  Memo.CloseAll;
end;

procedure TFormMain.FileCloseFileExecute(Sender: TObject);
// Закрыть активный файл
begin
  Memo.Close;
end;

procedure TFormMain.IsFileUpdate(Sender: TObject);
// Обновить экшены, если открыты файлы
begin
  inherited;
  TAction(Sender).Enabled := Memo.Count <> 0;
  FileSaveAs.Enabled := TAction(Sender).Enabled;
end;

procedure TFormMain.FileNewUnitExecute(Sender: TObject);
// Создание нового юнита
begin
  FileNewBlank.Execute;
  Memo.Lines.Text := LoadTextFromLazarusResource('TemplateUnit');
end;

procedure TFormMain.FileOpenBeforeExecute(Sender: TObject);
begin

end;

procedure TFormMain.FileSaveAsBeforeExecute(Sender: TObject);
// Установка имени файла для диалога "Сохранить как"
begin
  if Memo.IsEmpty then
    exit;
  FileSaveAs.Dialog.FileName := Memo.ActiveItem.FileName;
end;

procedure TFormMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
// Смываем именно в FormClose
begin
  StorePositionToConfig;
  StoreHistory;
  Config.Free;
  Memo.Free;
  CloseAction := caFree;
end;

procedure TFormMain.FileNewDynLibraryExecute(Sender: TObject);
// Создание новой библиотеки
begin
  FileNewBlank.Execute;
  Memo.Lines.Text := LoadTextFromLazarusResource('TemplateLib');
end;

procedure TFormMain.EditRedoExecute(Sender: TObject);
// Повторить действие
begin
  if Memo.IsEmpty then
    exit;
  Memo.ActiveItem.Memo.Redo;
end;

procedure TFormMain.EditCutUpdate(Sender: TObject);
// Обновление экшена для меню Правка->Вырезать
begin
  inherited;
  if Memo.IsEmpty then
  begin
    TAction(Sender).Enabled := False;
    exit;
  end
  else
    TAction(Sender).Enabled := Memo.ActiveItem.Memo.SelAvail;
end;

procedure TFormMain.EditDeleteUpdate(Sender: TObject);
// Обновление экшена для меню Правка->Удалить
begin
  inherited;
  if Memo.IsEmpty then
  begin
    TAction(Sender).Enabled := False;
    exit;
  end
  else
    TAction(Sender).Enabled := Memo.ActiveItem.Memo.SelAvail;
end;

procedure TFormMain.EditPasteUpdate(Sender: TObject);
// Обновление экшена для меню Правка->Вставить
begin
  inherited;
  if Memo.IsEmpty then
  begin
    TAction(Sender).Enabled := False;
    exit;
  end
  else
    TAction(Sender).Enabled := Memo.ActiveItem.Memo.CanPaste;
end;

procedure TFormMain.EditCopyUpdate(Sender: TObject);
// Обновление экшена для меню Правка->Копировать
begin
  inherited;
  if Memo.IsEmpty then
  begin
    TAction(Sender).Enabled := False;
    exit;
  end
  else
    TAction(Sender).Enabled := Memo.ActiveItem.Memo.SelAvail;
end;

procedure TFormMain.EditRedoUpdate(Sender: TObject);
// Обновление экшена для редо
begin
  inherited;
  if Memo.IsEmpty then
  begin
    TAction(Sender).Enabled := False;
    exit;
  end
  else
    TAction(Sender).Enabled := Memo.ActiveItem.Memo.CanRedo;
end;

procedure TFormMain.EditSelectAllUpdate(Sender: TObject);
// Обновление экшена для меню Правка->Выделить всё
begin
  inherited;
  if Memo.IsEmpty then
  begin
    TAction(Sender).Enabled := False;
    exit;
  end
  else
    TAction(Sender).Enabled := Memo.ActiveItem.Memo.Text <> '';
end;

procedure TFormMain.EditUndoUpdate(Sender: TObject);
// Обновление экшена для отмены действий
begin
  inherited;
  if Memo.IsEmpty then
  begin
    TAction(Sender).Enabled := False;
    exit;
  end
  else
    TAction(Sender).Enabled := Memo.ActiveItem.Memo.CanUndo;
end;

procedure TFormMain.FileCloseOtherFilesExecute(Sender: TObject);
// Закрыть другие файлы
begin
  Memo.CloseOther;
end;

procedure TFormMain.FileCloseOtherFilesUpdate(Sender: TObject);
// Обновление экщена по закрытию других файлов
begin
  inherited;
  TAction(Sender).Enabled := Memo.Count > 1;
end;

initialization
  {$I resource.lrs}

end.
