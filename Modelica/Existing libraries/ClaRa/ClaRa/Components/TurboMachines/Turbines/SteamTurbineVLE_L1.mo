within ClaRa.Components.TurboMachines.Turbines;
model SteamTurbineVLE_L1 "A steam turbine model based on STODOLA's law including a term for entropy production"
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

   extends ClaRa.Components.TurboMachines.Turbines.SteamTurbine_base(inlet(
                                                                     m_flow(      start=m_flow_nom)));
  import TILMedia.VLEFluidObjectFunctions.specificEnthalpy_psxi;
  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut=inlet.m_flow*(fluidIn.h - fluidOut.h),
    powerAux=inlet.m_flow*(fluidIn.h - fluidOut.h) + P_t) if                                                                                                     contributeToCycleSummary;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");

  parameter Boolean showExpertSummary = simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation" annotation(Dialog(tab="Summary and Visualisation"));

//_______________________ Nominal values ___________________________________
  parameter Modelica.SIunits.Pressure p_nom= 300e5 "Nominal inlet perssure" annotation(Dialog(group="Nominal values"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nom=419 "Nominal mass flow rate"                                                annotation(Dialog(group="Nominal values"));
  parameter Real Pi=5000/300e5 "Nominal pressure ratio" annotation(Dialog(group="Nominal values"));
  parameter Modelica.SIunits.Density rho_nom=10 "Nominal inlet density" annotation(Dialog(group="Nominal values"));

//_______________________ Start values ___________________________________
  parameter Modelica.SIunits.Pressure p_in_0=p_nom "Start value for inlet pressure" annotation(Dialog(group="Initialisation"));
  parameter Modelica.SIunits.Pressure p_out_0=p_nom*Pi "Start value for outlet pressure"   annotation(Dialog(group="Initialisation"));

//_______________________ Efficiency _____________________________
  parameter Real eta_mech=0.98 "Mechanical efficiency" annotation(Dialog(group="Nominal values"));

  parameter Boolean allowFlowReversal = simCenter.steamCycleAllowFlowReversal "True to allow flow reversal during initialisation"
                                                        annotation(Evaluate=true, Dialog(group="Initialisation"));

public
  parameter Real CL_eta_mflow[:,2]=[0.0, 0.94; 1, 0.94] "Characteristic line eta = f(m_flow/m_flow_nom)"
                                                     annotation(Dialog(group="Part Load Definition"));

  final parameter Real Kt = (m_flow_nom*sqrt(p_nom))/(sqrt(p_nom^2-p_nom^2*Pi^2)*sqrt(rho_nom)) "Kt coefficient of Stodola's law";

//______________________ Variables _____________________________________
  Modelica.SIunits.SpecificEnthalpy h_is "Isentropic outlet enthalpy";
  Modelica.SIunits.Power P_t "Turbine hydraulic power";
  Modelica.SIunits.Pressure p_in(start=p_in_0);
  Modelica.SIunits.Pressure p_out(start=p_out_0);
  Real eta_is "Isentropic efficiency";
  Modelica.SIunits.EntropyFlowRate S_irr "Entropy production rate";

record Outline
  extends ClaRa.Basics.Icons.RecordIcon;
  Basics.Units.PressureDifference Delta_p;
  ClaRa.Basics.Units.Power P_mech "Mechanical power of steam turbine" annotation(Dialog);
  Real eta_isen "Isentropic efficiency" annotation(Dialog);
  Real eta_mech "Mechanic efficiency" annotation(Dialog);
  ClaRa.Basics.Units.EnthalpyMassSpecific h_isen "Isentropic steam enthalpy at turbine outlet"  annotation(Dialog);
  ClaRa.Basics.Units.Pressure p_nom if showExpertSummary "Nominal inlet perssure" annotation(Dialog);
  Real Pi if showExpertSummary "Nominal pressure ratio" annotation(Dialog);
  ClaRa.Basics.Units.MassFlowRate m_flow_nom if showExpertSummary "Nominal mass flow rate"   annotation(Dialog);
  ClaRa.Basics.Units.DensityMassSpecific rho_nom if showExpertSummary "Nominal inlet density"
                                                                                             annotation(Dialog);
  parameter Boolean showExpertSummary;
end Outline;

record Summary
  extends ClaRa.Basics.Icons.RecordIcon;
  Outline outline;
  ClaRa.Basics.Records.FlangeVLE           inlet;
  ClaRa.Basics.Records.FlangeVLE           outlet;

end Summary;

protected
  TILMedia.VLEFluidObjectFunctions.VLEFluidPointer ptr_iso=
      TILMedia.VLEFluidObjectFunctions.VLEFluidPointer(
      medium.concatVLEFluidName,
      0,
      medium.mixingRatio_propertyCalculation[1:end - 1]/sum(medium.mixingRatio_propertyCalculation),
      medium.nc_propertyCalculation,
      medium.nc,
      TILMedia.Internals.redirectModelicaFormatMessage()) "Pointer to external medium memory for isentropic expansion state";

  TILMedia.VLEFluid_ph fluidOut(
    vleFluidType=medium,
    p=outlet.p,
    h=outlet.h_outflow)
    annotation (Placement(transformation(extent={{18,-8},{38,12}})));

  TILMedia.VLEFluid_ph fluidIn(
    vleFluidType=medium,
    h=inStream(inlet.h_outflow),
    p=inlet.p, d(start=rho_nom))
    annotation (Placement(transformation(extent={{-44,-36},{-24,-16}})));

  Modelica.Blocks.Tables.CombiTable1D HydraulicEfficiency(columns={2}, table=
        CL_eta_mflow)
    annotation (Placement(transformation(extent={{36,-100},{56,-80}})));

public
Summary summary(outline(showExpertSummary = showExpertSummary,p_nom= p_nom,m_flow_nom=m_flow_nom,rho_nom=rho_nom,Pi=Pi,Delta_p=p_out-p_in,P_mech=-P_t,eta_isen=eta_is,eta_mech=eta_mech,h_isen=h_is),
                inlet(showExpertSummary = showExpertSummary,m_flow=inlet.m_flow,  T=fluidIn.T, p=inlet.p, h=fluidIn.h,s=fluidIn.s, steamQuality=fluidIn.q, H_flow=fluidIn.h*inlet.m_flow, rho=fluidIn.d),
                outlet(showExpertSummary = showExpertSummary,m_flow = -outlet.m_flow, T=fluidOut.T, p=outlet.p, h=fluidOut.h, s=fluidOut.s, steamQuality=fluidOut.q, H_flow=-fluidOut.h*outlet.m_flow, rho=fluidOut.d)) annotation(Placement(
        transformation(extent={{-80,-102},{-60,-82}})));

public
  Basics.Interfaces.EyeOut       eye if showData
    annotation (Placement(transformation(extent={{40,-70},{60,-50}}),
        iconTransformation(extent={{40,-70},{60,-50}})));
protected
  Basics.Interfaces.EyeIn       eye_int
    annotation (Placement(transformation(extent={{25,-61},{27,-59}})));
equation
//~~~~~~~~~~~~~~~~~~~~~~~~~
// Efficiency ~~~~~~~~~~~~~
  eta_is=HydraulicEfficiency.y[1];
  HydraulicEfficiency.u[1]=inlet.m_flow/m_flow_nom;

//~~~~~~~~~~~~~~~~~~~~~~~~~
// Boundary conditions ~~~~
  inlet.h_outflow=inStream(outlet.h_outflow); //This is a dummy - flow reversal is not supported;
  outlet.h_outflow=eta_is*(h_is-inStream(inlet.h_outflow))+inStream(inlet.h_outflow);  //applied the definition of the isentropic efficiency
  p_in=inlet.p;
  p_out=outlet.p;

// Mass balance:
  inlet.m_flow=-outlet.m_flow;

// define isentropic outlet state:
  h_is= specificEnthalpy_psxi(fluidOut.p, fluidIn.s, fluidIn.xi, ptr_iso);
//h_is = fluidis.h;
// STODOLA's law:
  outlet.m_flow = homotopy(-Kt*sqrt(max(1e-5, fluidIn.d*inlet.p))* ClaRa.Basics.Functions.ThermoRoot(1 - (p_out^2/inlet.p^2), 0.01), -m_flow_nom*inlet.p/p_nom);
  P_t=outlet.m_flow*(fluidIn.h-fluidOut.h)*eta_mech;

  outlet.xi_outflow = inStream(inlet.xi_outflow);
  inlet.xi_outflow = inStream(outlet.xi_outflow);

  S_irr=inlet.m_flow*(fluidOut.s-fluidIn.s);

  eye_int.m_flow = -outlet.m_flow;
  eye_int.T = fluidOut.T-273.15;
  eye_int.s = fluidOut.s/1e3;
  eye_int.p = outlet.p/1e5;
  eye_int.h = fluidOut.h/1e3;

  connect(eye,eye_int)  annotation (Line(
      points={{50,-60},{26,-60}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-60,
            -100},{40,100}}), graphics), Icon(coordinateSystem(extent={{-60,
            -100},{40,100}}, preserveAspectRatio=true),  graphics));
end SteamTurbineVLE_L1;
