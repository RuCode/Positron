unit ReplaceText;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, SynMemo, LCLType,
  PositronUtils;

type

  { TFrameReplaceText }

  TFrameReplaceText = class(TFrame)
    ButtonReplace: TButton;
    ButtonReplaceAll: TButton;
    EditSearch: TEdit;
    EditReplace: TEdit;
    procedure ButtonReplaceAllClick(Sender: TObject);
    procedure ButtonReplaceClick(Sender: TObject);
    procedure EditSearchKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
  private
    { private declarations }
  public
    { public declarations }
    Memo: TSynMemo;
  end;

implementation

{$R *.lfm}

{ TFrameReplaceText }

procedure TFrameReplaceText.ButtonReplaceClick(Sender: TObject);
begin
  FindAndSelectText(Memo, EditSearch.Text);
  if Memo.SelAvail then
  begin
    Memo.SelText := EditReplace.Text;
    Memo.SelectLine();
  end;
end;

procedure TFrameReplaceText.ButtonReplaceAllClick(Sender: TObject);
var
  AvailText: boolean;
begin
  AvailText := True;
  while AvailText do
  begin
    FindAndSelectText(Memo, EditSearch.Text);
    if Memo.SelAvail then
    begin
      Memo.SelText := EditReplace.Text;
    end
    else
      AvailText := False;
  end;
end;

procedure TFrameReplaceText.EditSearchKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    ButtonReplaceClick(Sender)
  else
    inherited;
  if ssShift in Shift then;
  // no hint;
end;

end.

