unit api_routes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpjson, fastplaz_handler;

implementation

uses api_controller, warehouse_controller;

initialization
  Route[ '/warehouse'] := TWarehouseController;
  Route[ '/'] := TApiController; // Main Controller

end.

