{

  Управление проектом, чтение, запись *.lpi файлов

}

unit ProjectManagers;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl;

type
  // Описание юнитов
  TUnitFile = class(TObject)
    FileName: string;
    IsPartOfProject: boolean;
    ComponentName: string;
    HasResources: boolean;
    ResourceBaseClass: string;
    UnitFileName: string;
  end;

  TUnitsFilesList = specialize TFPGObjectList<TUnitFile>;

  // Режимы сборки
  TBuildMode = specialize TFPGMap<string, boolean>;
  TBuildModesList = specialize TFPGObjectList<TBuildMode>;

  { TProjectManager }

  TProjectManager = class(TObject)
  private
    fAvaibleProject: Boolean;
    fBuildModes: TBuildModesList;
    fCompilerVersion: integer;
    fEnableI18N: boolean;
    fExceptionList: TStringList;
    fFormatVersion: integer;
    fIconIndex: integer;
    fIncludeAssertionCode: boolean;
    fIncludeFiles: TStringList;
    fIOChecks: boolean;
    fMainUnitIndex: integer;
    fOtherUnitFiles: TStringList;
    fOverflowChecks: boolean;
    fParsingStyle: integer;
    fProductVersion: string;
    fProjectDir: string;
    fProjectTitle: string;
    fRangeChecks: boolean;
    fRequiredPackages: TStringList;
    fResourceType: string;
    fSessionStorage: string;
    fStackChecks: boolean;
    fTargetFileName: string;
    fUnitOutputDirectory: string;
    fUnitsList: TUnitsFilesList;
    fUseXPManifest: boolean;
    fVersion: string;
    fWin32GraphicApplication: boolean;
  public
    constructor Create;
    destructor Destroy; override;
  public
    property AvaibleProject: Boolean read fAvaibleProject;
    property ProjectDir: string read fProjectDir;
    // General
    property SessionStorage: string read fSessionStorage;
    property MainUnitIndex: integer read fMainUnitIndex;
    property ProjectTitle: string read fProjectTitle;
    property ResourceType: string read fResourceType;
    property UseXPManifest: boolean read fUseXPManifest;
    property IconIndex: integer read fIconIndex;
    property EnableI18N: boolean read fEnableI18N;
    property ProductVersion: string read fProductVersion;
    property FormatVersion: integer read fFormatVersion;
    property Version: string read fVersion;
    property BuildModes: TBuildModesList read fBuildModes;
    property RequiredPackages: TStringList read fRequiredPackages;
    property Units: TUnitsFilesList read fUnitsList;
    // Compiler options
    property TargetFileName: string read fTargetFileName;
    property CompilerVersion: integer read fCompilerVersion;
    property IncludeFiles: TStringList read fIncludeFiles;
    property OtherUnitFiles: TStringList read fOtherUnitFiles;
    property UnitOutputDirectory: string read fUnitOutputDirectory;
    property ParsingStyle: integer read fParsingStyle;
    property IncludeAssertionCode: boolean read fIncludeAssertionCode;
    // Code generation
    property IOChecks: boolean read fIOChecks;
    property RangeChecks: boolean read fRangeChecks;
    property OverflowChecks: boolean read fOverflowChecks;
    property StackChecks: boolean read fStackChecks;
    // Linking
    property Win32GraphicApplication: boolean read fWin32GraphicApplication;
    // Debugging
    property ExceptionList: TStringList read fExceptionList;
  end;

var
  ProjectManager: TProjectManager;

implementation

{ TProjectManager }

constructor TProjectManager.Create;
begin
  inherited Create;
  fBuildModes := TBuildModesList.Create(True);
  fRequiredPackages := TStringList.Create;
  fUnitsList := TUnitsFilesList.Create(True);
  fIncludeFiles := TStringList.Create;
  fOtherUnitFiles := TStringList.Create;
  fExceptionList := TStringList.Create;
end;

destructor TProjectManager.Destroy;
begin
  FreeAndNil(fBuildModes);
  FreeAndNil(fRequiredPackages);
  FreeAndNil(fUnitsList);
  FreeAndNil(fIncludeFiles);
  FreeAndNil(fOtherUnitFiles);
  FreeAndNil(fExceptionList);
  inherited Destroy;
end;

// Менеджер проекта будем использовать глобально т.к. у нас один проект

initialization
  ProjectManager:= TProjectManager.Create;

finalization
  FreeAndNil(ProjectManager);

end.

