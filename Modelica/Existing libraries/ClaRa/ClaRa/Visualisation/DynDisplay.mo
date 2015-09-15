within ClaRa.Visualisation;
model DynDisplay "Dynamic Display of one variable"
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

  parameter String varname = "Name of the variable";
  input Real x1=1 "Variable value" annotation (Dialog);
  parameter String unit="°C" "Variable unit";
  parameter Integer decimalSpaces=1 "Accuracy to be displayed";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,0},{100,-100}},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={118,124,127}),
        Rectangle(
          extent={{-100,100},{100,0}},
          fillColor={209,211,212},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={27,36,42}),
        Text(
          extent={{-94,2},{106,-98}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({118,124,127}, if x1 > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" x ", realString(x1,1,integer(decimalSpaces)) + " %unit")),
        Text(
          extent={{-100,100},{100,0}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({118,124,127}, {73,80,85}),
          textString="%varname")}),         Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));

end DynDisplay;
