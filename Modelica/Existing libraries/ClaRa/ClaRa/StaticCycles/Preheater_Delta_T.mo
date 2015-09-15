within ClaRa.StaticCycles;
model Preheater_Delta_T "1ph preheater || par.: shell pressure, shell m_flow, Delta_T"
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
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"  annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.TemperatureDifference Delta_T "|Fundamental Definitions|Upper temperature difference (T_tap_in - T_cond_out)";
  parameter ClaRa.Basics.Units.Pressure p_tap=1e5 "|Fundamental Definitions|Pressure of heating steam";
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_tap "|Fundamental Definitions|Mass flow rate of the heating steam";
  final parameter ClaRa.Basics.Units.Temperature T_tap_in = TILMedia.VLEFluidFunctions.temperature_phxi(medium, p_tap, h_tap_in);
  final parameter ClaRa.Basics.Units.Temperature T_cond_in = TILMedia.VLEFluidFunctions.temperature_phxi(medium, p_cond, h_cond_in);
  final parameter ClaRa.Basics.Units.Temperature T_cond_out = T_tap_in - Delta_T;
  final parameter ClaRa.Basics.Units.Temperature T_tap_out = T_tap_in -m_flow_cond*TILMedia.VLEFluidFunctions.specificIsobaricHeatCapacity_pTxi(medium,p_cond,T_cond_in)*(T_cond_out-T_cond_in)/(m_flow_tap*TILMedia.VLEFluidFunctions.specificIsobaricHeatCapacity_pTxi(medium,p_tap,T_tap_in));

  final parameter ClaRa.Basics.Units.Pressure p_cond(fixed=false);

  final parameter ClaRa.Basics.Units.MassFlowRate  m_flow_cond(fixed=false) "Mass flow of the condensate";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_tap_in(fixed=false);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_cond_in(fixed=false);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_tap_out = TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(medium,p_tap,T_tap_out);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_cond_out=m_flow_tap*(h_tap_in - h_tap_out)/m_flow_cond + h_cond_in;                                                                //(m_flow_tap* h_tap_in + h_cond_in * m_flow_cond)/(m_flow_tap + m_flow_cond);

//   ClaRa.Basics.Units.Pressure p_in_cond = p_out_cond;
//   ClaRa.Basics.Units.Pressure p_out_cond = p_in_cond;
  Fundamentals.SteamSignal_blue cond_in(p=p_cond)
    annotation (Placement(transformation(extent={{-114,-10},{-94,10}}), iconTransformation(extent={{-108,-10},{-100,10}})));
  Fundamentals.SteamSignal_blue cond_out(m_flow=m_flow_cond, h=h_cond_out)
    annotation (Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{108,10}})));
  Fundamentals.SteamSignal_red tap_in(p=p_tap, m_flow=m_flow_tap) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,104}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=-90,
        origin={0,104})));
  Fundamentals.SteamSignal_green tap_out(
    p=p_tap,
    m_flow=m_flow_tap,
    h=h_tap_out) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-104}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=-90,
        origin={1.77636e-015,-104})));
initial equation
  tap_in.h=h_tap_in;
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
          points={{-100,4},{-2,-44},{-2,38},{100,4}},
          color={0,131,169},
          smooth=Smooth.None)}));
end Preheater_Delta_T;
