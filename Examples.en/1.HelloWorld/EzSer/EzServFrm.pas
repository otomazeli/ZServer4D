﻿unit EzServFrm;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  ZJson,
  CommunicationFramework,
  CommunicationFramework_Server_ICS,
  CommunicationFramework_Server_Indy,
  CommunicationFramework_Server_CrossSocket,
  DoStatusIO, CoreClasses,
  DataFrameEngine, UnicodeMixedLib, MemoryStream64;

type
  {  Tpeerclientuserspecial is an instance that is automatically created on a per user basis  }
  {  Please pay attention to freeing memory when using  }
  {  Tpeerclientuserdefine is used for auth, DB and other services  }
  {  Tpeerclientuserspecial is used to provide exclusive instances for developers in case of conflict with auth and DB of advanced services  }
  TMySpecialDefine = class(TPeerClientUserSpecial)
  public
    tempStream: TMemoryStream64;
    constructor Create(AOwner: TPeerClient); override;
    destructor Destroy; override;
  end;

  TEZServerForm = class(TForm)
    Memo1: TMemo;
    StartServiceButton: TButton;
    Timer1: TTimer;
    procedure StartServiceButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    procedure DoStatusNear(AText: string; const ID: Integer);

    procedure cmd_helloWorld_Console(Sender: TPeerClient; InData: string);
    procedure cmd_helloWorld_Stream(Sender: TPeerClient; InData: TDataFrameEngine);
    procedure cmd_helloWorld_Stream_Result(Sender: TPeerClient; InData, OutData: TDataFrameEngine);

    procedure cmd_Json_Stream(Sender: TPeerClient; InData: TDataFrameEngine);

    procedure cmd_TestMiniStream(Sender: TPeerClient; InData: TDataFrameEngine);

    procedure cmd_Test128MBigStream(Sender: TPeerClient; InData: TCoreClassStream; BigStreamTotal, BigStreamCompleteSize: Int64);

    procedure cmd_TestCompleteBuffer(Sender: TPeerIO; InData: PByte; DataSize: NativeInt);
  public
    { Public declarations }
    server: TCommunicationFramework_Server_CrossSocket;
  end;

var
  EZServerForm: TEZServerForm;

implementation

{$R *.dfm}


procedure TEZServerForm.cmd_helloWorld_Console(Sender: TPeerClient; InData: string);
begin
  DoStatus('client: %s', [InData]);
end;

procedure TEZServerForm.cmd_helloWorld_Stream(Sender: TPeerClient; InData: TDataFrameEngine);
begin
  DoStatus('client: %s', [InData.Reader.ReadString]);
end;

procedure TEZServerForm.cmd_helloWorld_Stream_Result(Sender: TPeerClient; InData, OutData: TDataFrameEngine);
begin
  OutData.WriteString('result 654321');
end;

procedure TEZServerForm.cmd_Json_Stream(Sender: TPeerClient; InData: TDataFrameEngine);
var
  js: TZ_JsonObject;
  ns: TStringList;
begin
  js := TZ_JsonObject.Create;
  ns := TStringList.Create;
  InData.Reader.ReadJson(js);
  js.SaveToLines(ns);
  DoStatus(ns);
  disposeObject(ns);
  disposeObject(js);
end;

procedure TEZServerForm.cmd_TestMiniStream(Sender: TPeerClient; InData: TDataFrameEngine);
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  InData.Reader.ReadStream(ms);

  DoStatus(umlMD5Char(ms.Memory, ms.Size).Text);

  disposeObject(ms);
end;

procedure TEZServerForm.cmd_Test128MBigStream(Sender: TPeerClient; InData: TCoreClassStream; BigStreamTotal, BigStreamCompleteSize: Int64);
var
  tempStream: TMemoryStream64;
begin
  tempStream := TMySpecialDefine(Sender.UserSpecial).tempStream;
  tempStream.CopyFrom(InData, InData.Size);
  DoStatus('%d/%d', [BigStreamTotal, BigStreamCompleteSize]);

  // bigstream complete
  if tempStream.Size = BigStreamTotal then
    begin
      Sender.Print('bigsteram finish');
      Sender.Print('bigsteram md5:' + umlMD5Char(tempStream.Memory, tempStream.Size).Text);
      tempStream.Clear;
    end;
end;

procedure TEZServerForm.cmd_TestCompleteBuffer(Sender: TPeerIO; InData: PByte; DataSize: NativeInt);
begin
  Sender.Print('Complete buffer md5: %s', [umlMD5String(InData, DataSize).Text]);
end;

procedure TEZServerForm.DoStatusNear(AText: string; const ID: Integer);
begin
  Memo1.Lines.Add(AText);
end;

procedure TEZServerForm.FormCreate(Sender: TObject);
begin
  AddDoStatusHook(self, DoStatusNear);
  server := TCommunicationFramework_Server_CrossSocket.Create;
  server.PeerClientUserSpecialClass := TMySpecialDefine;
  server.TimeOutIDLE := 15 * 1000;

  {  Change the maximum completebuffer. It is only used for testing. The server runs normally. It is generally 4m here  }
  server.MaxCompleteBufferSize := 128 * 1024 * 1024;

  server.RegisterDirectConsole('helloWorld_Console').OnExecute := cmd_helloWorld_Console;
  server.RegisterDirectStream('helloWorld_Stream').OnExecute := cmd_helloWorld_Stream;
  server.RegisterStream('helloWorld_Stream_Result').OnExecute := cmd_helloWorld_Stream_Result;

  server.RegisterDirectStream('Json_Stream').OnExecute := cmd_Json_Stream;

  server.RegisterDirectStream('TestMiniStream').OnExecute := cmd_TestMiniStream;
  server.RegisterBigStream('Test128MBigStream').OnExecute := cmd_Test128MBigStream;

  {  Register the completebuffer directive  }
  server.RegisterCompleteBuffer('TestCompleteBuffer').OnExecute := cmd_TestCompleteBuffer;
end;

procedure TEZServerForm.FormDestroy(Sender: TObject);
begin
  disposeObject(server);
  DeleteDoStatusHook(self);
end;

procedure TEZServerForm.StartServiceButtonClick(Sender: TObject);
begin
  {  Based on the official crosssocket document, if the binding string is empty, bind IPv6 + IPv4  }
  if server.StartService('', 9818) then
      DoStatus('start service success')
  else
      DoStatus('start service failed!')
end;

procedure TEZServerForm.Timer1Timer(Sender: TObject);
begin
  server.Progress;
end;

{ TMySpecialDefine }

constructor TMySpecialDefine.Create(AOwner: TPeerClient);
begin
  inherited Create(AOwner);
  tempStream := TMemoryStream64.Create;
end;

destructor TMySpecialDefine.Destroy;
begin
  DoStatus('%s disconnect', [Owner.GetPeerIP]);
  disposeObject(tempStream);
  inherited Destroy;
end;

end.

