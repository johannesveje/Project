within ClaRa.StaticCycles;
model Reboiler "Reboiler || par.: p_reb, m_flow_reb || red | green"
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
  // Red input:    Values of p and m_flow are known in component and provided FOR neighbor component, value of h is unknown and provided BY neighbor component.
  // Green output: Values of p, m_flow and h are known in component an provided FOR neighbor component.
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));

parameter ClaRa.Basics.Units.Pressure p_reb=3.5e5 "|Fundamental Definitions|Reboiler pressure";
parameter ClaRa.Basics.Units.MassFlowRate m_flow_reb=150 "|Fundamental Definitions|Reboiler mass flow rate";
final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false);
final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=
      TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_reb);
  Fundamentals.SteamSignal_red inlet(p=p_reb, m_flow=m_flow_reb)
    annotation (Placement(transformation(extent={{-114,-10},{-94,10}}), iconTransformation(extent={{-108,-10},{-100,10}})));
  Fundamentals.SteamSignal_green outlet(
    p=p_reb,
    m_flow=m_flow_reb,
    h=h_out) annotation (Placement(transformation(extent={{94,-10},{114,10}}),
        iconTransformation(extent={{100,-10},{108,10}})));
initial equation
  inlet.h=h_in;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
                   extent={{-100,-100},{100,100}}),
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
end Reboiler;
