within ClaRa.StaticCycles;
model Tube2 " Tube || green | green"
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
  // Green input: Values of p, m_flow and h are unknown and provided BY neighbor component.
  // Green output: Values of p, m_flow and h are known in component and provided FOR neighbor component.
  outer ClaRa.SimCenter simCenter;
  outer parameter Real P_target_ "Target power in p.u.";
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Pressure Delta_p_nom "|Fundamental Definitions|Nominal pressure loss";
  parameter ClaRa.Basics.Units.Length z_in = 0.0 "|Fundamental Definitions|Geodetic height at inlet";
  parameter ClaRa.Basics.Units.Length z_out = 0.0 "|Fundamental Definitions|Geodetic height at outlet";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false);
  final parameter ClaRa.Basics.Units.Pressure p_out = p_in - Delta_p_nom*P_target_ - Delta_p_geo "pressure at tube inlet";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "enthalpy at tube inlet";
  constant ClaRa.Basics.Units.MassFraction[:] xi=zeros(medium.nc - 1);
  final parameter ClaRa.Basics.Units.Pressure Delta_p_geo=
    TILMedia.VLEFluidFunctions.density_phxi(medium, p_in, h_in, xi) * Modelica.Constants.g_n * ( z_out - z_in) "Geostatic pressure difference";
  final parameter ClaRa.Basics.Units.Pressure p_in(fixed=false) "Inlet pressure";
  Fundamentals.SteamSignal_green inlet
    annotation (Placement(transformation(extent={{-106,-10},{-86,10}}), iconTransformation(extent={{-100,-10},{-92,10}})));
  Fundamentals.SteamSignal_green green(m_flow=m_flow, h=h_in, p=p_out)
    annotation (Placement(transformation(extent={{86,-10},{106,10}}), iconTransformation(extent={{92,-10},{100,10}})));
initial equation
  inlet.p=p_in;
  inlet.m_flow=m_flow;
  inlet.h=h_in;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-40},{100,40}}),
                   graphics={
        Text(
          extent={{-100,0},{102,-20}},
          lineColor={0,131,169},
          textString="%name%",
          fontSize=8), Polygon(
          points={{-92,40},{-72,40},{-52,30},{52,30},{72,40},{92,40},{92,-40},{72,-40},{52,-30},{-52,-30},{-72,-40},{-92,-40},{-92,40}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
                                 Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-75},{100,75}}), graphics));
end Tube2;
