within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL;
model PressureLossCoeffcient_L2 "All geo || Quadratic pressure loss || constant pressure loss coefficient || density dependent "
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

 extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.PressureLoss_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.TubeType_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.ShellType_L2;
  import TILMedia.Internals.VLEFluidObjectFunctions.density_phxi;
  import ClaRa.Basics.Functions.Stepsmoother;
protected
  SI.DensityMassSpecific rho_in "Density at inlet";
  SI.DensityMassSpecific rho_out "Density at outlet";
public
  FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_IN_con inCon(
      A_cross=geo.A_cross, dp_smooth=Delta_p_smooth)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_IN_var inVar(
      zeta_TOT=zeta_TOT, rho= if useHomotopy then homotopy(Stepsmoother(10, -10, Delta_p)*rho_in + Stepsmoother(-10, 10, Delta_p)*rho_out, rho_in) else Stepsmoother(10, -10, Delta_p)*rho_in + Stepsmoother(-10, 10, Delta_p)*rho_out)
    annotation (Placement(transformation(extent={{-28,-80},{-8,-60}})));

  parameter SI.Pressure Delta_p_smooth=100 "Start linearisation for decreasing pressure loss";
  parameter FluidDissipation.Utilities.Types.PressureLossCoefficient zeta_TOT "Pressure loss coefficient";
equation
  rho_in = density_phxi(iCom.p_in, iCom.h_in, iCom.xi_in, iCom.fluidPointer_in);
  rho_out = density_phxi(iCom.p_out,iCom.h_out, iCom.xi_out, iCom.fluidPointer_out);
  iCom.m_flow_in =FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_MFLOW(inCon, inVar, Delta_p);

end PressureLossCoeffcient_L2;
