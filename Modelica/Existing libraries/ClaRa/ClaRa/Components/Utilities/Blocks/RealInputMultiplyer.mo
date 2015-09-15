within ClaRa.Components.Utilities.Blocks;
block RealInputMultiplyer "Distributes a single real input into N real outputs having the same value"
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

  Modelica.Blocks.Interfaces.RealInput Signal "Input signal to be duplicated"
    annotation (Placement(transformation(extent={{-124,-18},{-88,18}}),
        iconTransformation(extent={{-124,-18},{-88,18}})));
  parameter Integer N=1;
  Modelica.Blocks.Interfaces.RealOutput y[N]
    annotation (Placement(transformation(extent={{124,44},{160,80}}),
        iconTransformation(extent={{0,-80},{160,80}})));

equation
  y = {Signal for i in 1:N};

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-88,0},{-80,0},{0,80}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-80,0},{0,40}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-80,0},{0,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-80,0},{0,-40}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-80,0},{0,-80}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{-98,-40},{-18,-84}},
          lineColor={0,0,255},
          textString="N= %N")}), Diagram(graphics));
end RealInputMultiplyer;
