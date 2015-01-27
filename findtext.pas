unit FindText;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, SynMemo, Dialogs, LCLType,
  PositronUtils;

type

  { TFrameFindText }

  TFrameFindText = class(TFrame)
    Button: TButton;
    Edit: TEdit;
    procedure ButtonClick(Sender: TObject);
    procedure EditKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
  private
    { private declarations }
  public
    { public declarations }
    Memo: TSynMemo;
  end;

implementation

{$R *.lfm}

{ TFrameFindText }

procedure TFrameFindText.ButtonClick(Sender: TObject);
begin
  FindAndSelectText(Memo, Edit.Text);
end;

procedure TFrameFindText.EditKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    ButtonClick(Sender)
  else
    inherited;
end;

end.
