within ClaRa.Basics.ControlVolumes.Fundamentals.Check;
model ValidationFluidDissipation2phFunction "Validation of kc_tubeBundleFilmCondensation_lam for HTC_NusseltShell2ph according to paper: LAMINAR FILMWISE CONDENSATION OF FLOWING VAPOUR ON A HORIZONTAL CYLINDER, Heat and Mass Transfer Vol. 15, pp235-246 ,Tetsu Fuji 1972 "
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

//extends ClaRa.Basics.Icons.Obsolete;
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  parameter Modelica.SIunits.Velocity U_inf = 71.3;
  parameter Modelica.SIunits.Temperature T_w = T_s - 1.01;
  parameter Modelica.SIunits.Temperature T_s = 22.07 + 273.15;
  parameter Modelica.SIunits.Length d_shell_o=0.092 "outer diameter of shell";
  parameter Modelica.SIunits.Length d_tube_o=0.014 "outer diameter of tube";

  parameter Real p =  TILMedia.VLEFluidFunctions.dewPressure_Txi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(), T_s);
  parameter Real h = TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_Txi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),T_s);

  Real eta_l = TILMedia.VLEFluidFunctions.dynamicViscosity_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),p, T_w,{0});
  Real cp_l =  TILMedia.VLEFluidFunctions.specificIsobaricHeatCapacity_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),p, T_w,{0});
  Real lambda_l = TILMedia.VLEFluidFunctions.thermalConductivity_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),p, T_w,{0});
  Real d_l = TILMedia.VLEFluidFunctions.density_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),p, T_w,{0});
  Real h_l = TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),p,T_w,{0});

  Real kc;
  Real Pr "Prandtl number of the film";
  Real Re "Reynolds number of flowing steam";
  Real Nu "Nusselt number";
  Real failureStatus "0== boundary conditions fulfilled | 1== failure >> check if still meaningfull results";

  TILMedia.VLEFluid_ph vleFluid(
    redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater vleFluidType,
    computeTransportProperties=true,
    computeVLEAdditionalProperties=true,
    computeVLETransportProperties=true,
    p=p,
    h=h)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

equation
(kc,Pr,Re,Nu,failureStatus)=FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam(
FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_IN_con(d=d_tube_o, A_front=Modelica.Constants.pi/4*d_shell_o^2),
FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_IN_var(cp_l=vleFluid.VLEAdditional.cp_l, lambda_l=vleFluid.VLETransp.lambda_l, rho_g=vleFluid.VLE.d_v, rho_l=vleFluid.VLE.d_l, eta_g=vleFluid.VLETransp.eta_v, eta_l=vleFluid.VLETransp.eta_l, T_s=T_s, dh_lg=vleFluid.VLE.h_v-vleFluid.VLE.h_l, m_flow=vleFluid.d*U_inf*Modelica.Constants.pi/4*d_shell_o^2, T_w=T_w));

  annotation (Diagram(graphics),
    experiment(
      StopTime=5000,
      NumberOfIntervals=1000,
      Tolerance=1e-006,
      Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equdistant=false));
end ValidationFluidDissipation2phFunction;
