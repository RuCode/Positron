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
  Dialogs, ComCtrls;

type

	{ TFileTreeView }

  TFileTreeView = class(TTreeView)
  public
    procedure OpenFolder(APath: String);
  end;

implementation

{ TFileTreeView }

procedure TFileTreeView.OpenFolder(APath: String);
begin

end;

end.

