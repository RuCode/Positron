unit PositronUtils;

{$mode delphi}{$H+}

interface

uses
    Classes, SysUtils, SynMemo, Dialogs, Graphics;

function PosEx(const SubStr, S: string; Offset: cardinal = 1): integer;
procedure FindAndSelectText(Memo: TSynMemo; Text: String);

implementation

function PosEx(const SubStr, S: string; Offset: cardinal = 1): integer;
var
  I, X: integer;
  Len, LenSubStr: integer;
begin
  {$RangeChecks Off}
  if Offset = 1 then
    Result := Pos(SubStr, S)
  else
  begin
    I := Offset;
    LenSubStr := Length(SubStr);
    Len := Length(S) - LenSubStr + 1;
    while I <= Len do
    begin
      if S[I] = SubStr[1] then
      begin
        X := 1;
        while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
          Inc(X);
        if (X = LenSubStr) then
        begin
          Result := I;
          Exit;
        end;
      end;
      Inc(I);
    end;
    Result := 0;
  end;
  {$RangeChecks On}
end;

procedure FindAndSelectText(Memo: TSynMemo; Text: String);
var
  TextPos, MaxPos: integer;
  FindFlag: boolean;
begin
  FindFlag := False;
  if Assigned(Memo) then
  begin
    MaxPos := 0;
    TextPos := Memo.SelStart + 1;
    while (FindFlag = False) do
    begin
      Inc(MaxPos);
      if (MaxPos > (Length(Memo.Lines.Text) * 2)) then
      begin
        Beep;
        Break;
      end;
      TextPos := PosEx(AnsiLowerCase(Text), AnsiLowerCase(Memo.Text), TextPos);
      if TextPos = 0 then
        Continue;
      FindFlag := True;
      Memo.SelStart := TextPos;
      Memo.SelEnd := Memo.SelStart + Length(Text);
      break;
    end;
  end
  else
    ShowMessage('Не могу найти редактор текста');
end;

end.

