within ClaRa.Components.Sensors;
model vleMassflowSensor "Ideal one port mass flow sensor"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.0.0                        //
  //                                                                           //
  // Licensed by the DYNCAP research team under Modelica License 2.            //
  // Copyright � 2013-2015, DYNCAP research team.                                   //
  //___________________________________________________________________________//
  // DYNCAP is a research project supported by the German Federal Ministry of  //
  // Economics and Technology (FKZ 03ET2009).                                  //
  // The DYNCAP research team consists of the following project partners:      //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  extends ClaRa.Components.Sensors.vleSensorBase;
  outer ClaRa.SimCenter simCenter;

  Modelica.Blocks.Interfaces.RealOutput m_flow(
    final quantity="Pressure",
    displayUnit="kg/s",
    final unit="kg/s") "Mass flow rate"          annotation (Placement(
        transformation(extent={{100,-10},{120,10}},
                                                 rotation=0),
        iconTransformation(extent={{100,-10},{120,10}})));
equation
  m_flow = inlet.m_flow;
  annotation (Diagram(graphics), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                      graphics={
        Text(
          extent={{-100,0},{100,-40}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-100,40},{100,0}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="FIT"),
        Line(
          points={{0,-40},{0,-100}},
          color={27,36,42},
          thickness=0.5,
          smooth=Smooth.None),
        Text(
          extent={{-100,60},{100,90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if m_flow > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" m_flow ", realString(m_flow, 1,1)+" kg/s")),
        Line(
          points={{80,0},{100,0}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{-98,-100},{96,-100}},
          color={0,131,169},
          smooth=Smooth.None,
          thickness=0.5),
        Polygon(
          points={{-20,40},{-20,40},{-62,40},{-86,0},{-62,-40},{-20,-40},{20,-40},{62,-40},{86,0},{62,40},{20,40},{-20,40}},
          lineColor={27,36,42},
          smooth=Smooth.Bezier,
          lineThickness=0.5)}));
end vleMassflowSensor;
