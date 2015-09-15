within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL;
model QuadraticNominalPoint_L2 "All geo || Quadratic pressure loss || Nominal pressure difference"
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
  outer ClaRa.Basics.Records.IComBase_L2 iCom;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.ShellType_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.TubeType_L2;
  import
    ClaRa.Basics.ControlVolumes.Fundamentals.FlowModels.FlowModelStructure;

extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2;

 parameter SI.Pressure Delta_p_nom=1000 "Nominal ressure loss";
 parameter SI.Pressure Delta_p_smooth=100 "|Small Mass Flows|For pressure losses below this value the square root of the quadratic pressure loss model is regularised";

 final parameter FluidDissipation.Utilities.Types.PressureLossCoefficient zeta = 2*Delta_p_nom*geo.A_cross^2/iCom.m_flow_nom^2 "Pressure loss coefficient for total pipe";
                                                //density assumed to be equal to nominal density

equation
       iCom.m_flow_in = if useHomotopy then homotopy(geo.A_cross*sqrt(2/zeta)*ClaRa.Basics.Functions.ThermoRoot(Delta_p,Delta_p_smooth),
                              iCom.m_flow_nom/Delta_p_nom*Delta_p)
                        else geo.A_cross*sqrt(2/zeta)*ClaRa.Basics.Functions.ThermoRoot(Delta_p,Delta_p_smooth);

end QuadraticNominalPoint_L2;
