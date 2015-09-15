within ClaRa.StaticCycles;
model Condenser "Condenser || par.: pressure, absLevel || blue |green"
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
  // Green output: Values of p, m_flow and h are known in component and provided FOR neighbor component.
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.Pressure
                        p_condenser = 4000 "|Fundamental Definitions|Condenser pressure";
  parameter ClaRa.Basics.Units.Length absLevel = 0 "|Fundamental Definitions|Filling level in hotwell";

    final parameter ClaRa.Basics.Units.Pressure p_in=p_condenser "|Internals|Internally set values - do not edit!|Inlet pressure";
    final parameter ClaRa.Basics.Units.Pressure p_out=p_condenser + Modelica.Constants.g_n*TILMedia.VLEFluidFunctions.bubbleDensity_pxi(medium, p_condenser)*absLevel "|Internals|Internally set values - do not edit!|Outlet pressure";
    final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "|Internals|Internally set values - do not edit!|Inlet enthalpy";
    final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_condenser) "|Internals|Internally set values - do not edit!|Outlet enthalpy";
    final parameter ClaRa.Basics.Units.MassFlowRate    m_flow_in(fixed=false) "|Internals|Internally set values - do not edit!|Inlet mass flow";
//    final parameter ClaRa.Basics.Units.MassFlowRate    m_flow_out=m_flow_cond;

public
  Fundamentals.SteamSignal_blue inlet(p=p_out) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,104}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=270,
        origin={0,104})));
  Fundamentals.SteamSignal_green outlet(
    h=h_out,
    p=p_out,
    m_flow=m_flow_in) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-104}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=270,
        origin={0,-104})));

initial equation

 inlet.m_flow=m_flow_in;
 inlet.h=h_in;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                                               graphics={
                             Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Line(
          points={{100,58},{-36,58},{38,-2},{-30,-62},{100,-62}},
          color={0,131,169},
          smooth=Smooth.None)}));
end Condenser;
