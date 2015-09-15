within ClaRa.Components.Utilities.Blocks;
block FirstOrderClaRa "First order transfer function block (= 1 pole)"
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
  extends Modelica.Blocks.Interfaces.SISO;

  parameter Modelica.SIunits.Time Tau=0 "Time Constant, set Tau=0 for no signal smoothing";
protected
  Real y_aux;
initial equation
  y_aux=u;
equation
  if Tau==0 then
    y=u;
    der(y_aux)=0;
  else
    der(y_aux) = (u - y_aux)/Tau;
    y=y_aux;
  end if;
  annotation (
    Documentation(info="<HTML>


</HTML>
"), Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,88},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-80},{-70,-45.11},{-60,-19.58},{-50,-0.9087},{-40,
              12.75},{-30,22.75},{-20,30.06},{-10,35.41},{0,39.33},{10,42.19},
              {20,44.29},{30,45.82},{40,46.94},{50,47.76},{60,48.36},{70,48.8},
              {80,49.12}}, color={0,0,127}),
        Text(
          extent={{0,0},{60,-60}},
          lineColor={192,192,192},
          textString="PT1"),
        Text(
          extent={{-150,-150},{150,-110}},
          lineColor={0,0,0},
          textString="T=%T")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Text(
          extent={{-48,52},{50,8}},
          lineColor={0,0,0},
          textString="k"),
        Text(
          extent={{-54,-6},{56,-56}},
          lineColor={0,0,0},
          textString="T s + 1"),
        Line(points={{-50,0},{50,0}}, color={0,0,0}),
        Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,0,255}),
        Line(points={{-100,0},{-60,0}}, color={0,0,255}),
        Line(points={{60,0},{100,0}}, color={0,0,255})}));
end FirstOrderClaRa;
