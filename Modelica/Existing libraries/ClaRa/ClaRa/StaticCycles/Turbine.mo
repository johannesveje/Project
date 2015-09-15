within ClaRa.StaticCycles;
model Turbine "Turbine || par.: efficiency || green | blue"
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

  parameter Real efficiency= 1 "|Fundamental Definitions|Hydraulic efficiency";
  final parameter ClaRa.Basics.Units.DensityMassSpecific rho_in =  TILMedia.VLEFluidFunctions.density_phxi(medium, p_in,h_in) "Inlet density";
   final parameter ClaRa.Basics.Units.Power P_turbine=(-h_out + h_in)*m_flow "Turbine power";

//protected
  final parameter ClaRa.Basics.Units.Pressure p_in(fixed=false) "|Internals|Internally set values - do not edit!|Inlet pressure";
  final parameter ClaRa.Basics.Units.Pressure p_out(fixed=false) "|Internals|Internally set values - do not edit!|Outlet pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false,start=1) "|Internals|Internally set values - do not edit!|Mass flow rate";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "|Internals|Internally set values - do not edit!|Inlet specific enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific       h_out=h_in +
      efficiency*(TILMedia.VLEFluidFunctions.specificEnthalpy_psxi(
      medium,
      p_out,
      TILMedia.VLEFluidFunctions.specificEntropy_phxi(
        medium,
        p_in,
        h_in)) - h_in) "|Internals|Internally set values - do not edit!|Outlet enthalpy";

public
  Fundamentals.SteamSignal_green inlet annotation (Placement(transformation(
          extent={{-64,30},{-44,50}}), iconTransformation(extent={{-52,30},{-44,50}})));
  Fundamentals.SteamSignal_blue outlet(h=h_out, m_flow=m_flow) annotation (
      Placement(transformation(extent={{46,-90},{66,-70}}), iconTransformation(
          extent={{52,-90},{60,-70}})));

//

initial equation
  inlet.m_flow=m_flow;
  inlet.p=p_in;
  inlet.h=h_in;
  outlet.p=p_out;

equation
  connect(inlet, inlet) annotation (Line(
      points={{-54,40},{-54,40}},
      color={0,131,169},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-60,
            -100},{60,100}}),  graphics), Icon(coordinateSystem(
          preserveAspectRatio=false,extent={{-60,-100},{60,100}}), graphics={
                                  Polygon(
          points={{-52,50},{52,86},{52,-90},{-52,-50},{-52,50}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end Turbine;
