unit direct_controller;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, html_lib, fpcgi, fpjson, json_lib, HTTPDefs,
  db_model,
  fastplaz_handler, database_lib, string_helpers, dateutils, datetime_helpers;

type
  TDirectController = class(TMyCustomController)
  private
    warehouses: TDbModel;
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

constructor TDirectController.CreateNew(AOwner: TComponent; CreateMode: integer);
begin
  inherited CreateNew(AOwner, CreateMode);
  warehouses := TDbModel.Create();
  BeforeRequest := @BeforeRequestHandler;
end;

destructor TDirectController.Destroy;
begin
  if Assigned(warehouses) then
    warehouses.Free;
  inherited Destroy;
end;

// Init First
procedure TDirectController.BeforeRequestHandler(Sender: TObject; ARequest: TRequest);
begin
end;

// GET Method Handler
procedure TDirectController.Get;
begin
  DataBaseInit();

  // Direct Query ke table warehouses
  warehouses.SQL.Text := 'SELECT w.id, w.code, w.name, l.code, l.name country '
    + ' FROM warehouses w'
    + ' LEFT JOIN locations l ON location_id=l.id';
  if not warehouses.Open() then
  begin
    //
  end;

  Tags['maincontent'] := @Tag_MainContent_Handler; //render module content

  ThemeUtil.Assign('$Title', 'Direct Query');
  ThemeUtil.Layout := 'master'; // custom layout: master.html
  Response.Content := ThemeUtil.Render();
end;

// POST Method Handler
procedure TDirectController.Post;
begin
  Response.Content := 'This is POST Method';
end;

function TDirectController.Tag_MainContent_Handler(const TagName: string;
  Params: TStringList): string;
begin
  ThemeUtil.AssignVar['$Warehouses'] := @warehouses.Data;
  Result := ThemeUtil.RenderFromContent(nil, '', 'modules/direct/main.html');
end;



end.


