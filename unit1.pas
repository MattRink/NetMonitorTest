unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, DaemonApp, Sniffer;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SnifferHandler(ASecondsSinceStart : double; ALength : integer);
  private
    { private declarations }
    procedure Start;
    procedure Stop;
  public
    { public declarations }
    procedure Log(AMessage : String; ASecondsSinceStart : double);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Log(AMessage : String; ASecondsSinceStart : double);
begin
  Memo1.Append(Format('%.3f: %s', [ASecondsSinceStart, AMessage]));
end;

procedure TForm1.SnifferHandler(ASecondsSinceStart : double; ALength : integer);
begin
  Form1.Log('--------------------------------------------------------------------------', ASecondsSinceStart);
  Form1.Log(Format('Packet recieved - Length: %d bytes', [ALength]), ASecondsSinceStart);
end;

procedure TForm1.Start;
begin
  TheSniffer.Start;
  Log('Starting sniffing on: ' + StrPas(TheSniffer.PcapDevice), 0.0);
end;

procedure TForm1.Stop;
begin
  Log('Stopping sniffing on: ' + StrPas(TheSniffer.PcapDevice), TheSniffer.SecondsSinceStart);
  TheSniffer.Stop;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Start;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Stop;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Stop;
  CloseAction := caFree;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TheSniffer.Handler := @SnifferHandler;
  TheSniffer.Logger := @Log;
  TheSniffer.Setup;
end;

end.

