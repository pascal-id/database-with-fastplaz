unit app_routes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpjson, fastplaz_handler;

implementation

uses app_controller, direct_controller, model_controller, apiclient_controller;

initialization
  Route[ '/apiclient'] := TApiclientController;
  Route[ '/model'] := TModelController;
  Route[ '/direct'] := TDirectController;
  Route[ '/'] := TAppController; // Main Controller

end.

