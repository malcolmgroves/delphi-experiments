unit Generics.Factory;

interface
uses
  SysUtils, Generics.Collections;

type
  TFactoryMethodKeyAlreadyRegisteredException = class(Exception);
  TFactoryMethodKeyNotRegisteredException = class(Exception);

  TFactoryMethod<TBaseType> = reference to function : TBaseType;

  TFactory<TKey, TBaseType> = class
  private
    FFactoryMethods : TDictionary<TKey, TFactoryMethod<TBaseType>>;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    property Count : Integer read GetCount;
    procedure RegisterFactoryMethod(Key : TKey; FactoryMethod : TFactoryMethod<TBaseType>);
    procedure UnregisterFactoryMethod(Key : TKey);
    function IsRegistered (Key : TKey) : boolean;
    function GetInstance(Key : TKey) : TBaseType;
  end;

implementation

{ TFactory<TKey, TBaseType> }

constructor TFactory<TKey, TBaseType>.Create;
begin
  inherited Create;
  FFactoryMethods := TDictionary<TKey, TFactoryMethod<TBaseType>>.Create;
end;

destructor TFactory<TKey, TBaseType>.Destroy;
begin
  FFactoryMethods.Free;
  inherited;
end;

function TFactory<TKey, TBaseType>.GetCount: Integer;
begin
  if Assigned(FFactoryMethods) then
    Result := FFactoryMethods.Count;
end;

function TFactory<TKey, TBaseType>.GetInstance(Key: TKey): TBaseType;
var
  FactoryMethod : TFactoryMethod<TBaseType>;
begin
  if not IsRegistered(Key) then
    raise TFactoryMethodKeyNotRegisteredException.Create('');

  FactoryMethod := FFactoryMethods.Items[Key];
  if Assigned(FactoryMethod) then
    Result := FactoryMethod;
end;

function TFactory<TKey, TBaseType>.IsRegistered(Key: TKey): boolean;
begin
  Result := FFactoryMethods.ContainsKey(Key);
end;

procedure TFactory<TKey, TBaseType>.RegisterFactoryMethod(Key: TKey;
  FactoryMethod: TFactoryMethod<TBaseType>);
begin
  if IsRegistered(Key) then
    raise TFactoryMethodKeyAlreadyRegisteredException.Create('');

  FFactoryMethods.Add(Key, FactoryMethod);
end;

procedure TFactory<TKey, TBaseType>.UnRegisterFactoryMethod(Key: TKey);
begin
  if not IsRegistered(Key) then
    raise TFactoryMethodKeyNotRegisteredException.Create('');

  FFactoryMethods.Remove(Key);
end;

end.
