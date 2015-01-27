{ This file was automatically created by Typhon. Do not edit!
  This source is only used to compile and install the package.
 }

unit PosMemo;

interface

uses
  CustomPosMemo, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('PosMemo', @PosMemo.Register);
end;

initialization
  RegisterPackage('PosMemo', @Register);
end.
