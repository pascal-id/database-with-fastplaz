unit model_controller;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, html_lib, fpcgi, fpjson, json_lib, HTTPDefs,
  warehouse_model,
  fastplaz_handler, database_lib, string_helpers, dateutils, datetime_helpers,
  array_helpers;

type
  TModelController = class(TMyCustomController)
  private
    warehouses: TWarehouseModel;
    function Tag_MainContent_Handler(const TagName: string;
      Params: TStringList): string;
    procedure BeforeRequestHandler(Sender: TObject; ARequest: TRequest);
  public
    constructor CreateNew(AOwner: TComponent; CreateMode: integer); override;
    destructor Destroy; override;

    procedure Get; override;
    procedure Post; override;
  end;

implementation

uses theme_controller, common;

constructor TModelController.CreateNew(AOwner: TComponent; CreateMode: integer);
begin
  inherited CreateNew(AOwner, CreateMode);
  warehouses := TWarehouseModel.Create();
  BeforeRequest := @BeforeRequestHandler;
end;

destructor TModelController.Destroy;
begin
  if Assigned(warehouses) then
    warehouses.Free;
  inherited Destroy;
end;

// Init First
procedure TModelController.BeforeRequestHandler(Sender: TObject; ARequest: TRequest);
begin
end;

// GET Method Handler
procedure TModelController.Get;
var
  whereAsArray: TStringArray;
begin
  DataBaseInit();

  warehouses.AddJoin('locations', 'id', 'warehouses.location_id', ['code','name country']);
  if not warehouses.Find(whereAsArray) then
  begin
    //
  end;


  Tags['maincontent'] := @Tag_MainContent_Handler; //<<-- tag maincontent handler
  ThemeUtil.Assign('$Title', 'DB Model');
  ThemeUtil.Layout := 'master'; // custom layout: master.html
  Response.Content := ThemeUtil.Render();
end;

// POST Method Handler
procedure TModelController.Post;
begin
  Response.Content := 'This is POST Method';
end;

function TModelController.Tag_MainContent_Handler(const TagName: string;
  Params: TStringList): string;
begin
  ThemeUtil.AssignVar['$Warehouses'] := @warehouses.Data;
  Result := ThemeUtil.RenderFromContent(nil, '', 'modules/model/main.html');
end;

end.


