within ClaRa.Components.TurboMachines.Pumps;
model PumpVLE_L2_affinity "A pump for VLE mixtures with a finite fluid volume, based on affinity laws"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                            //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright © 2013-2015, DYNCAP research team.                              //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  import SI = ClaRa.Basics.Units;
  import pow = FluidDissipation.Utilities.Functions.General.SmoothPower;

  extends ClaRa.Basics.Icons.Pump;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");
  //extends Modelica.Icons.UnderConstruction;

  record Outline
   extends ClaRa.Basics.Icons.RecordIcon;
   input SI.VolumeFlowRate V_flow "Volume flow rate";
   input SI.Power P_hyd "Hydraulic power";
   input SI.PressureDifference Delta_p "Pressure difference";
   input SI.Length head "Head";
   input SI.Length NPSHa "Net positive suction head available";
   input Real eta_hyd "Hydraulic efficiency";
   input Real eta_mech "Mechanic efficiency";
  end Outline;

  record Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    ClaRa.Basics.Records.FlangeVLE  inlet;
    ClaRa.Basics.Records.FlangeVLE  outlet;
  end Summary;

   parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium=simCenter.fluid1 "Medium in the component"
                                         annotation(choicesAllMatching=true, Dialog(group="Fundamental Definitions"));

  parameter Boolean useMechanicalPort=false "|Fundamental Definitions|True, if a mechenical flange should be used";
  parameter Boolean steadyStateTorque=false "|Fundamental Definitions|True, if steady state mechanical momentum shall be used";
  parameter SI.RPM rpm_fixed = 60 "Constant rotational speed of pump"
                                        annotation (Dialog( group = "Fundamental Definitions", enable = not useMechanicalPort));

  parameter SI.RPM rpm_nom "|Characteristic field|Nomial rotational speed"
                                                                          annotation(Dialog(groupImage="modelica://ClaRa/figures/ParameterDialog/PumpCharField1.png"));
  parameter SI.VolumeFlowRate V_flow_max "|Characteristic field|Maximum volume flow rate at nominal speed";
  parameter SI.Pressure Delta_p_max "|Characteristic field|Maximum pressure difference at nominal speed";
  parameter Real exp_hyd= 0.5 "|Characteristic field|Exponent for affinity law";
  parameter Modelica.SIunits.Inertia J "Moment of Inertia" annotation(Dialog(group="Time Response Definitions", enable= not steadyStateTorque));

  //_____/ Inner fluid model \__________________________________________________________
  replaceable model PressureLoss =
    ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2
  constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2 "1st: choose friction model | 2nd: edit corresponding record"
  annotation (Dialog(tab="Fluid flow inside pump",group="Pressure loss"), choicesAllMatching=true);

  parameter SI.Volume volume_fluid=0.01 "|Fluid flow inside pump|Geometry|Volume of fluid";

  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nom= 10 "Nominal mass flow rates at inlet"
                                        annotation(Dialog(tab="Fluid flow inside pump", group="Nominal Values"));

  parameter Modelica.SIunits.Pressure p_nom=1e5 "Nominal pressure"
      annotation(Dialog(tab="Fluid flow inside pump",group="Nominal Values"));
  parameter Modelica.SIunits.SpecificEnthalpy h_nom=1e5 "Nominal specific enthalpy"
      annotation(Dialog(tab="Fluid flow inside pump",group="Nominal Values"));

  parameter Modelica.SIunits.SpecificEnthalpy h_start= 1e5 "Start value of sytsem specific enthalpy"
                                             annotation(Dialog(tab="Initialisation"));
  parameter Modelica.SIunits.Pressure p_start= 1e5 "Start value of sytsem pressure" annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Choices.Init      initType=ClaRa.Basics.Choices.Init.noInit "Type of initialisation"
                             annotation(Dialog(tab="Initialisation", choicesAllMatching));

  //________________________________________________________________________________

  parameter Boolean showExpertSummary = simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";

  parameter Real eta_hyd_nom=0.8 "|Expert Settings|Hydraulic losses - refer to documentation for details|Max. hydraulic efficiency at nominal speed";
  parameter Real exp_rpm=2 "|Expert Settings|Hydraulic losses - refer to documentation for details|Loss exponent w.r.t. rpm";
  parameter Real V_flow_opt_(min=0.0, max=1) = 0.6 "|Expert Settings|Hydraulic losses - refer to documentation for details|Relative position of nest point at V_flow axis in p.u.";
  parameter Real exp_flow=2 "|Expert Settings|Hydraulic losses - refer to documentation for details|Loss exponent w.r.t. volume flow";
  parameter SI.RPM rpm_stirrS = rpm_nom/4 "|Expert Settings|Hydraulic losses - refer to documentation for details|RPM at which rotor starts to act like a stirrer";
  parameter SI.RPM rpm_stirrE= rpm_nom/5 "|Expert Settings|Hydraulic losses - refer to documentation for details|RPM at which rotor acta like a stirrer";
  parameter SI.Area clearSection= 1 "|Expert Settings|Non-Design operation - refer to documentation for details|Effective clear section of pump";

  parameter SI.VolumeFlowRate V_flow_leak = 0.00002 "|Expert Settings|Non-Design operation - refer to documentation for details|Leakage mass flow";
  parameter SI.Pressure Delta_p_eps= 100 "|Expert Settings|Numerical Robustness|Small pressure difference for linearisation around zero mass flow";
  parameter Boolean stabiliseDelta_p=false "|Expert Settings|Numerical Robustness|Avoid chattering due to small pressure differences between inlet and outlet at small mass flows";
  parameter SI.Time Tau_stab=1 "Stabiliser state time constant - refer to documentation for details."
                                                                           annotation(Dialog(tab="Expert Settings",group="Numerical Robustness",enable=stabiliseDelta_p));

//   SI.Pressure Delta_p
//     "Pressure difference between pressure side and suction side";
//   SI.VolumeFlowRate V_flow "Volume flow rate";
//   SI.Power P_hyd;

  outer ClaRa.SimCenter simCenter;
  ClaRa.Basics.Interfaces.FluidPortIn inlet(
                                           Medium=medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut
                                     outlet(Medium=medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
  TILMedia.VLEFluid_ph  fluidIn(vleFluidType =    medium, p=inlet.p,
    h=actualStream(inlet.h_outflow))
    annotation (Placement(transformation(extent={{-90,14},{-70,34}})));
  TILMedia.VLEFluid_ph  fluidOut(
                                vleFluidType =    medium,
    p=outlet.p,
    h=actualStream(outlet.h_outflow))
    annotation (Placement(transformation(extent={{70,14},{90,34}})));
public
  Basics.Interfaces.EyeOut       eye if showData
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
        iconTransformation(extent={{100,-70},{120,-50}})));
protected
  SI.MassFlowRate m_flow_in_start( start=m_flow_nom);
  SI.MassFlowRate m_flow_out_start( start=m_flow_nom);
  SI.EnthalpyMassSpecific h_iso_start(start=h_start);

  Basics.Interfaces.EyeIn       eye_int
    annotation (Placement(transformation(extent={{45,-61},{47,-59}})));

  PumpVLE_L1_affinity pump(
    showExpertSummary=showExpertSummary,
    useMechanicalPort=useMechanicalPort,
    steadyStateTorque=steadyStateTorque,
    rpm_fixed=rpm_fixed,
    rpm_nom=rpm_nom,
    V_flow_max=V_flow_max,
    Delta_p_max=Delta_p_max,
    exp_hyd=exp_hyd,
    eta_hyd_nom=eta_hyd_nom,
    exp_rpm=exp_rpm,
    V_flow_opt_=V_flow_opt_,
    exp_flow=exp_flow,
    clearSection=clearSection,
    V_flow_leak=V_flow_leak,
    Delta_p_eps=Delta_p_eps,
    stabiliseDelta_p=stabiliseDelta_p,
    Tau_stab=Tau_stab,
    J=J,
    medium=medium,
    showData=false,
    rpm_stirrS=rpm_stirrS,
    rpm_stirrE=rpm_stirrE) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 pumpFluidVolume(medium=medium,
    useHomotopy=useHomotopy,
    m_flow_nom=m_flow_nom,
    p_nom=p_nom,
    h_nom=h_nom,
    h_start=h_start,
    p_start=p_start,
    initType=initType,
    showExpertSummary=showExpertSummary,
    redeclare model PressureLoss = PressureLoss,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry)
    annotation (Placement(transformation(extent={{24,-10},{44,10}})));
public
  Summary summary(
     outline( V_flow=pump.V_flow,
              P_hyd=pump.P_hyd,
              Delta_p=pump.Delta_p,
              head= pump.Delta_p/(fluidIn.d*Modelica.Constants.g_n),
              NPSHa = (inlet.p - fluidIn.VLE.p_l)/(fluidIn.d*Modelica.Constants.g_n),
              eta_hyd= pump.eta_hyd,
              eta_mech=1),
      inlet(  showExpertSummary = showExpertSummary,
              m_flow=inlet.m_flow,
              T=fluidIn.T,
              p=inlet.p,
              h=fluidIn.h,
              s=fluidIn.s,
              steamQuality = fluidIn.q,
              H_flow= fluidIn.h*inlet.m_flow,
              rho=fluidIn.d),
      outlet( showExpertSummary = showExpertSummary,
              m_flow=-outlet.m_flow,
              T=fluidOut.T,
              p=outlet.p,
              h=fluidOut.h,
              s=fluidOut.s,
              steamQuality = fluidOut.q,
              H_flow= fluidOut.h*outlet.m_flow,
              rho=fluidOut.d))  annotation(Placement(transformation(
        extent={{-10,-11},{10,11}},
        origin={-70,-91})));

  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft
    annotation (Placement(transformation(extent={{-10,62},{10,82}}),
        iconTransformation(extent={{-10,89},{10,109}})));

  SI.Power P_shaft=pump.P_shaft "Mechanicl power at shaft";

equation
  inlet.m_flow=m_flow_in_start;
  outlet.m_flow=m_flow_out_start;
  h_iso_start=pump.h_iso;

  eye_int.m_flow = -outlet.m_flow;
  eye_int.T = fluidOut.T-273.15;
  eye_int.s = fluidOut.s/1e3;
  eye_int.p = outlet.p/1e5;
  eye_int.h = fluidOut.h/1e3;

  connect(eye,eye_int)  annotation (Line(
      points={{100,-60},{46,-60}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(inlet, pump.inlet)                      annotation (Line(
      points={{-100,0},{-10,0}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pump.outlet, pumpFluidVolume.inlet)                    annotation (
      Line(
      points={{10,0},{24,0}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(pumpFluidVolume.outlet, outlet)
                                        annotation (Line(
      points={{44,0},{100,0}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(pump.shaft, shaft)                      annotation (Line(
      points={{0,9.9},{0,72}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Icon(graphics),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
              graphics));
end PumpVLE_L2_affinity;
