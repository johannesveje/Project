within ClaRa.StaticCycles;
model Triple "Visualise static cycle results"
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
  DecimalSpaces decimalSpaces "Accuracy to be displayed" annotation(Dialog);
record DecimalSpaces
parameter Integer m_flow=1 "Accuracy to be displayed for mass flow";
parameter Integer h=1 "Accuracy to be displayed for enthalpy";
parameter Integer p=1 "Accuracy to be displayed for pressure";
end DecimalSpaces;

  Fundamentals.SteamSignal_base steamSignal annotation (Placement(transformation(extent={{-108,-10},{-100,10}}),iconTransformation(extent={{-120,-20},{-100,40}})));

annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{220,180}},
        initialScale=0.04),    graphics={
        Text(
          extent={{-90,80},{150,10}},
          lineColor=DynamicSelect({164,167,170},{0,131,169}),
          fillColor={0,131,169},
          horizontalAlignment=TextAlignment.Left,
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("p", realString(steamSignal.p/1e5,1,integer(decimalSpaces.p)) + " bar")),
        Text(
          extent={{-90,-10},{250,-80}},
          lineColor=DynamicSelect({164,167,170},{0,131,169}),
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString=DynamicSelect("h", realString(steamSignal.h/1e3,1,integer(decimalSpaces.h)) + " kJ/kg")),
        Text(
          extent={{-90,170},{150,100}},
          lineColor=DynamicSelect({164,167,170},{0,131,169}),
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString=DynamicSelect("m", realString(steamSignal.m_flow,1,integer(decimalSpaces.m_flow)) + " kg/s")),
        Line(
          points={{-100,180},{-100,-100}},
          color=DynamicSelect({164,167,170},{0,131,169}),
          smooth=Smooth.None,thickness=0.5)}),                                                                           Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{220,180}},
        initialScale=0.08),  graphics));

end Triple;
