unit warehouse_controller;
{
  [x] USAGE TEST
  curl 'http://inventory.carik.test/api.bin/warehouse/'
  curl 'http://inventory.carik.test/api.bin/warehouse/?q=raw'

}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcgi, fpjson, json_lib, HTTPDefs, fastplaz_handler,
  warehouse_model,
  database_lib, string_helpers, dateutils, datetime_helpers,
  json_helpers, array_helpers;

type
  TWarehouseController = class(TMyCustomController)
  private
    warehouses: TWarehouseModel;
  public
    constructor CreateNew(AOwner: TComponent; CreateMode: integer); override;
    destructor Destroy; override;

    procedure Get; override;
    procedure Post; override;
    procedure Options; override;
  end;

implementation

uses common;

constructor TWarehouseController.CreateNew(AOwner: TComponent; 
  CreateMode: integer);
begin
  inherited CreateNew(AOwner, CreateMode);
  warehouses := TWarehouseModel.Create();
end;

destructor TWarehouseController.Destroy;
begin
  warehouses.Free;
  inherited Destroy;
end;

// GET Method Handler
procedure TWarehouseController.Get;
var
  keyword: string;
  json: TJSONUtil;
  whereAsArray: TStringArray;
begin

  //TODO: Authentication

  DataBaseInit();

  keyword := _GET['q'];
  if keyword.IsNotEmpty then
    whereAsArray.Add('warehouses.name LIKE "%'+keyword+'%"');

  json := TJSONUtil.Create;
  json['code'] := 404;
  json['request/query'] := keyword;
  warehouses.AddJoin('locations', 'id', 'warehouses.location_id', ['code country_code','name country']);
  if warehouses.Find(whereAsArray) then
  begin
    json['code'] := 0;
    json['response/count'] := warehouses.RecordCount;
    json.ValueArray['response/data'] := warehouses.AsJsonArray(False);
  end;

  Response.Content := json.AsJSON;
  json.Free;
end;

// POST Method Handler
procedure TWarehouseController.Post;
begin
  Response.Content := '';
end;

// OPTIONS Method Handler
procedure TWarehouseController.Options;
begin
  Response.Code := 204;
  Response.Content := '';
end;


end.

