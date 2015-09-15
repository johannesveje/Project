within ClaRa.Components.Utilities.Blocks;
model TimeExtrema "Calculates the minimum and maximum value in a given period of time"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                        //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright © 2013-2015, DYNCAP research team.                                   //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

protected
  Real ymax;
  Real ymin;

public
  Modelica.Blocks.Interfaces.RealOutput y_max
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput y_min
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
equation
  der(ymax)=noEvent(if ymax<u then (u-ymax)/1 else 0);
  der(ymin)=noEvent(if ymin>u then (u-ymin)/1 else 0);
  y_max=ymax;
  y_min=ymin;
initial equation
  ymax=u;
  ymin=u;
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,102},{100,-98}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,80},{-80,-78},{76,-78}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-68,-16},{-44,34},{-18,64},{-14,-36},{6,-38},{10,-28},{28,20},
              {55.9805,-7.98047},{100,6}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-68,-18},{-46,-18},{-16,-18},{-16,-18},{-10,-40},{16,-40},{
              16,-40},{100,-40}},
          color={44,91,135},
          smooth=Smooth.Bezier),
        Line(
          points={{-68,-14},{-44,36},{-26,58},{8,58},{100,58}},
          color={191,0,0},
          smooth=Smooth.Bezier)}),
                                 Diagram(graphics));
end TimeExtrema;
