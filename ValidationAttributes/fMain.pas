unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Validation;

type
  TPerson = class
  private
    FName: String;
    FAge: Integer;
  public
    [NonEmptyString('Must provide a Name')]
    property Name : String read FName write FName;
    [MinimumInteger(18, 'Must be at least 18 years old')]
    [MaximumInteger(65, 'Must be no older than 65 years')]
    property Age : Integer read FAge write FAge;
  end;

  TForm7 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    ListBox1: TListBox;
    SpinEdit1: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FPerson: TPerson;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

{$R *.dfm}

procedure TForm7.Button1Click(Sender: TObject);
begin
  ListBox1.Items.Clear;

  FPerson.Name := Edit1.Text;
  FPerson.Age := SpinEdit1.Value;
  Validate(FPerson, ListBox1.Items);
end;

procedure TForm7.FormCreate(Sender: TObject);
begin
  FPerson := TPerson.Create;
end;

procedure TForm7.FormDestroy(Sender: TObject);
begin
  FPerson.Free;
end;

end.
