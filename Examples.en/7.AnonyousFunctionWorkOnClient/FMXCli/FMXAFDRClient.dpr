﻿program FMXAFDRClient;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMXAFDRCliFrm in 'FMXAFDRCliFrm.pas' {FMXDRClientForm};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TFMXDRClientForm, FMXDRClientForm);
  Application.Run;
end.
