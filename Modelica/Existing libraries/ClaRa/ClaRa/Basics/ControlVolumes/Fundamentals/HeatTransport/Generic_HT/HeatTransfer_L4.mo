within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT;
partial model HeatTransfer_L4 "Medium independent || HT Base Class"
  extends ClaRa.Basics.Icons.Alpha;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE_L4;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas_L4;
  outer ClaRa.Basics.Records.IComBase_L3 iCom;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv geo;
  outer parameter Boolean useHomotopy;

  parameter Modelica.SIunits.Area[iCom.N_cv]  A_heat=ones(iCom.N_cv) "Area of heat transfer"       annotation(Dialog(enable=false));

  Modelica.SIunits.Temperature T_mean[iCom.N_cv];
  ClaRa.Basics.Interfaces.HeatPort_a
                                   heat[iCom.N_cv] annotation (Placement(transformation(extent={
            {80,80},{100,100}}), iconTransformation(extent={{80,80},{100,100}})));
  annotation (Icon(graphics));
end HeatTransfer_L4;
