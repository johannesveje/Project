within ClaRa.StaticCycles;
model Pump_real "Real Pump || par.: efficiency || green | blue"
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
  // Blue output: Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));
  parameter Real  efficiency= 1 "|Fundamental Definitions|Pump efficiency";
  final parameter ClaRa.Basics.Units.Pressure p_in(fixed=false) "Inlet pressure";
  final parameter ClaRa.Basics.Units.Pressure p_out(fixed=false) "Outlet pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false) "Mass flow rate";
  final parameter ClaRa.Basics.Units.DensityMassSpecific rho_in=
      TILMedia.VLEFluidFunctions.bubbleDensity_pxi(medium, p_in);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false);
//   final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in=
//       TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_in);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=h_in + (
      TILMedia.VLEFluidFunctions.specificEnthalpy_psxi(
      medium,
      p_out,
      TILMedia.VLEFluidFunctions.specificEntropy_phxi(
        medium,
        p_in,
        h_in)) - h_in)/efficiency;
  final parameter ClaRa.Basics.Units.Power P_pump=m_flow*(h_out - h_in);

  Fundamentals.SteamSignal_green inlet
    annotation (Placement(transformation(extent={{-114,-10},{-94,10}}), iconTransformation(extent={{-108,-10},{-100,10}})));
  Fundamentals.SteamSignal_blue outlet(m_flow=m_flow, h=h_out) annotation (
      Placement(transformation(extent={{94,-10},{114,10}}), iconTransformation(extent={{100,-10},{108,10}})));
initial equation
  inlet.p=p_in;
  inlet.m_flow=m_flow;
  inlet.h=h_in;
  outlet.p=p_out;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}),
                                      graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-98,0},{100,0}},
          color={0,131,169},
          smooth=Smooth.None),
        Line(
          points={{60,40},{100,0},{58,-42}},
          color={0,131,169},
          smooth=Smooth.None)}));
end Pump_real;
