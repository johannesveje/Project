within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT;
model Constant_L2 "All Geo || L2 || HTC || Constant"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                        //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright � 2013-2015, DYNCAP research team.                                   //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L2;
//   extends
//     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HeatTransfer_L2;
//   extends
//     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.HeatTransferGas;
//   extends
//     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectiveHeatTransfer;
//   extends
//     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.RadiantHeatTransfer;
//   extends
//     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Special.SpecialHeatTransfer;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeType_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellType_L2;
  outer ClaRa.Basics.Records.IComBase_L2 iCom;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha_nom = 10 "Constant heat transfer coefficient"
                                          annotation(Dialog(group="Heat Transfer"));
  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area"        annotation(dialog(enable=false,tab="Expert Setting"),choices(choice=1 "Lateral surface",
                                                                                    choice=2 "Inner heat transfer surface",
                                       choice=3 "Selection to be extended"));
//   final parameter ClaRa.Basics.Units.Area A_heat=10 "Heat transfer surface";
  parameter Real CF_fouling=1 "Scaling factor accounting for the fouling of the wall"    annotation(Dialog(group="Heat Transfer"));

   parameter String temperatureDifference= "Logarithmic mean" "Temperature Difference"
                                             annotation(Dialog(group="Heat Transfer"), choices(choice="Arithmetic mean", choice="Logarithmic mean", choice="Inlet",  choice="Outlet"));

  Units.Temperature
                 Delta_T_wi "Temperature difference between wall and fluid inlet temperature";
  Units.Temperature
                 Delta_T_wo "Temperature difference between wall and fluid outlet temperature";
  Units.Temperature
                 Delta_T_mean;

  Units.Temperature
                 Delta_T_U;
  Units.Temperature
                 Delta_T_L;

  Modelica.SIunits.CoefficientOfHeatTransfer alpha;

  //Real test;
equation

  //test=TILMedia.GasObjectFunctions.specificEnthalpy_pTxi(iCom.p_in,iCom.T_in,iCom.xi_in,iCom.fluidPointer_in);

  Delta_T_wi = heat.T-iCom.T_in;
  Delta_T_wo = heat.T-iCom.T_out;
  Delta_T_U=  max(Delta_T_wi,Delta_T_wo);
  Delta_T_L= min(Delta_T_wi,Delta_T_wo);

   if temperatureDifference=="Logarithmic mean" then
     Delta_T_mean = noEvent(if floor(abs(Delta_T_wo)*1/eps)<=1 or floor(abs(Delta_T_wi)*1/eps)<=1 then 0
            elseif (heat.T<iCom.T_out and heat.T>iCom.T_in) or (heat.T>iCom.T_out and heat.T<iCom.T_in) then 0 elseif  floor(abs(Delta_T_wo-Delta_T_wi)*1/eps)<1 then Delta_T_wi
            else (Delta_T_U-Delta_T_L)/log(Delta_T_U/Delta_T_L));
   elseif temperatureDifference=="Arithmetic mean" then
     Delta_T_mean = heat.T - (iCom.T_in + iCom.T_out)/2;
   elseif temperatureDifference=="Inlet" then
     Delta_T_mean = heat.T - iCom.T_in;
   else
     Delta_T_mean = heat.T - iCom.T_out;
   end if;

  alpha=alpha_nom*CF_fouling;

  heat.Q_flow = alpha*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean;

end Constant_L2;
