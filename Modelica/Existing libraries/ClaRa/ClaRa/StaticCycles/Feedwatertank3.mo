within ClaRa.StaticCycles;
model Feedwatertank3 "Feedwatertank || par.: m_flow_FW, p_FW_nom || blue | red | green"
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
  // Green output: Values of p, m_flow and h are known in component and provided FOR neighbor component.
   outer parameter Real P_target_ "Target power in p.u.";
  outer ClaRa.SimCenter simCenter;
   parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "|Fundamental Definitions|Medium in the component"
                                                       annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                        choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                        choice=simCenter.fluid3 "Third fluid defined in global simCenter"));
  parameter ClaRa.Basics.Units.Pressure p_FWT_nom "|Fundamental Definitions|Feed water tank pressure at nominal load";
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom "|Fundamental Definitions|Mass flow rate at nomoinal load";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_tap_in(fixed=false,start=1);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_cond_in(fixed=false);
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_cond(fixed=false);

//__________________________________________________

//   final parameter ClaRa.Basics.Units.Pressure p_FWT = P_target_* p1 + p2
//     "Feedwater tank pressure at current load";

  final parameter ClaRa.Basics.Units.Pressure p_FWT=P_target_*p_FWT_nom "Feedwater tank pressure at current load";

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_tap=(h_cond_in*m_flow_cond - h_cond_out*m_flow_cond)/(h_cond_out - h_tap_in) "Mass flow of the heating steam";

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_FW=P_target_*m_flow_nom "Mass flow of the condensate";

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_cond_out= TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_FWT);

  Fundamentals.SteamSignal_blue cond_in(p=p_FWT) annotation (Placement(
        transformation(extent={{-106,-70},{-86,-50}}), iconTransformation(
          extent={{-100,-70},{-92,-50}})));
  Fundamentals.SteamSignal_red tap_in(m_flow=m_flow_tap, p=p_FWT) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,16}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=-90,
        origin={1.77636e-015,16})));
  Fundamentals.SteamSignal_green cond_out(
    h=h_cond_out,
    p=p_FWT,
    m_flow=m_flow_FW) annotation (Placement(transformation(extent={{86,-70},{106,-50}}),
                         iconTransformation(extent={{92,-70},{100,-50}})));
initial equation
  m_flow_cond=cond_in.m_flow;
  h_tap_in=tap_in.h;
  h_cond_in=cond_in.h;

equation
  connect(cond_out, cond_out) annotation (Line(
      points={{96,-60},{96,-60}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
                                                             extent={{-100,-100},{100,20}}), graphics={
        Rectangle(
          extent={{-20,-36},{20,12}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          radius=10),
        Rectangle(
          extent={{-92,-20},{92,-100}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          radius=20),
        Line(
          points={{-20,-20},{20,-20}},
          color={255,255,255},
          smooth=Smooth.Bezier),
        Line(
          points={{0,12},{0,-58},{-8,-48}},
          color={0,131,169},
          smooth=Smooth.None),
        Line(
          points={{0,-58},{8,-48}},
          color={0,131,169},
          smooth=Smooth.None),
        Line(
          points={{-92,-60},{92,-60},{78,-72}},
          color={0,131,169},
          smooth=Smooth.None),
        Line(
          points={{92,-60},{78,-48}},
          color={0,131,169},
          smooth=Smooth.None)}),
                         Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,20}}),
                              graphics));
end Feedwatertank3;
