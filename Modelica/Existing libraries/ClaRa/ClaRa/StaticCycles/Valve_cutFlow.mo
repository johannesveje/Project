within ClaRa.StaticCycles;
model Valve_cutFlow "Valve || yellow | red"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                            //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright � 2013-2015, DYNCAP research team.                              //
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
   // Red output:   Values of p and m_flow are unknown and provided BY neighbor component, value of h is known and provided FOR neighbor component.
  final parameter ClaRa.Basics.Units.Pressure p_in(fixed=false);
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false) "Mass flow rate";

final parameter ClaRa.Basics.Units.Pressure p_out(fixed=false);
final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false);
final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=h_in;
final parameter ClaRa.Basics.Units.Pressure Delta_p=p_in-p_out;
  Fundamentals.SteamSignal_yellow inlet(m_flow=m_flow)
    annotation (Placement(transformation(extent={{-64,-10},{-44,10}}),
        iconTransformation(extent={{-58,-10},{-50,10}})));
  Fundamentals.SteamSignal_red  outlet(h=h_out) annotation (
      Placement(transformation(extent={{44,-10},{64,10}}), iconTransformation(
          extent={{50,-10},{58,10}})));
initial equation
  outlet.p=p_out;
  inlet.p=p_in;
  inlet.h=h_in;
  outlet.m_flow=m_flow;
equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=true,extent={{-50,-25},{50,25}}),
                   graphics={Polygon(
          points={{-50,-25},{50,25},{50,-25},{-50,25},{-50,-25}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={0,0},
          rotation=360,
          lineThickness=0.25)}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-50,-25},{50,25}}),   graphics));
end Valve_cutFlow;
