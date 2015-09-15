within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT;
model NusseltShell2ph_L2 "Shell Geo || L2 || HTC || Nusselt (2ph)"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HeatTransfer_L2;
  //extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferVLE;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellType_L2;

  outer ClaRa.SimCenter simCenter;
  outer parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium;

  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;

  import ClaRa.Basics.Functions.Stepsmoother;
  import FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph;
  import FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_KC;
  import
    FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam;
  import
    FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_KC;

  // TILMedia VLEFluidFunctions
  import fluidFunction_cp = TILMedia.VLEFluidFunctions.specificIsobaricHeatCapacity_phxi;
  import fluidFunction_lambda = TILMedia.VLEFluidFunctions.thermalConductivity_phxi;
  import fluidFunction_eta = TILMedia.VLEFluidFunctions.dynamicViscosity_phxi;
  import fluidFunction_rho = TILMedia.VLEFluidFunctions.density_phxi;
  import fluidFunction_rho_bubble = TILMedia.VLEFluidFunctions.bubbleDensity_pxi;
  import fluidFunction_h_bubble = TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi;
  import fluidFunction_rho_dew = TILMedia.VLEFluidFunctions.dewDensity_pxi;
  import fluidFunction_h_dew = TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi;
  import fluidFunction_T_dew = TILMedia.VLEFluidFunctions.dewTemperature_pxi;
  import fluidFunction_x = TILMedia.VLEFluidFunctions.steamMassFraction_phxi;

  // TILMedia VLEFluidObjectFunctions
  import fluidObjectFunction_cp = TILMedia.VLEFluidObjectFunctions.specificIsobaricHeatCapacity_phxi;
  import fluidObjectFunction_lambda = TILMedia.VLEFluidObjectFunctions.thermalConductivity_phxi;
  import fluidObjectFunction_eta = TILMedia.VLEFluidObjectFunctions.dynamicViscosity_phxi;
  import fluidObjectFunction_x = TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi;
  import fluidObjectFunction_h_bubble = TILMedia.VLEFluidObjectFunctions.bubbleSpecificEnthalpy_pxi;
  import fluidObjectFunction_cp_bubble = TILMedia.VLEFluidObjectFunctions.bubbleSpecificIsobaricHeatCapacity_pxi;
  import fluidObjectFunction_rho_bubble = TILMedia.VLEFluidObjectFunctions.bubbleDensity_pxi;
  import fluidObjectFunction_h_dew = TILMedia.VLEFluidObjectFunctions.dewSpecificEnthalpy_pxi;
  import fluidObjectFunction_rho_dew = TILMedia.VLEFluidObjectFunctions.dewDensity_pxi;
  import fluidObjectFunction_T_dew = TILMedia.VLEFluidObjectFunctions.dewTemperature_pxi;
  import fluidObjectFunction_rho = TILMedia.VLEFluidObjectFunctions.density_phxi;

protected
   Modelica.SIunits.ReynoldsNumber Re_1ph "Reynolds number for one phase";
   Modelica.SIunits.NusseltNumber Nu_1ph "Nusselt number one tube row for one phase";
   Modelica.SIunits.PrandtlNumber Pr_1ph "Prandtl number of fluid for one phase";
  Real failureStatus_1ph "0== boundary conditions fulfilled | 1== failure >> check if still meaningfull results";
  Real alpha_1ph;

   Modelica.SIunits.ReynoldsNumber Re_2ph "Reynolds number for one phase";
   Modelica.SIunits.NusseltNumber Nu_2ph "Nusselt number one tube row for one phase";
   Modelica.SIunits.PrandtlNumber Pr_2ph "Prandtl number of fluid for one phase";
   Real failureStatus_2ph "0== boundary conditions fulfilled | 1== failure >> check if still meaningfull results";
Real alpha_2ph;

Real smoother;

  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha_nom = if inVar_1ph_nom.x >= (1-eps) or inVar_1ph_nom.x <=eps  or heating_nom==true then kc_tubeBundle_1ph_KC(    inCon_1ph,inVar_1ph_nom)
              else kc_tubeBundleFilmCondensation_lam(inCon_2ph,inVar_2ph_nom);
  constant Real Teps=1e-3;

public
 final parameter Real C = if  geo.staggeredAlignment then 1 else 0.8 "Correction factor for tube arrangement: offset pattern=1| aligned pattern=0.8"
                                                                                        annotation(Dialog(tab="General", group="Geometry"));
   parameter Boolean heating_nom= false "Ture, if nominal state implies heating, else fasle"
                                                          annotation(Dialog(group="Heat Transfer"));
  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area"        annotation(dialog(enable=false,tab="Expert Setting"),choices(choice=1 "Lateral surface",
                                                                                   choice=2 "Inner heat transfer surface",
                                      choice=3 "Selection to be extended"));
  Modelica.SIunits.CoefficientOfHeatTransfer alpha;

  FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_IN_var inVar_2ph(
    cp_l=fluidObjectFunction_cp_bubble(iCom.p_out,iCom.xi_out,iCom.fluidPointer_out),
    lambda_l=fluidObjectFunction_lambda(iCom.p_out,fluidObjectFunction_h_bubble(iCom.p_out,iCom.xi_out,iCom.fluidPointer_out),iCom.xi_out,iCom.fluidPointer_out),
    rho_g=fluidObjectFunction_rho_dew(iCom.p_out, iCom.xi_out, iCom.fluidPointer_out),
    rho_l=fluidObjectFunction_rho_bubble(iCom.p_out, iCom.xi_out, iCom.fluidPointer_out),
    eta_g=fluidObjectFunction_eta(iCom.p_out,fluidObjectFunction_h_dew( iCom.p_out,iCom.xi_out, iCom.fluidPointer_out), iCom.xi_out, iCom.fluidPointer_out),
    eta_l=fluidObjectFunction_eta( iCom.p_out, fluidObjectFunction_h_bubble( iCom.p_out, iCom.xi_out, iCom.fluidPointer_out), iCom.xi_out, iCom.fluidPointer_out),
    T_s=fluidObjectFunction_T_dew(iCom.p_out,iCom.xi_out,iCom.fluidPointer_out),
    T_w=min(inVar_2ph.T_s - 1e-5, heat.T),
    dh_lg=max(1e-3, fluidObjectFunction_h_dew(iCom.p_out,iCom.xi_out,iCom.fluidPointer_out) - fluidObjectFunction_h_bubble(iCom.p_out,iCom.xi_out,iCom.fluidPointer_out)),
    m_flow=max(1e-5, abs(iCom.m_flow_in))) "noEvent(max(Modelica.Constants.eps, max(iCom.m_flow_in, iCom.m_flow_out)))"
    annotation (Placement(transformation(extent={{-42,-100},{-22,-80}})));

  final parameter FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_IN_con inCon_2ph(
    A_front=geo.A_front,
    d=geo.diameter_t,
    C=if geo.N_rows > 1 then C else 1)
    annotation (Placement(transformation(extent={{-14,-100},{6,-80}})));
  final parameter FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_IN_con inCon_1ph(
    d_a=geo.diameter_t,
    staggeredAlignment=geo.staggeredAlignment,
    A_cross=geo.A_front,
    s_1=geo.Delta_z_ort,
    s_2=geo.Delta_z_par,
    n=geo.N_rows)
    annotation (Placement(transformation(extent={{34,-100},{54,-80}})));
  FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_IN_var inVar_1ph(
    cp_w=fluid_wall.cp,
    eta_w=if heat.T < (inVar_2ph.T_s + 1e-6) and heat.T > (inVar_2ph.T_s - 1e-6)
         then inVar_1ph_nom.eta_w else fluid_wall.transp.eta,
    lambda_w=if heat.T < (inVar_2ph.T_s + 1e-6) and heat.T > (inVar_2ph.T_s - 1e-6)
         then inVar_1ph_nom.lambda_w else fluid_wall.transp.lambda,
    cp=fluidObjectFunction_cp(iCom.p_out,iCom.h_out,iCom.xi_out,iCom.fluidPointer_out),
    eta=fluidObjectFunction_eta(iCom.p_out,  iCom.h_out,iCom.xi_out, iCom.fluidPointer_out),
    lambda=fluidObjectFunction_lambda(iCom.p_out, iCom.h_out,  iCom.xi_out,  iCom.fluidPointer_out),
    rho=fluidObjectFunction_rho(iCom.p_out, iCom.h_out, iCom.xi_out, iCom.fluidPointer_out),
    x=fluidObjectFunction_x(iCom.p_out, iCom.h_out, iCom.xi_out,iCom.fluidPointer_out),
    m_flow=max(1e-5, abs(iCom.m_flow_in))) "noEvent(max(Modelica.Constants.eps, max(iCom.m_flow_in, iCom.m_flow_out)))"
    annotation (Placement(transformation(extent={{62,-100},{82,-80}})));
  TILMedia.VLEFluid_pT fluid_wall(
    vleFluidType=medium,
    computeTransportProperties=true,
    computeVLETransportProperties=true,
    computeVLEAdditionalProperties=true)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  final parameter FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_IN_var inVar_2ph_nom(
      rho_g=TILMedia.VLEFluidFunctions.dewDensity_pxi(medium, iCom.p_nom),
      rho_l=TILMedia.VLEFluidFunctions.bubbleDensity_pxi(medium, iCom.p_nom),
      dh_lg=TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(medium, iCom.p_nom)-TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, iCom.p_nom),
      T_w=if heating_nom then inVar_2ph_nom.T_s + 5 else inVar_2ph_nom.T_s - 5,
      T_s=TILMedia.VLEFluidFunctions.dewTemperature_pxi(medium, iCom.p_nom),
      m_flow=noEvent(max(0.000001, abs(iCom.m_flow_nom))),
      cp_l=TILMedia.VLEFluidFunctions.specificIsobaricHeatCapacity_phxi(
              medium,
              iCom.p_nom,
              TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, iCom.p_nom)),
      lambda_l=TILMedia.VLEFluidFunctions.thermalConductivity_phxi(
              medium,
              iCom.p_nom,
              TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, iCom.p_nom)),
      eta_g=TILMedia.VLEFluidFunctions.dynamicViscosity_phxi(
              medium,
              iCom.p_nom,
              TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(medium, iCom.p_nom)),
      eta_l=TILMedia.VLEFluidFunctions.dynamicViscosity_phxi(
              medium,
              iCom.p_nom,
              TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, iCom.p_nom))) "The correction term for considering the heat flow direction is switched off for the nominal calculation"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

public
  final parameter FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_IN_var inVar_1ph_nom(
      cp=TILMedia.VLEFluidFunctions.specificIsobaricHeatCapacity_phxi(
          iCom.mediumModel,
          iCom.p_nom,
          iCom.h_nom,
          iCom.xi_nom),
      eta=TILMedia.VLEFluidFunctions.dynamicViscosity_phxi(
          iCom.mediumModel,
          iCom.p_nom,
          iCom.h_nom,
          iCom.xi_nom),
      lambda=TILMedia.VLEFluidFunctions.thermalConductivity_phxi(
          iCom.mediumModel,
          iCom.p_nom,
          iCom.h_nom,
          iCom.xi_nom),
      rho=TILMedia.VLEFluidFunctions.density_phxi(
          iCom.mediumModel,
          iCom.p_nom,
          iCom.h_nom,
          iCom.xi_nom),
      x=TILMedia.VLEFluidFunctions.steamMassFraction_phxi(
          iCom.mediumModel,
          iCom.p_nom,
          iCom.h_nom,
          iCom.xi_nom),
      cp_w=TILMedia.VLEFluidFunctions.specificIsobaricHeatCapacity_phxi(
          iCom.mediumModel,
          iCom.p_nom,
          iCom.h_nom,
          iCom.xi_nom),
      eta_w=TILMedia.VLEFluidFunctions.dynamicViscosity_phxi(
          iCom.mediumModel,
          iCom.p_nom,
          iCom.h_nom,
          iCom.xi_nom),
      lambda_w=TILMedia.VLEFluidFunctions.thermalConductivity_phxi(
          iCom.mediumModel,
          iCom.p_nom,
          iCom.h_nom,
          iCom.xi_nom),
      m_flow=noEvent(abs(iCom.m_flow_nom)))
    annotation (Placement(transformation(extent={{62,-70},{82,-50}})));
equation
  fluid_wall.T=heat.T;
  fluid_wall.p=iCom.p_bulk;

//  heat.Q_flow = alpha*iCom.A_heat* (2*ClaRa.Basics.Functions.Stepsmoother(1e-3, -1e-3, heat.T-T_mean)-1)*Delta_T_mean;
  heat.Q_flow = alpha*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean;

// defining the HTC for a shell area, either heated or cooled flow supporting laminar film condensation and one phase heat transfer. Evaporation is NOT supported

  smoother=Stepsmoother(-100*Teps, Teps, heat.T-TILMedia.VLEFluidFunctions.dewTemperature_pxi(medium, iCom.p_out, iCom.xi_out))*Stepsmoother(2*Teps, 1*Teps, iCom.T_in-TILMedia.VLEFluidFunctions.dewTemperature_pxi(medium, iCom.p_out, iCom.xi_out));

  alpha=if useHomotopy then homotopy(noEvent(smoother* kc_tubeBundleFilmCondensation_lam(inCon_2ph,inVar_2ph) + (1-smoother)*kc_tubeBundle_1ph(inCon_1ph,inVar_1ph)), alpha_nom)
                            else noEvent(smoother* kc_tubeBundleFilmCondensation_lam(inCon_2ph,inVar_2ph) + (1-smoother)*kc_tubeBundle_1ph(inCon_1ph,inVar_1ph));

//      alpha=if useHomotopy then homotopy(noEvent(if heat.T-iCom.T_sat <= eps and iCom.T_in-iCom.T_sat >= eps then FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam(inCon_2ph,inVar_2ph)
//                            else FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph(inCon_1ph,inVar_1ph)), alpha_nom)
//                              else noEvent(if heat.T-iCom.T_sat <= eps and iCom.T_in-iCom.T_sat >= eps then FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam(inCon_2ph,inVar_2ph)
//                                 else FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph(inCon_1ph,inVar_1ph));

 (alpha_2ph,Pr_2ph,Re_2ph,Nu_2ph,failureStatus_2ph)= kc_tubeBundleFilmCondensation_lam(inCon_2ph,inVar_2ph);
 (alpha_1ph,Pr_1ph,Re_1ph,Nu_1ph,failureStatus_1ph) = kc_tubeBundle_1ph(inCon_1ph,inVar_1ph);

  annotation (Icon(graphics));
end NusseltShell2ph_L2;
