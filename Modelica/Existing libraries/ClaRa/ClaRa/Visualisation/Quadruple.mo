within ClaRa.Visualisation;
model Quadruple " Cross-shaped dynamic display of m_flow, p, T, h and m_flow"
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

//  parameter String unit="°C" "Variable unit";
  parameter Integer identifier= 0 "Identifier of the quadruple";
  DecimalSpaces decimalSpaces "Accuracy to be displayed" annotation(Dialog);
  parameter Boolean largeFonts= simCenter.largeFonts "True if visualisers shall be displayed as large as posible";
record DecimalSpaces
parameter Integer T=1 "Accuracy to be displayed for temperature";
parameter Integer m_flow=1 "Accuracy to be displayed for mass flow";
parameter Integer h=1 "Accuracy to be displayed for enthalpy";
parameter Integer p=1 "Accuracy to be displayed for pressure";
end DecimalSpaces;
  outer ClaRa.SimCenter simCenter;
  ClaRa.Basics.Interfaces.EyeIn eye  annotation (Placement(
        transformation(extent={{-210,-110},{-190,-90}}), iconTransformation(
          extent={{-210,-110},{-190,-90}})));

//  end when;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -200},{200,0}},
        initialScale=0.05),    graphics={
        Rectangle(
          extent={{-200,0},{200,-200}},
          fillColor={250,250,250},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent=if largeFonts then {{-200,0},{0,-100}} else {{-198,-44},{2,-66}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230}, if time> 0 then if eye.m_flow>0 then {0,131,169} else {167,25,48} else {230,230,230}),
          textString=DynamicSelect(" m ", realString(eye.m_flow,1,integer(decimalSpaces.m_flow)) +" kg/s")),
        Text(
          extent=if largeFonts then {{-202,-100},{0,-200}} else {{-200,-140},{0,-160}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230,230,230},if time>0 then {0,131,169} else {230,230,230}),
          textString=DynamicSelect(" h ", realString(eye.h,1,integer(decimalSpaces.h)) + " kJ/kg")),
        Text(
          extent=if largeFonts then {{0,0},{200,-100}} else {{0,-40},{200,-60}},
          textString=DynamicSelect(" T ", realString(eye.T,1,integer(decimalSpaces.T)) + " °C"),
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230,230,230},if time>0 then {0,131,169} else {230,230,230})),
        Text(
          extent=if largeFonts then {{0,-100},{200,-200}} else {{0,-140},{200,-162}},
          textString=DynamicSelect(" p ", realString(eye.p,1,integer(decimalSpaces.p)) + " bar"),
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230,230,230},if time>0 then {0,131,169} else {230,230,230})),
        Line(
          points={{0,0},{0,-200}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          lineColor=DynamicSelect({190,190,190},if time>0 then {0,131,169} else {190,190,190})),
        Line(
          points={{-200,-100},{200,-100}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          lineColor=DynamicSelect({190,190,190},if time>0 then {0,131,169} else {190,190,190}))}),            Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-200,
            -200},{200,0}},
        initialScale=0.05),  graphics));

end Quadruple;
