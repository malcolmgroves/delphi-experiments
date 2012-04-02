unit Validation;

interface
uses
  Classes;

type
  BaseValidationAttribute = class(TCustomAttribute)
  protected
    FFailureMessage : string;
  public
    constructor Create(const FailureMessage : string);
    property FailureMessage : string read FFailureMessage;
  end;

  BaseIntegerValidationAttribute = class(BaseValidationAttribute)
  protected
    function Validate(Value : Integer) : boolean; virtual; abstract;
  end;

  BaseStringValidationAttribute = class(BaseValidationAttribute)
  protected
    function Validate(const Value : string) : boolean; virtual; abstract;
  end;

  MinimumIntegerAttribute = class(BaseIntegerValidationAttribute)
  private
    FMinimumValue: Integer;
  public
    constructor Create(MinimumValue : Integer; const FailureMessage : string);
    function Validate(Value : Integer) : boolean; override;
  end;

  MaximumIntegerAttribute = class(BaseIntegerValidationAttribute)
  private
    FMaximumValue: Integer;
  public
    constructor Create(MaximumValue : Integer; const FailureMessage : string);
    function Validate(Value : Integer) : boolean; override;
  end;

  NonEmptyStringAttribute = class(BaseStringValidationAttribute)
  public
    function Validate(const Value : string) : boolean; override;
  end;



  function Validate(Target : TObject; ErrorList : TStrings) : boolean;

implementation
uses
  RTTI, Sysutils;

function Validate(Target : TObject; ErrorList : TStrings) : boolean;
var
  ctx : TRttiContext;
  t : TRttiType;
  p : TRttiProperty;
  a : TCustomAttribute;
begin
  Result := True;

  if not Assigned(Target) then
    raise Exception.Create('Can''t validate nil object');

  if not Assigned(ErrorList) then
    raise Exception.Create('Can''t validate with a nil ErrorList');

  ctx := TRttiContext.Create.Create;
  try
    t := ctx.GetType(Target.ClassType);
    for p in t.GetProperties do
      for a in p.GetAttributes do
        if a is BaseIntegerValidationAttribute then
        begin
          if not BaseIntegerValidationAttribute(a).Validate(p.GetValue(Target).AsInteger) then
            ErrorList.Add(BaseValidationAttribute(a).FailureMessage);
        end
        else if a is BaseStringValidationAttribute then
        begin
          if not BaseStringValidationAttribute(a).Validate(p.GetValue(Target).AsString) then
            ErrorList.Add(BaseValidationAttribute(a).FailureMessage);
        end
  finally
    ctx.Free;
  end;
end;

{ MinimumIntegerAttribute }

constructor MinimumIntegerAttribute.Create(MinimumValue: Integer;
  const FailureMessage: string);
begin
  inherited Create(FailureMessage);
  FMinimumValue := MinimumValue;
end;

function MinimumIntegerAttribute.Validate(Value: Integer): boolean;
begin
  Result := Value >= FMinimumValue;
end;

{ MaximumIntegerAttribute }

constructor MaximumIntegerAttribute.Create(MaximumValue: Integer;
  const FailureMessage: string);
begin
  inherited Create(FailureMessage);
  FMaximumValue := MaximumValue;
end;

function MaximumIntegerAttribute.Validate(Value: Integer): boolean;
begin
  Result := Value <= FMaximumValue;
end;

{ BaseValidationAttribute }

constructor BaseValidationAttribute.Create(const FailureMessage: string);
begin
  inherited Create;
  FFailureMessage := FailureMessage;
end;

{ NonEmptyStringAttribute }

function NonEmptyStringAttribute.Validate(const Value: string): boolean;
begin
  Result := Length(Value) > 0;
end;

end.
