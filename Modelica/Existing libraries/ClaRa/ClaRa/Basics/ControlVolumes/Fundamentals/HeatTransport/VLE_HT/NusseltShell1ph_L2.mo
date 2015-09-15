within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT;
model NusseltShell1ph_L2 "Shell Geo || L2 || HTC || Nusselt (1ph)"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HeatTransfer_L2;
  //extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferVLE;
 //extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferGas;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellType_L2;

  outer ClaRa.SimCenter simCenter;
  outer parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;

   Modelica.SIunits.ReynoldsNumber Re "Reynolds number";
   Modelica.SIunits.NusseltNumber Nu "Nusselt number one tube row";
   Modelica.SIunits.PrandtlNumber Pr "Prandtl number of fluid";
   Real failureStatus;

protected
  Modelica.SIunits.CoefficientOfHeatTransfer alpha_nom = FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_KC(inCon_1ph,inVar_1ph_nom);
  constant Real Teps=1e-4;

public
  final parameter Real C = if  geo.staggeredAlignment then 1 else 0.8 "Correction factor for tube arrangement: offset pattern=1| aligned pattern=0.8"
                                                                                    annotation(Dialog(tab="General", group="Geometry"));
parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area"        annotation(dialog(enable=false,tab="Expert Setting"),choices(choice=1 "Lateral surface",
                                                                                   choice=2 "Inner heat transfer surface",
                                      choice=3 "Selection to be extended"));
  Modelica.SIunits.CoefficientOfHeatTransfer alpha;

  final parameter FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_IN_con inCon_1ph(
      staggeredAlignment=geo.staggeredAlignment,
      d_a=geo.diameter_t,
      A_cross=geo.A_front,
      s_1=geo.Delta_z_ort,
      s_2=geo.Delta_z_par,
      n=geo.N_rows)
    annotation (Placement(transformation(extent={{24,-96},{44,-76}})));
protected
  TILMedia.VLEFluid_pT fluid_wall(
    T=heat.T,
    p=iCom.p_bulk,
    vleFluidType=medium,
    computeTransportProperties=true,
    computeVLETransportProperties=true,
    computeVLEAdditionalProperties=true)
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
public
  final parameter FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_IN_var inVar_1ph_nom(
    cp_w=fluidFunction_cp(iCom.mediumModel,iCom.p_nom,iCom.h_nom,iCom.xi_nom),
    eta_w=fluidFunction_eta(iCom.mediumModel,iCom.p_nom,iCom.h_nom,iCom.xi_nom),
    lambda_w=fluidFunction_lambda(iCom.mediumModel,iCom.p_nom,iCom.h_nom,iCom.xi_nom),
    m_flow=noEvent(abs(iCom.m_flow_nom)),
    x=fluidFunction_x(iCom.mediumModel,iCom.p_nom,iCom.h_nom,iCom.xi_nom),
    cp=fluidFunction_cp(iCom.mediumModel,iCom.p_nom,iCom.h_nom,iCom.xi_nom),
    eta=fluidFunction_eta(iCom.mediumModel,iCom.p_nom,iCom.h_nom,iCom.xi_nom),
    lambda=fluidFunction_lambda(iCom.mediumModel,iCom.p_nom,iCom.h_nom,iCom.xi_nom),
    rho=fluidFunction_rho(iCom.mediumModel,iCom.p_nom,iCom.h_nom,iCom.xi_nom))
    annotation (Placement(transformation(extent={{56,-66},{76,-46}})));

   FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_IN_var inVar_1ph(
    cp=fluidObjectFunction_cp(iCom.p_out,iCom.h_out,iCom.xi_out,iCom.fluidPointer_out),
    lambda=fluidObjectFunction_lambda(iCom.p_out,iCom.h_out,iCom.xi_out,iCom.fluidPointer_out),
    rho=fluidObjectFunction_rho(iCom.p_out,iCom.h_out, iCom.xi_out,iCom.fluidPointer_out),
    x=fluidObjectFunction_x(iCom.p_out,iCom.h_out,iCom.xi_out,iCom.fluidPointer_out),
    eta=fluidObjectFunction_eta(iCom.p_out,iCom.h_out,iCom.xi_out,iCom.fluidPointer_out),
    cp_w=fluid_wall.cp,
    eta_w=if heat.T < (fluidObjectFunction_T_dew(iCom.p_out, iCom.xi_out, iCom.fluidPointer_out) + 1e-6) and heat.T > (fluidObjectFunction_T_dew(iCom.p_out, iCom.xi_out, iCom.fluidPointer_out) - 1e-6)
         then inVar_1ph_nom.eta_w else fluid_wall.transp.eta,
    lambda_w=if heat.T < (fluidObjectFunction_T_dew(iCom.p_out, iCom.xi_out, iCom.fluidPointer_out) + 1e-6) and heat.T > (fluidObjectFunction_T_dew(iCom.p_out, iCom.xi_out, iCom.fluidPointer_out) - 1e-6)
         then inVar_1ph_nom.lambda_w else fluid_wall.transp.lambda,
    m_flow=noEvent(max(Modelica.Constants.eps, abs(iCom.m_flow_in))))
     annotation (Placement(transformation(extent={{56,-96},{76,-76}})));

equation
//  heat.Q_flow = alpha*iCom.A_heat* (2*ClaRa.Basics.Functions.Stepsmoother(1e-3, -1e-3, heat.T-T_mean)-1)*Delta_T_mean;
  heat.Q_flow = alpha*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean;

// defining the HTC for a shell area, either heated or cooled ONE-PHASE flow. Evaporation and condensation are NOT supported

  alpha = if useHomotopy then homotopy(FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_KC(inCon_1ph,inVar_1ph), alpha_nom)
                     else noEvent(FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_KC(inCon_1ph,inVar_1ph));

  (,Pr,Re,Nu,failureStatus) =FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph(inCon_1ph,inVar_1ph);

  annotation (Icon(graphics),   Diagram(graphics));
end NusseltShell1ph_L2;
