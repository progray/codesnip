{
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/
 *
 * Copyright (C) 2006-2012, Peter Johnson (www.delphidabbler.com).
 *
 * $Rev$
 * $Date$
 *
 * Class that controls and provides information about Borland CodeGear and
 * Embarcadero "BDS" Win32 compilers.
}


unit Compilers.UBDS;


interface


uses
  // Project
  Compilers.UBorland, Compilers.UGlobals, IntfCommon;


type

  {
  TBDSCompiler:
    Class that controls and provides information about Borland Development
    System Delphi Win32 compilers.
  }
  TBDSCompiler = class(TBorlandCompiler,
    IClonable,            // can clone this object
    ICompiler,            // this is a compiler
    ICompilerAutoDetect   // can auto detect compiler exec file path
  )
  strict private
    function ProductVersion: Integer;
      {Delphi version number.
        @return Required major version number.
      }
  strict protected
    function GlyphResourceName: string; override;
      {Name of any resource containing a "glyph" bitmap for a compiler.
        @return Resource name or '' if the compiler has no glyph.
      }
    function InstallationRegKey: string; override;
      {Returns name of registry key where records compiler's installation path
      is recorded.
        @return Name of key.
      }
  protected
    { IClonable }
    function Clone: IInterface;
      {Create a new instance of the object that is an extact copy and return it.
        @return New object's IInterface interface.
      }
    { ICompiler method overrides }
    function GetName: string; override;
      {Provides the human readable name of the compiler.
        @return Name of the compiler.
      }
    function GetIDString: string; override;
      {Provides a non-localisable string that identifies the compiler.
        @return Compiler id string.
      }
  public
    constructor Create(const Id: TCompilerID);
      {Class constructor: creates object for a BDS compiler.
        @param Id [in] Identifies compiler version.
      }
  end;


implementation


uses
  // Delphi
  SysUtils,
  // Project
  UExceptions;


{ TBDSCompiler }

function TBDSCompiler.Clone: IInterface;
  {Create a new instance of the object that is an extact copy and return it.
    @return New object's IInterface interface.
  }
begin
  Result := TBDSCompiler.CreateCopy(Self);
end;

constructor TBDSCompiler.Create(const Id: TCompilerID);
  {Class constructor: creates object for a BDS compiler.
    @param Id [in] Identifies compiler version.
  }
begin
  Assert(Id in cBDSCompilers, ClassName + '.Create: Invalid Id');
  inherited Create(Id);
end;

function TBDSCompiler.GetIDString: string;
  {Provides a non-localisable string that identifies the compiler.
    @return Compiler id string.
  }
begin
  case GetID of
    ciD2005w32, ciD2006w32, ciD2009w32:
      Result := Format('D%dw32', [ProductVersion]);
    ciD2007, ciD2010:
      Result := Format('D%d', [ProductVersion]);
    ciDXE:
      Result := 'DXE';
    ciDXE2:
      Result := 'DXE2';
    else raise EBug.Create(ClassName + '.GetIDString: Invalid ID');
  end;
end;

function TBDSCompiler.GetName: string;
  {Provides the human readable name of the compiler.
    @return Name of the compiler.
  }
resourcestring
  sCompilerName = 'Delphi %d';  // template for name of compiler
  sDelphiXE = 'Delphi XE';      // name of Delphi XE compiler
  sDelphiXE2 = 'Delphi XE2';    // name of Delphi XE2 compiler
begin
  case GetID of
    ciDXE:
      Result := sDelphiXE;
    ciDXE2:
      Result := sDelphiXE2
    else
      Result := Format(sCompilerName, [ProductVersion]);
  end;
end;

function TBDSCompiler.GlyphResourceName: string;
  {Name of any resource containing a "glyph" bitmap for a compiler.
    @return Resource name or '' if the compiler has no glyph.
  }
begin
  case GetID of
    ciD2005w32, ciD2006w32, ciD2007, ciD2009w32: Result := 'BDS';
    ciD2010, ciDXE, ciDXE2: Result := 'EMBARCADERO';
    else raise EBug.Create(ClassName + '.GlyphResourceName: Invalid ID');
  end;
end;

function TBDSCompiler.InstallationRegKey: string;
  {Returns name of registry key where records compiler's installation path
  is recorded.
    @return Name of key.
  }
begin
  case GetID of
    ciD2005w32: Result := '\SOFTWARE\Borland\BDS\3.0';
    ciD2006w32: Result := '\SOFTWARE\Borland\BDS\4.0';
    ciD2007   : Result := '\SOFTWARE\Borland\BDS\5.0';
    ciD2009w32: Result := '\SOFTWARE\CodeGear\BDS\6.0';
    ciD2010   : Result := '\SOFTWARE\CodeGear\BDS\7.0';
    ciDXE     : Result := '\Software\Embarcadero\BDS\8.0';
    ciDXE2    : Result := '\Software\Embarcadero\BDS\9.0';
    else raise EBug.Create(ClassName + '.InstallationRegKey: Invalid ID');
  end;
end;

function TBDSCompiler.ProductVersion: Integer;
  {Delphi version number.
    @return Required major version number.
  }
begin
  case GetID of
    ciD2005w32: Result := 2005;
    ciD2006w32: Result := 2006;
    ciD2007:    Result := 2007;
    ciD2009w32: Result := 2009;
    ciD2010:    Result := 2010;
    ciDXE:      Result := 2011;
    ciDXE2:     Result := 2012;
    else raise EBug.Create(ClassName + '.ProductVersion: Invalid ID');
  end;
end;

end.

