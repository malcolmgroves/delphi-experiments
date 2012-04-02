program ProjFilteredList;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Generics.Collections;

type
  TFilterFunction<T> = reference to function(Item : T) : boolean;
  TFilteredList<T> = class(TList<T>)
  private
    FFilterFunction: TFilterFunction<T>;
  public
  type
      TFilteredEnumerator = class(TEnumerator<T>)
      private
        FList: TFilteredList<T>;
        FIndex: Integer;
        FFilterFunction : TFilterFunction<T>;
        function GetCurrent: T;
      protected
        function DoGetCurrent: T; override;
        function DoMoveNext: Boolean; override;
        function IsLast : Boolean;
        function IsEOL : Boolean;
        function ShouldIncludeItem : Boolean;
      public
        constructor Create(AList: TFilteredList<T>;
                           AFilterFunction : TFilterFunction<T>);
        property Current: T read GetCurrent;
        function MoveNext: Boolean;
      end;
    function GetEnumerator: TFilteredEnumerator; reintroduce;
    procedure SetFilter(AFilterFunction : TFilterFunction<T>);
    procedure ClearFilter;
  end;

  TPerson = class
  public
    Age : Integer;
    Name : String;
    constructor Create(const AName : string; AAge : Integer);
    function ToString: string; override;
  end;


{ TFilteredList<T>.TFilteredEnumerator }

constructor TFilteredList<T>.TFilteredEnumerator.Create(AList: TFilteredList<T>; AFilterFunction : TFilterFunction<T>);
begin
  inherited Create;
  FList := AList;
  FIndex := -1;
  FFilterFunction := AFilterFunction;
end;

function TFilteredList<T>.TFilteredEnumerator.DoGetCurrent: T;
begin
  Result := GetCurrent;
end;

function TFilteredList<T>.TFilteredEnumerator.DoMoveNext: Boolean;
begin
  Result := MoveNext;
end;

function TFilteredList<T>.TFilteredEnumerator.GetCurrent: T;
begin
  Result := FList[FIndex];
end;

function TFilteredList<T>.TFilteredEnumerator.IsEOL: Boolean;
begin
  Result := Findex >= FList.Count;
end;

function TFilteredList<T>.TFilteredEnumerator.IsLast: Boolean;
begin
  Result := FIndex = FList.Count - 1;
end;

function TFilteredList<T>.TFilteredEnumerator.ShouldIncludeItem: Boolean;
begin
  Result := True;
  if Assigned(FFilterFunction) then
    Result := FFilterFunction(FList[FIndex]);
end;

function TFilteredList<T>.TFilteredEnumerator.MoveNext: Boolean;
begin
  if IsLast then
    Exit(False);

  repeat
    Inc(FIndex);
  until isEOL or ShouldIncludeItem;

  Result := not IsEol;
end;


{ TFilteredList<T> }

procedure TFilteredList<T>.ClearFilter;
begin
  FFilterFunction := nil;
end;

function TFilteredList<T>.GetEnumerator: TFilteredEnumerator;
begin
  Result := TFilteredEnumerator.Create(Self, FFilterFunction);
end;

procedure TFilteredList<T>.SetFilter(AFilterFunction: TFilterFunction<T>);
begin
  FFilterFunction := AFilterFunction;
end;

constructor TPerson.Create(const AName: string; AAge: Integer);
begin
  inherited Create;
  Age := AAge;
  Name := AName;
end;

{ TPerson }

function TPerson.ToString: string;
begin
  Result := 'Name = ' + Name + ', Age = ' + IntToStr(Age);
end;


var
  PersonList : TFilteredList<TPerson>;
  IntegerList : TFilteredList<Integer>;
  P : TPerson;
  I : Integer;
begin
  try
    writeln('--------------- Person List --------------- ');

    PersonList := TFilteredList<TPerson>.Create;
    try
      PersonList.Add(TPerson.Create('Fred Adult', 37));
      PersonList.Add(TPerson.Create('Julie Child', 15));
      PersonList.Add(TPerson.Create('Mary Adult', 18));
      PersonList.Add(TPerson.Create('James Child', 12));

      writeln('--------------- Filtered Person List --------------- ');
      PersonList.SetFilter(function(Item : TPerson): boolean
                           begin
                             Result := Item.Age >= 18;
                           end);

      for P in PersonList do
      begin
        writeln(P.ToString);
      end;

      writeln('--------------- Unfiltered Person List --------------- ');
      PersonList.ClearFilter;
      for P in PersonList do
      begin
        writeln(P.ToString);
      end;

    finally
      PersonList.Free;
    end;


    IntegerList := TFilteredList<Integer>.Create;
    try
      IntegerList.Add(1);
      IntegerList.Add(2);
      IntegerList.Add(3);
      IntegerList.Add(4);

      writeln('--------------- Filtered Integer List --------------- ');
      IntegerList.SetFilter(function(Item : Integer): boolean
                            begin
                               Result := Item >= 3;
                            end);

      for I in IntegerList do
      begin
        writeln(IntToStr(I));
      end;

      writeln('--------------- Unfiltered Integer List --------------- ');
      IntegerList.ClearFilter;

      for I in IntegerList do
      begin
        writeln(IntToStr(I));
      end;

    finally
      IntegerList.Free;
    end;

    Readln;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);

end;
end.
