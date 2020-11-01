unit api_controller;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcgi, fpjson, json_lib, HTTPDefs, fastplaz_handler, 
    database_lib, string_helpers, dateutils, datetime_helpers;

type
  TApiController = class(TMyCustomController)
  private
    procedure BeforeRequestHandler(Sender: TObject; ARequest: TRequest);
  public
    constructor CreateNew(AOwner: TComponent; CreateMode: integer); override;
    destructor Destroy; override;

    procedure Get; override;
    procedure Post; override;
  end;

implementation

uses common;

constructor TApiController.CreateNew(AOwner: TComponent; CreateMode: integer);
begin
  inherited CreateNew(AOwner, CreateMode);
  BeforeRequest := @BeforeRequestHandler;
end;

destructor TApiController.Destroy;
begin
  inherited Destroy;
end;

// Init First
procedure TApiController.BeforeRequestHandler(Sender: TObject; 
  ARequest: TRequest);
begin
  Response.ContentType := 'application/json';
end;

// GET Method Handler
procedure TApiController.Get;
begin
  //---
  Response.Content := '{}';
end;

// POST Method Handler
// CURL example:
//   curl -X POST -H "Authorization: Basic dW5hbWU6cGFzc3dvcmQ=" "yourtargeturl"
procedure TApiController.Post;
var
  json : TJSONUtil;
  authstring : string;
begin
  authstring := Header['Authorization'];
  if authstring <> 'YourAuthKey' then
  begin
    //
  end;
  json := TJSONUtil.Create;

  json['code'] := Int16(0);
  json['data'] := 'yourdatahere';
  json['path01/path02/var01'] := 'value01';
  json['path01/path02/var02'] := 'value02';
  CustomHeader[ 'ThisIsCustomHeader'] := 'datacustomheader';

  //---
  Response.Content := json.AsJSON;
  json.Free;
end;



end.

