within ClaRa.StaticCycles;
model Mixer1 "Mixer || blue | blue | blue"
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
  // Blue input:   Value of p is known in component and provided FOR neighbor component, values of m_flow and h are unknown and provided BY neighbor component.
  // Blue output:  Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h1(fixed=false) "|Internals|Internally set values - do not edit!|Specific enthalpy of flow 1";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h2(fixed=false) "|Internals|Internally set values - do not edit!|Specific enthalpy of flow 2";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_1(fixed=false) "|Internals|Internally set values - do not edit!|Mass flow rate of flow 1";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_2(fixed=false) "|Internals|Internally set values - do not edit!|Mass flow rate of flow 2";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h3=(h1*m_flow_1 + h2*
      m_flow_2)/m_flow_3 "|Internals|Internally set values - do not edit!|Mixer outlet enthalpy";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_3=m_flow_1 + m_flow_2 "|Internals|Internally set values - do not edit!|Mixer outlet mass flow rate";
  final parameter ClaRa.Basics.Units.Pressure p(fixed=false) "|Internals|Internally set values - do not edit!|Mixer pressure";

  Fundamentals.SteamSignal_blue inlet_1(p=p) annotation (Placement(
        transformation(extent={{36,10},{56,30}}), iconTransformation(extent={{40,10},{50,30}})));
  Fundamentals.SteamSignal_blue inlet_2(p=p) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-104}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=-90,
        origin={0,-26})));
  Fundamentals.SteamSignal_blue outlet(h=h3, m_flow=m_flow_3) annotation (
      Placement(transformation(extent={{-52,10},{-36,30}}), iconTransformation(
          extent={{-50,10},{-42,30}})));
initial equation
  inlet_1.h=h1;
  inlet_1.m_flow=m_flow_1;
  inlet_2.h=h2;
  inlet_2.m_flow=m_flow_2;
  outlet.p=p;

equation
  connect(inlet_1, inlet_1) annotation (Line(
      points={{46,20},{46,11},{46,20},{46,20}},
      color={0,131,169},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-50,-30},{50,30}}),
                         graphics={Polygon(
          points={{-50,30},{50,30},{50,10},{10,10},{10,-30},{-10,-30},{-10,10},{-50,10},{-50,30}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-50,-20},{50,30}}),     graphics));
end Mixer1;
