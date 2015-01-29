unit ConfigManagers;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, FileUtil, IniFiles;

const
  INVALID_VALUE = -1;

  SECTION_POSITION = 'POSITION';
  ITEM_LEFT = 'LEFT';
  ITEM_TOP = 'TOP';
  ITEM_WIDTH = 'WIDTH';
  ITEM_HEIGHT = 'HEIGHT';

  SECTION_HISTORY = 'HISTORY';
  ITEM_COUNT = 'COUNT';
  ITEM_FILE = 'FILE_';
  ITEM_SELSTART = 'SELSTART_';
  ITEM_SELLEN = 'SELLEN_';
  ITEM_TOPLINE = 'TOPLINE_';
  ITEM_CARETX = 'CARET_X_';
  ITEM_CARETY = 'CARET_Y_';
  ITEM_SELAVAIL = 'SELECT_AVAIBLE_';
  ITEM_ACTIVETAB = 'ACTIVE_TAB';

type
  THistoryItem = record
    FileName: string;
    SelStart: integer;
    SelLength: integer;
    TopLine: integer;
    Caret: TPoint;
    SelAvail: boolean;
  end;

type

  { TConfigManager }

  TConfigManager = class
  private
    fIniFile: TIniFile;
    fUpdate: boolean;
    function GetActiveTab: integer;
    function GetConfigName: string;
    function GetHeight: integer;
    function GetHistoryCount: integer;
    function GetHistoryFiles(Index: integer): THistoryItem;
    function GetLeft: integer;
    function GetTop: integer;
    function GetWidth: integer;
    procedure SetActiveTab(AValue: integer);
    procedure SetHeight(AValue: integer);
    procedure SetHistoryCount(AValue: integer);
    procedure SetHistoryFiles(Index: integer; AValue: THistoryItem);
    procedure SetLeft(AValue: integer);
    procedure SetTop(AValue: integer);
    procedure SetWidth(AValue: integer);
  private
    function GetTmpPath: string;
    procedure Open;
    procedure Close;
    procedure ForceFile(FilePath: string);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure SaveTextFile(const Text: string; Index: integer);
    function GetTmpFile(Index: integer): string;
    function IsTmpFile(FileName: string): boolean;
    // В случае изменения большого числа параметров
    procedure BeginUpdate;
    procedure EndUpdate;
    // Имя файла по умолчанию
    property ConfigName: string read GetConfigName;
    property TmpPath: string read GetTmpPath;
    // MainWindow - Позиция
    property Left: integer read GetLeft write SetLeft;
    property Top: integer read GetTop write SetTop;
    property Width: integer read GetWidth write SetWidth;
    property Height: integer read GetHeight write SetHeight;
    // Последние открытые файлы
    property HistoryCount: integer read GetHistoryCount write SetHistoryCount;
    property HistoryFiles[Index: integer]: THistoryItem read GetHistoryFiles write SetHistoryFiles;
    property ActiveTab: integer read GetActiveTab write SetActiveTab;
    // Тема для редактора
  end;

implementation

{ TConfigManager }

function TConfigManager.GetConfigName: string;
begin
  Result := GetUserDir + '.config/positron/main.conf';
end;

function TConfigManager.GetActiveTab: integer;
begin
  Open;
  Result := fIniFile.ReadInteger(SECTION_HISTORY, ITEM_ACTIVETAB, 0);
  Close;
end;

function TConfigManager.GetHeight: integer;
begin
  Open;
  Result := fIniFile.ReadInteger(SECTION_POSITION, ITEM_HEIGHT, 350);
  Close;
end;

function TConfigManager.GetHistoryCount: integer;
begin
  Open;
  Result := fIniFile.ReadInteger(SECTION_HISTORY, ITEM_COUNT, -1);
  Close;
end;

function TConfigManager.GetHistoryFiles(Index: integer): THistoryItem;
begin
  Open;
  Result.FileName := fIniFile.ReadString(SECTION_HISTORY, ITEM_FILE + IntToStr(Index), '');
  Result.SelStart := fIniFile.ReadInteger(SECTION_HISTORY, ITEM_SELSTART + IntToStr(Index), 0);
  Result.SelLength := fIniFile.ReadInteger(SECTION_HISTORY, ITEM_SELLEN + IntToStr(Index), 0);
  Result.TopLine := fIniFile.ReadInteger(SECTION_HISTORY, ITEM_TOPLINE + IntToStr(Index), 0);
  Result.Caret.X := fIniFile.ReadInteger(SECTION_HISTORY, ITEM_CARETX + IntToStr(Index), 0);
  Result.Caret.Y := fIniFile.ReadInteger(SECTION_HISTORY, ITEM_CARETY + IntToStr(Index), 0);
  Result.SelAvail := fIniFile.ReadBool(SECTION_HISTORY, ITEM_SELAVAIL + IntToStr(Index), False);
  Close;
end;

function TConfigManager.GetLeft: integer;
begin
  Open;
  Result := fIniFile.ReadInteger(SECTION_POSITION, ITEM_LEFT, 100);
  Close;
end;

function TConfigManager.GetTop: integer;
begin
  Open;
  Result := fIniFile.ReadInteger(SECTION_POSITION, ITEM_TOP, 100);
  Close;
end;

function TConfigManager.GetWidth: integer;
begin
  Open;
  Result := fIniFile.ReadInteger(SECTION_POSITION, ITEM_WIDTH, 600);
  Close;
end;

procedure TConfigManager.SetActiveTab(AValue: integer);
begin
  Open;
  fIniFile.WriteInteger(SECTION_HISTORY, ITEM_ACTIVETAB, AValue);
  Close;
end;

procedure TConfigManager.SetHeight(AValue: integer);
begin
  Open;
  fIniFile.WriteInteger(SECTION_POSITION, ITEM_HEIGHT, AValue);
  Close;
end;

procedure TConfigManager.SetHistoryCount(AValue: integer);
begin
  Open;
  fIniFile.WriteInteger(SECTION_HISTORY, ITEM_COUNT, AValue);
  Close;
end;

procedure TConfigManager.SetHistoryFiles(Index: integer; AValue: THistoryItem);
begin
  Open;
  fIniFile.WriteString(SECTION_HISTORY, ITEM_FILE + IntToStr(Index), AValue.FileName);
  fIniFile.WriteInteger(SECTION_HISTORY, ITEM_SELSTART + IntToStr(Index), AValue.SelStart);
  fIniFile.WriteInteger(SECTION_HISTORY, ITEM_SELLEN + IntToStr(Index), AValue.SelLength);
  fIniFile.WriteInteger(SECTION_HISTORY, ITEM_TOPLINE + IntToStr(Index), AValue.TopLine);
  fIniFile.WriteInteger(SECTION_HISTORY, ITEM_CARETX + IntToStr(Index), AValue.Caret.X);
  fIniFile.WriteInteger(SECTION_HISTORY, ITEM_CARETY + IntToStr(Index), AValue.Caret.Y);
  fIniFile.WriteBool(SECTION_HISTORY, ITEM_SELAVAIL + IntToStr(Index), AValue.SelAvail);
  Close;
end;

procedure TConfigManager.SetLeft(AValue: integer);
begin
  Open;
  fIniFile.WriteInteger(SECTION_POSITION, ITEM_LEFT, AValue);
  Close;
end;

procedure TConfigManager.SetTop(AValue: integer);
begin
  Open;
  fIniFile.WriteInteger(SECTION_POSITION, ITEM_TOP, AValue);
  Close;
end;

procedure TConfigManager.SetWidth(AValue: integer);
begin
  Open;
  fIniFile.WriteInteger(SECTION_POSITION, ITEM_WIDTH, AValue);
  Close;
end;

function TConfigManager.GetTmpPath: string;
begin
  Result := ExtractFilePath(ConfigName) + 'tmp';
end;

procedure TConfigManager.Open;
begin
  ForceFile(ConfigName);
  if not Assigned(fIniFile) then
    fIniFile := TIniFile.Create(ConfigName);
end;

procedure TConfigManager.Close;
begin
  if not fUpdate then
    fIniFile.Free;
end;

procedure TConfigManager.ForceFile(FilePath: string);
var
  ConfDir: RawByteString;
  ConfName: RawByteString;
begin
  ConfDir := ExtractFilePath(FilePath);
  ConfName := ExtractFileName(FilePath);
  if not DirectoryExistsUTF8(ConfDir) then
    ForceDirectoriesUTF8(ConfDir);
  if not FileExistsUTF8(ConfDir + ConfName) then
    FileClose(FileCreateUTF8(ConfDir + ConfName));
end;

constructor TConfigManager.Create;
begin
  inherited Create;
  fUpdate := False;
end;

destructor TConfigManager.Destroy;
begin
  inherited Destroy;
end;

procedure TConfigManager.SaveTextFile(const Text: string; Index: integer);
var
  FilePath: string;
  hFile: TextFile;
begin
  FilePath := GetTmpFile(Index);
  ForceFile(FilePath);
  AssignFile(hFile, FilePath);
  Rewrite(hFile);
  Write(hFile, Text);
  CloseFile(hFile);
end;

function TConfigManager.GetTmpFile(Index: integer): string;
begin
  Result := GetTmpPath + '/nf' + IntToStr(Index);
end;

function TConfigManager.IsTmpFile(FileName: string): boolean;
begin
  Result := Pos(GetTmpPath + '/nf', FileName) <> 0;
end;

procedure TConfigManager.BeginUpdate;
begin
  fUpdate := True;
end;

procedure TConfigManager.EndUpdate;
begin
  fUpdate := False;
end;

end.

