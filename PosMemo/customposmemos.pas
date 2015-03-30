{
  Компонент предок PosMemo осуществляет функции редактирования текста
  Автор: RuCode
}

unit CustomPosMemos;

{$mode objfpc}{$H+}
{$MODESWITCH advancedrecords}
{$StackFrames ON}

interface

uses
  SynMemo, SynHighlighterPas, SynHighlighterAny, SynEditTypes, Graphics,
  SynCompletion, SynEdit, SynUniHighlighter, Dialogs, Forms,// SynEditMarks,
  ComCtrls, fgl, Controls, LCLType, Classes, SysUtils, SynEditKeyCmds;

type
  TLineColorData = class(TObject)
    Line: integer;
    Color: TColor;
  end;

  TQuestionEvent = function(Sender: TObject): integer of object;
  TColorLineList = specialize TFPGObjectList<TLineColorData>;

type
  { TPageControlEx - PageControl с активацией вкладки, которую надо закрыть }

  TPageControlEx = class(TPageControl)
  public
    procedure DoCloseTabClicked(APage: TCustomPage); override;
  end;

  { TTabData - Каждая вкладка несёт данную в этом обьекте информацию }

  { TODO 10 : Однако, что бы не плодить миллион окон, следует добавить возможность открывать фрэймы во вкладках, типа всяких манагеров }

  TTabData = class(TObject)
    XHash: longword;
    FileName: string;
    Highlight: TSynFreePascalSyn;
    Memo: TSynMemo;
    TabSheet: TTabSheet;
    SelectedLineList: TColorLineList;
    constructor Create(ATag: integer; fPageControl: TPageControlEx); virtual;
    destructor Destroy; override;
    procedure OnSpecialLineColors(Sender: TObject; Line: integer; var Special: boolean; var FG, BG: TColor);
  end;

  { TTabList - Массив данных для каждой вкладки }

  TTabList = specialize TFPGObjectList<TTabData>;

  { TCustomPosMemo - Сам редактор }

  TCustomPosMemo = class(TWinControl)
  private
    fOnChangeActiveTab: TNotifyEvent;
    fOnCloseAllTab: TNotifyEvent;
    fOnCloseOtherTab: TNotifyEvent;
    fPageControl: TPageControlEx;
    fOnCloseTab: TQuestionEvent;
    fTabs: TTabList;
    function GetActiveItem: TTabData;
    function GetAvaibleData: boolean;
    function GetCount: integer;
    function GetEmpty: boolean;
    function GetFileName: string;
    function GetItemIndex: integer;
    function GetLines: TStrings;
    function GetModified: boolean;
    function GetTabData(Index: integer): TTabData;
    procedure SetItemIndex(AValue: integer);
    procedure SetLines(AValue: TStrings);
    procedure SetModified(AValue: boolean);

  protected
    procedure UpdateTags;
    function GetNewName: string;
    procedure OnCloseTabClick(Sender: TObject);
    procedure OnChangeTab(Sender: TObject);

  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    // Работа с файлами
    function New: integer;
    function Open(FileName: string): integer;
    procedure Save(FileName: string);
    procedure Close(Index: integer);
    procedure Close;
    procedure CloseAll;
    procedure CloseOther;
    // Редактирование
    procedure Undo;
    procedure Redo;
    procedure Cut;
    procedure Copy;
    procedure Paste;
    procedure Delete;
    procedure SelectAll;
    // Настройки редактора
    // SetTheme, SetConfig, Set[Автозамена, Автонабор] и т.д.
    procedure MarkLine(ALine: integer; AColor: TColor);

  public
    property AvaibleData: boolean read GetAvaibleData;
    property IsEmpty: boolean read GetEmpty;
    property ActiveItem: TTabData read GetActiveItem;
    property ItemIndex: integer read GetItemIndex write SetItemIndex;
    property Items[Index: integer]: TTabData read GetTabData;
    property Count: integer read GetCount;
    property Lines: TStrings read GetLines write SetLines;
    property Modified: boolean read GetModified write SetModified;
    property FileName: string read GetFileName;

  published
    property OnCloseTab: TQuestionEvent read fOnCloseTab write fOnCloseTab;
    property OnCloseAllTab: TNotifyEvent read fOnCloseAllTab write fOnCloseAllTab;
    property OnCloseOtherTab: TNotifyEvent read fOnCloseOtherTab write fOnCloseOtherTab;
    property OnChangeActiveTab: TNotifyEvent read fOnChangeActiveTab write fOnChangeActiveTab;

  end;

function IndexOf(ColorLineList: TColorLineList; Line: integer): integer;

implementation

function IndexOf(ColorLineList: TColorLineList; Line: integer): integer;
begin
  Result := 0;
  while (Result < ColorLineList.Count) and (ColorLineList[Result].Line <> Line) do
    Inc(Result);
  if Result = ColorLineList.Count then
    Result := -1;
end;

{ TTabData }

procedure TTabData.OnSpecialLineColors(Sender: TObject; Line: integer; var Special: boolean; var FG, BG: TColor);
var
  LineIndex: integer;
begin
  LineIndex := IndexOf(SelectedLineList, line);
  if LineIndex <> -1 then
  begin
    Special := True;
    BG := SelectedLineList[LineIndex].Color;
    FG := FG; // No hint
  end;
end;

constructor TTabData.Create(ATag: integer; fPageControl: TPageControlEx);
  // Инициализация новой влкадки
var
  KeyStroke: TSynEditKeyStrokes;
  i: integer;
begin
  inherited Create;
  SelectedLineList := TColorLineList.Create;
  TabSheet := fPageControl.AddTabSheet;
  FileName := '';
  Memo := TSynMemo.Create(nil);
  Memo.OnSpecialLineColors := @OnSpecialLineColors;
  with Memo do
  begin
    Parent := TabSheet;
    Align := alClient;
  end;
  TabSheet.Tag := ATag;
  Application.ProcessMessages;

  KeyStroke := Memo.Keystrokes;
  for i := 0 to 104 do
    KeyStroke.Add;
  with KeyStroke.Items[0] do
  begin
    Command := ecUp;
    ShortCut := 38;
  end;
  with KeyStroke.Items[1] do
  begin
    Command := ecSelUp;
    ShortCut := 8230;
  end;
  with KeyStroke.Items[2] do
  begin
    Command := ecScrollUp;
    ShortCut := 16422;
  end;
  with KeyStroke.Items[3] do
  begin
    Command := ecDown;
    ShortCut := 40;
  end;
  with KeyStroke.Items[4] do
  begin
    Command := ecSelDown;
    ShortCut := 8232;
  end;
  with KeyStroke.Items[5] do
  begin
    Command := ecScrollDown;
    ShortCut := 16424;
  end;
  with KeyStroke.Items[6] do
  begin
    Command := ecLeft;
    ShortCut := 37;
  end;
  with KeyStroke.Items[7] do
  begin
    Command := ecSelLeft;
    ShortCut := 8229;
  end;
  with KeyStroke.Items[8] do
  begin
    Command := ecWordLeft;
    ShortCut := 16421;
  end;
  with KeyStroke.Items[9] do
  begin
    Command := ecSelWordLeft;
    ShortCut := 24613;
  end;
  with KeyStroke.Items[10] do
  begin
    Command := ecRight;
    ShortCut := 39;
  end;
  with KeyStroke.Items[11] do
  begin
    Command := ecSelRight;
    ShortCut := 8231;
  end;
  with KeyStroke.Items[12] do
  begin
    Command := ecWordRight;
    ShortCut := 16423;
  end;
  with KeyStroke.Items[13] do
  begin
    Command := ecSelWordRight;
    ShortCut := 24615;
  end;
  with KeyStroke.Items[14] do
  begin
    Command := ecPageDown;
    ShortCut := 34;
  end;
  with KeyStroke.Items[15] do
  begin
    Command := ecSelPageDown;
    ShortCut := 8226;
  end;
  with KeyStroke.Items[16] do
  begin
    Command := ecPageBottom;
    ShortCut := 16418;
  end;
  with KeyStroke.Items[17] do
  begin
    Command := ecSelPageBottom;
    ShortCut := 24610;
  end;
  with KeyStroke.Items[18] do
  begin
    Command := ecPageUp;
    ShortCut := 33;
  end;
  with KeyStroke.Items[19] do
  begin
    Command := ecSelPageUp;
    ShortCut := 8225;
  end;
  with KeyStroke.Items[20] do
  begin
    Command := ecPageTop;
    ShortCut := 16417;
  end;
  with KeyStroke.Items[21] do
  begin
    Command := ecSelPageTop;
    ShortCut := 24609;
  end;
  with KeyStroke.Items[22] do
  begin
    Command := ecLineStart;
    ShortCut := 36;
  end;
  with KeyStroke.Items[23] do
  begin
    Command := ecSelLineStart;
    ShortCut := 8228;
  end;
  with KeyStroke.Items[24] do
  begin
    Command := ecEditorTop;
    ShortCut := 16420;
  end;
  with KeyStroke.Items[25] do
  begin
    Command := ecSelEditorTop;
    ShortCut := 24612;
  end;
  with KeyStroke.Items[26] do
  begin
    Command := ecLineEnd;
    ShortCut := 35;
  end;
  with KeyStroke.Items[27] do
  begin
    Command := ecSelLineEnd;
    ShortCut := 8227;
  end;
  with KeyStroke.Items[28] do
  begin
    Command := ecEditorBottom;
    ShortCut := 16419;
  end;
  with KeyStroke.Items[29] do
  begin
    Command := ecSelEditorBottom;
    ShortCut := 24611;
  end;
  with KeyStroke.Items[30] do
  begin
    Command := ecToggleMode;
    ShortCut := 45;
  end;
  with KeyStroke.Items[31] do
  begin
    Command := ecCopy;
    ShortCut := 16429;
  end;
  with KeyStroke.Items[32] do
  begin
    Command := ecPaste;
    ShortCut := 8237;
  end;
  with KeyStroke.Items[33] do
  begin
    Command := ecDeleteChar;
    ShortCut := 46;
  end;
  with KeyStroke.Items[34] do
  begin
    Command := ecCut;
    ShortCut := 8238;
  end;
  with KeyStroke.Items[35] do
  begin
    Command := ecDeleteLastChar;
    ShortCut := 8;
  end;
  with KeyStroke.Items[36] do
  begin
    Command := ecDeleteLastChar;
    ShortCut := 8200;
  end;
  with KeyStroke.Items[37] do
  begin
    Command := ecDeleteLastWord;
    ShortCut := 16392;
  end;
  with KeyStroke.Items[38] do
  begin
    Command := ecUndo;
    ShortCut := 32776;
  end;
  with KeyStroke.Items[39] do
  begin
    Command := ecRedo;
    ShortCut := 40968;
  end;
  with KeyStroke.Items[40] do
  begin
    Command := ecLineBreak;
    ShortCut := 13;
  end;
  with KeyStroke.Items[41] do
  begin
    Command := ecSelectAll;
    ShortCut := 16449;
  end;
  with KeyStroke.Items[42] do
  begin
    Command := ecCopy;
    ShortCut := 16451;
  end;
  with KeyStroke.Items[43] do
  begin
    Command := ecBlockIndent;
    ShortCut := 24649;
  end;
  with KeyStroke.Items[44] do
  begin
    Command := ecLineBreak;
    ShortCut := 16461;
  end;
  with KeyStroke.Items[45] do
  begin
    Command := ecInsertLine;
    ShortCut := 16462;
  end;
  with KeyStroke.Items[46] do
  begin
    Command := ecDeleteWord;
    ShortCut := 16468;
  end;
  with KeyStroke.Items[47] do
  begin
    Command := ecBlockUnindent;
    ShortCut := 24661;
  end;
  with KeyStroke.Items[48] do
  begin
    Command := ecPaste;
    ShortCut := 16470;
  end;
  with KeyStroke.Items[49] do
  begin
    Command := ecCut;
    ShortCut := 16472;
  end;
  with KeyStroke.Items[50] do
  begin
    Command := ecDeleteLine;
    ShortCut := 16473;
  end;
  with KeyStroke.Items[51] do
  begin
    Command := ecDeleteEOL;
    ShortCut := 24665;
  end;
  with KeyStroke.Items[52] do
  begin
    Command := ecUndo;
    ShortCut := 16474;
  end;
  with KeyStroke.Items[53] do
  begin
    Command := ecRedo;
    ShortCut := 24666;
  end;
  with KeyStroke.Items[54] do
  begin
    Command := ecGotoMarker0;
    ShortCut := 16432;
  end;
  with KeyStroke.Items[55] do
  begin
    Command := ecGotoMarker1;
    ShortCut := 16433;
  end;
  with KeyStroke.Items[56] do
  begin
    Command := ecGotoMarker2;
    ShortCut := 16434;
  end;
  with KeyStroke.Items[57] do
  begin
    Command := ecGotoMarker3;
    ShortCut := 16435;
  end;
  with KeyStroke.Items[58] do
  begin
    Command := ecGotoMarker4;
    ShortCut := 16436;
  end;
  with KeyStroke.Items[59] do
  begin
    Command := ecGotoMarker5;
    ShortCut := 16437;
  end;
  with KeyStroke.Items[60] do
  begin
    Command := ecGotoMarker6;
    ShortCut := 16438;
  end;
  with KeyStroke.Items[61] do
  begin
    Command := ecGotoMarker7;
    ShortCut := 16439;
  end;
  with KeyStroke.Items[62] do
  begin
    Command := ecGotoMarker8;
    ShortCut := 16440;
  end;
  with KeyStroke.Items[63] do
  begin
    Command := ecGotoMarker9;
    ShortCut := 16441;
  end;
  with KeyStroke.Items[64] do
  begin
    Command := ecSetMarker0;
    ShortCut := 24624;
  end;
  with KeyStroke.Items[65] do
  begin
    Command := ecSetMarker1;
    ShortCut := 24625;
  end;
  with KeyStroke.Items[66] do
  begin
    Command := ecSetMarker2;
    ShortCut := 24626;
  end;
  with KeyStroke.Items[67] do
  begin
    Command := ecSetMarker3;
    ShortCut := 24627;
  end;
  with KeyStroke.Items[68] do
  begin
    Command := ecSetMarker4;
    ShortCut := 24628;
  end;
  with KeyStroke.Items[69] do
  begin
    Command := ecSetMarker5;
    ShortCut := 24629;
  end;
  with KeyStroke.Items[70] do
  begin
    Command := ecSetMarker6;
    ShortCut := 24630;
  end;
  with KeyStroke.Items[71] do
  begin
    Command := ecSetMarker7;
    ShortCut := 24631;
  end;
  with KeyStroke.Items[72] do
  begin
    Command := ecSetMarker8;
    ShortCut := 24632;
  end;
  with KeyStroke.Items[73] do
  begin
    Command := ecSetMarker9;
    ShortCut := 24633;
  end;
  with KeyStroke.Items[74] do
  begin
    Command := EcFoldLevel1;
    ShortCut := 41009;
  end;
  with KeyStroke.Items[75] do
  begin
    Command := EcFoldLevel2;
    ShortCut := 41010;
  end;
  with KeyStroke.Items[76] do
  begin
    Command := EcFoldLevel3;
    ShortCut := 41011;
  end;
  with KeyStroke.Items[77] do
  begin
    Command := EcFoldLevel4;
    ShortCut := 41012;
  end;
  with KeyStroke.Items[78] do
  begin
    Command := EcFoldLevel5;
    ShortCut := 41013;
  end;
  with KeyStroke.Items[79] do
  begin
    Command := EcFoldLevel6;
    ShortCut := 41014;
  end;
  with KeyStroke.Items[80] do
  begin
    Command := EcFoldLevel7;
    ShortCut := 41015;
  end;
  with KeyStroke.Items[81] do
  begin
    Command := EcFoldLevel8;
    ShortCut := 41016;
  end;
  with KeyStroke.Items[82] do
  begin
    Command := EcFoldLevel9;
    ShortCut := 41017;
  end;
  with KeyStroke.Items[83] do
  begin
    Command := EcFoldLevel0;
    ShortCut := 41008;
  end;
  with KeyStroke.Items[84] do
  begin
    Command := EcFoldCurrent;
    ShortCut := 41005;
  end;
  with KeyStroke.Items[85] do
  begin
    Command := EcUnFoldCurrent;
    ShortCut := 41003;
  end;
  with KeyStroke.Items[86] do
  begin
    Command := EcToggleMarkupWord;
    ShortCut := 32845;
  end;
  with KeyStroke.Items[87] do
  begin
    Command := ecNormalSelect;
    ShortCut := 24654;
  end;
  with KeyStroke.Items[88] do
  begin
    Command := ecColumnSelect;
    ShortCut := 24643;
  end;
  with KeyStroke.Items[89] do
  begin
    Command := ecLineSelect;
    ShortCut := 24652;
  end;
  with KeyStroke.Items[90] do
  begin
    Command := ecTab;
    ShortCut := 9;
  end;
  with KeyStroke.Items[91] do
  begin
    Command := ecShiftTab;
    ShortCut := 8201;
  end;
  with KeyStroke.Items[92] do
  begin
    Command := ecMatchBracket;
    ShortCut := 24642;
  end;
  with KeyStroke.Items[93] do
  begin
    Command := ecColSelUp;
    ShortCut := 40998;
  end;
  with KeyStroke.Items[94] do
  begin
    Command := ecColSelDown;
    ShortCut := 41000;
  end;
  with KeyStroke.Items[95] do
  begin
    Command := ecColSelLeft;
    ShortCut := 40997;
  end;
  with KeyStroke.Items[96] do
  begin
    Command := ecColSelRight;
    ShortCut := 40999;
  end;
  with KeyStroke.Items[97] do
  begin
    Command := ecColSelPageDown;
    ShortCut := 40994;
  end;
  with KeyStroke.Items[98] do
  begin
    Command := ecColSelPageBottom;
    ShortCut := 57378;
  end;
  with KeyStroke.Items[99] do
  begin
    Command := ecColSelPageUp;
    ShortCut := 40993;
  end;
  with KeyStroke.Items[100] do
  begin
    Command := ecColSelPageTop;
    ShortCut := 57377;
  end;
  with KeyStroke.Items[101] do
  begin
    Command := ecColSelLineStart;
    ShortCut := 40996;
  end;
  with KeyStroke.Items[102] do
  begin
    Command := ecColSelLineEnd;
    ShortCut := 40995;
  end;
  with KeyStroke.Items[103] do
  begin
    Command := ecColSelEditorTop;
    ShortCut := 57380;
  end;
  with KeyStroke.Items[104] do
  begin
    Command := ecColSelEditorBottom;
    ShortCut := 57379;
  end;
  with Memo do
  begin
    SelectedColor.FrameEdges := sfeAround;
    SelectedColor.BackPriority := 50;
    SelectedColor.ForePriority := 50;
    SelectedColor.FramePriority := 50;
    SelectedColor.BoldPriority := 50;
    SelectedColor.ItalicPriority := 50;
    SelectedColor.UnderlinePriority := 50;
    SelectedColor.StrikeOutPriority := 50;
    Font.Name := 'Droid Sans Mono';
    Font.Quality := fqCleartypeNatural;
    Font.Height := 12;
  end;
  Highlight := TSynFreePascalSyn.Create(Memo);
  with Highlight do
  begin
    Enabled := False;
    AsmAttri.FrameEdges := sfeAround;
    CommentAttri.FrameEdges := sfeAround;
    IDEDirectiveAttri.FrameEdges := sfeAround;
    IdentifierAttri.FrameEdges := sfeAround;
    KeyAttri.FrameEdges := sfeAround;
    NumberAttri.FrameEdges := sfeAround;
    SpaceAttri.FrameEdges := sfeAround;
    StringAttri.FrameEdges := sfeAround;
    SymbolAttri.FrameEdges := sfeAround;
    CaseLabelAttri.FrameEdges := sfeAround;
    DirectiveAttri.FrameEdges := sfeAround;
    CompilerMode := pcmObjFPC;
    NestedComments := True;
  end;
  { TODO : Нужен менеджер тем для SynMemo }
  if FileExists('highlight.dat') then
  begin
    Highlight.LoadFromFile('highlight.dat');
    Memo.Color := Highlight.IdentifierAttri.Background;
    Memo.Font.Color := Highlight.IdentifierAttri.Foreground;
    Memo.Gutter.Color := Memo.Color;
    Memo.Gutter.LineNumberPart().MarkupInfo.Background := Memo.Color;
  end;
  Memo.Highlighter := Highlight;
end;

destructor TTabData.Destroy;
  // Уничтожение вкладки
begin
  Memo.Free;
  TabSheet.Free;
  SelectedLineList.Free;
  inherited Destroy;
end;

{ TPageControlEx }

constructor TCustomPosMemo.Create(TheOwner: TComponent);
  // Создвние компонента
begin
  inherited Create(TheOwner);
  fPageControl := TPageControlEx.Create(nil);
  with fPageControl do
  begin
    Parent := self;
    Align := alClient;
    Options := [nboShowCloseButtons];
    OnCloseTabClicked := @OnCloseTabClick;
    OnChange := @OnChangeTab;
    TabPosition := tpBottom;
  end;
  fTabs := TTabList.Create;
  OnCloseTab := nil;
end;

destructor TCustomPosMemo.Destroy;
  // Уничтожение компонента
begin
  fPageControl.OnChange := nil;
  if AvaibleData then
    CloseAll;
  OnCloseTab := nil;
  fTabs.Free;
  fPageControl.Free;
  inherited Destroy;
end;

procedure TPageControlEx.DoCloseTabClicked(APage: TCustomPage);
// Активация вкладки перед закрытием
begin
  ActivePage := TTabSheet(APage);
  inherited DoCloseTabClicked(APage);
end;

function TCustomPosMemo.GetCount: integer;
  // Количество вкладок
begin
  Result := fTabs.Count;
end;

function TCustomPosMemo.GetEmpty: boolean;
  // True - если вкладок нет
begin
  Result := not AvaibleData;
end;

function TCustomPosMemo.GetFileName: string;
  // Имя файла
begin
  if AvaibleData then
    Result := ActiveItem.FileName
  else
    Result := '';
end;

function TCustomPosMemo.GetActiveItem: TTabData;
  // Активная вкладка
begin
  Result := Items[ItemIndex];
end;

function TCustomPosMemo.GetAvaibleData: boolean;
  // True - если есть вкладки
begin
  Result := fTabs.Count > 0;
end;

function TCustomPosMemo.GetItemIndex: integer;
  // Для метода ItemIndex
begin
  Result := fPageControl.ActivePage.Tag;
end;

function TCustomPosMemo.GetLines: TStrings;
  // Для метода Lines
begin
  Result := ActiveItem.Memo.Lines;
end;

function TCustomPosMemo.GetModified: boolean;
  // Для метода Modified
begin
  Result := ActiveItem.Memo.Modified;
end;

function TCustomPosMemo.GetTabData(Index: integer): TTabData;
  // Для метода Items
begin
  Result := fTabs[Index];
end;

procedure TCustomPosMemo.SetItemIndex(AValue: integer);
// Для метода ItemIndex
begin
  fPageControl.ActivePageIndex := AValue;
end;

procedure TCustomPosMemo.SetLines(AValue: TStrings);
// Для метода Lines
begin
  ActiveItem.Memo.Lines.Assign(AValue);
end;

procedure TCustomPosMemo.SetModified(AValue: boolean);
// Для метода Modified
begin
  ActiveItem.Memo.Modified := AValue;
end;

procedure TCustomPosMemo.UpdateTags;
// Обновляет тэги при удаление или вставке нового элемента
var
  i: integer;
begin
  if IsEmpty then
    Exit;
  for i := 0 to Count - 1 do
    Items[i].TabSheet.Tag := i;
end;

function TCustomPosMemo.GetNewName: string;
  // Получить имя для нового файла
var
  i, NumOfFile: integer;
  Undefined: boolean;
begin
  Result := '';
  NumOfFile := 1;
  repeat
    Undefined := True;
    Result := 'Новый ' + IntToStr(NumOfFile);
    for i := 0 to Count - 1 do
      if (Items[i].TabSheet.Caption = Result) then
        Undefined := False;
    Inc(NumOfFile, 1);
  until Undefined;
end;

procedure TCustomPosMemo.OnCloseTabClick(Sender: TObject);
// Щелчёк по значку закрытия таба и отправляем сообщение о закрытие
begin
  Close;
end;

procedure TCustomPosMemo.OnChangeTab(Sender: TObject);
// При открытии другой вкладки активируем Memo
begin
  if AvaibleData then
    ActiveItem.Memo.SetFocus;
  if OnChangeActiveTab <> nil then
    OnChangeActiveTab(self);
end;

function TCustomPosMemo.New: integer;
  // Добавляем новую вкладку
var
  TabData: TTabData;
begin
  TabData := TTabData.Create(Count, fPageControl);
  TabData.TabSheet.HandleNeeded;
  TabData.TabSheet.Caption := GetNewName;
  TabData.XHash := HashName(PChar(TabData.TabSheet.Caption));
  Result := fTabs.Add(TabData);
  fPageControl.ActivePage := TabData.TabSheet;
  Application.ProcessMessages;
  OnChangeTab(nil);
end;

function TCustomPosMemo.Open(FileName: string): integer;
  // Открытие файла
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if Items[i].FileName = FileName then
    begin
      fPageControl.ActivePage := Items[i].TabSheet;
      Result := i;
      Exit;
    end;
  Result := New;
  ActiveItem.Memo.Lines.LoadFromFile(FileName);
  ActiveItem.FileName := FileName;
  ActiveItem.TabSheet.Caption := ExtractFileName(FileName);
  ActiveItem.XHash := HashName(PChar(ActiveItem.TabSheet.Caption));
end;

procedure TCustomPosMemo.Save(FileName: string);
// Сохранение
begin
  ActiveItem.Memo.Lines.SaveToFile(FileName);
  ActiveItem.FileName := FileName;
  ActiveItem.TabSheet.Caption := ExtractFileName(FileName);
  ActiveItem.XHash := HashName(PChar(ActiveItem.TabSheet.Caption));
end;

procedure TCustomPosMemo.Close(Index: integer);
// Закрыть вкладку с индексом Index
begin
  try
    fTabs.Remove(Items[Index]);
    Application.ProcessMessages;
  finally
    UpdateTags;
  end;
end;

procedure TCustomPosMemo.Close; { TODO : Ошибка при рандомном закрытие вкладок }
// Закрыть активную вкладку
begin
  try
    if OnCloseTab <> nil then
      if OnCloseTab(self) = mrAbort then
        abort;
    Tag := fPageControl.ActivePage.Tag;
    fTabs.Remove(Items[Tag]);
    Application.ProcessMessages;
  finally
    UpdateTags;
  end;
end;

procedure TCustomPosMemo.CloseAll;
// Закрыть все вкладки
begin
  if OnCloseAllTab <> nil then
    OnCloseAllTab(self);
  repeat
    Close(Count - 1);
  until Count = 0;
end;

procedure TCustomPosMemo.CloseOther;
// Закрыть все вкладки, кроме активной
var
  SafeHash: longword;
  i: integer;
begin
  if OnCloseOtherTab <> nil then
    OnCloseOtherTab(self);
  SafeHash := GetActiveItem.XHash;
  i := Count - 1;
  while i <> 0 do
  begin
    Dec(i);
    if Items[i].XHash <> SafeHash then
      Close(i);
    Application.ProcessMessages;
  end;
end;

procedure TCustomPosMemo.Undo;
// Отмена последнего действия
begin
  ActiveItem.Memo.Undo;
end;

procedure TCustomPosMemo.Redo;
// Повторение последнего действия
begin
  ActiveItem.Memo.Redo;
end;

procedure TCustomPosMemo.Cut;
// Вырезать
begin
  ActiveItem.Memo.CutToClipboard;
end;

procedure TCustomPosMemo.Copy;
// Копировать
begin
  ActiveItem.Memo.CopyToClipboard;
end;

procedure TCustomPosMemo.Paste;
// Вставить
begin
  ActiveItem.Memo.PasteFromClipboard;
end;

procedure TCustomPosMemo.Delete;
// Удалить
begin
  ActiveItem.Memo.ClearSelection;
end;

procedure TCustomPosMemo.SelectAll;
// Выделить всё
begin
  ActiveItem.Memo.SelectAll;
end;

procedure TCustomPosMemo.MarkLine(ALine: integer; AColor: TColor);
// Выделить линию
var
  LineIndex: integer;
  ColorData: TLineColorData;
begin
  with ActiveItem do
  begin
    LineIndex := IndexOf(SelectedLineList, ALine);
    if LineIndex > -1 then
      SelectedLineList.Delete(LineIndex)
    else
    begin
      ColorData := TLineColorData.Create;
      ColorData.Line := ALine;
      ColorData.Color := AColor;
      SelectedLineList.Add(ColorData);
    end;
    Memo.Update;
  end;
end;

end.



