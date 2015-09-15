within ClaRa.StaticCycles;
model Preheater_twoShell "Two cascade preheater || bubble state at shell outlets || par.: shell pressures, shell m_flows"
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
  // Red input:    Values of p and m_flow are known in component and provided FOR neighbor component, value of h is unknown and provided BY neighbor component.
  // Blue output:  Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.
  // Green output: Values of p, m_flow and h are known in component an provided FOR neighbor component.
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Pressure p_tap1=1e5 "|Fundamental Definitions|Pressure of heating steam 1";
  parameter ClaRa.Basics.Units.Pressure p_tap2=1e5 "|Fundamental Definitions|Pressure of heating steam 2";

  parameter ClaRa.Basics.Units.MassFlowRate m_flow_tap1=1 "|Fundamental Definitions|Mass flow rate of the heating steam 1";
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_tap2=1 "|Fundamental Definitions|Mass flow rate of the heating steam 2";
  final parameter ClaRa.Basics.Units.Pressure p_cond(fixed=false);
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_cond(fixed=false) "Mass flow of the condensate";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_tap1_in(fixed=false);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_tap2_in(fixed=false);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_cond_in(fixed=false);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_tap1_out=
      TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_tap1);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_tap2_out=
      TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_tap2);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_cond_out=(m_flow_tap2*
      h_tap2_in + m_flow_tap1*h_tap1_in + h_cond_in*m_flow_cond)/(m_flow_tap1
       + m_flow_tap2 + m_flow_cond);
  Fundamentals.SteamSignal_blue cond_in(p=p_cond)
    annotation (Placement(transformation(extent={{-114,-10},{-94,10}}), iconTransformation(extent={{-108,-10},{-100,10}})));
  Fundamentals.SteamSignal_blue cond_out(m_flow=m_flow_cond, h=h_cond_out)
    annotation (Placement(transformation(extent={{94,-10},{114,10}}), iconTransformation(extent={{100,-10},{108,10}})));
  Fundamentals.SteamSignal_red tap_1_in(p=p_tap1, m_flow=m_flow_tap1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,104}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=-90,
        origin={-40,104})));
  Fundamentals.SteamSignal_blue tap_1_out(
    p=p_tap1,
    m_flow=m_flow_tap1,
    h=h_tap1_out) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-104}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=-90,
        origin={-40,-104})));
  Fundamentals.SteamSignal_red tap_2_in(p=p_tap2, m_flow=m_flow_tap2)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,104}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=270,
        origin={40,104})));
  Fundamentals.SteamSignal_green tap_2_out(
    p=p_tap2,
    m_flow=m_flow_tap2,
    h=h_tap2_out) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-104}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={40,-104})));

initial equation
  tap_1_in.h=h_tap1_in;
  tap_2_in.h=h_tap2_in;
  cond_in.h=h_cond_in;
  cond_in.m_flow=m_flow_cond;
  cond_out.p=p_cond;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                                      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,0},{-2,-44},{-2,38},{100,0}},
          color={0,131,169},
          smooth=Smooth.None)}));
end Preheater_twoShell;
