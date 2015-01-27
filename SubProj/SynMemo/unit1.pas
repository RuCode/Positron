unit Unit1;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, SynMemo, SynHighlighterPas, Forms, Controls,
		Graphics, Dialogs, Menus;

type

		{ TForm1 }

    TForm1 = class(TForm)
				MainMenu1: TMainMenu;
				MenuItem1: TMenuItem;
				SynFreePascalSyn: TSynFreePascalSyn;
				SynMemo1: TSynMemo;
				procedure MenuItem1Click(Sender: TObject);
    private
        { private declarations }
    public
        { public declarations }
    end;

var
    Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
    SynFreePascalSyn.SaveToFile('highlight.dat');
end;

end.

