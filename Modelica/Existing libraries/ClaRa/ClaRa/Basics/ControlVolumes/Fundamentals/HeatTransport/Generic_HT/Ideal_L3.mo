within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT;
model Ideal_L3 "All geo || L3 || Ideal HT"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                        //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright © 2013-2015, DYNCAP research team.                                   //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L3;
//   extends
//     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HeatTransfer_L2;
  //extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferGas;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeType_L3;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellType_L3;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;
  final parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha_ideal[iCom.N_cv]=
      ones(iCom.N_cv)*Modelica.Constants.pi*10^7;
  Modelica.SIunits.CoefficientOfHeatTransfer alpha[iCom.N_cv];
  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area"       annotation(dialog(enable=false,tab="Expert Setting"),choices(choice=1 "Lateral surface",
                                                                                   choice=2 "Inner heat transfer surface",
                                      choice=3 "Selection to be extended"));
equation
  heat.Q_flow = alpha .* geo.A_heat_CF[heatSurfaceAlloc] .* (heat.T - iCom.T);
  alpha=alpha_ideal;
//   heat.T=iCom.T;
end Ideal_L3;
