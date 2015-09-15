within Grate.Interfaces;
connector FuelPort_a "Solid fuel flow connector at design inlet"
  extends FuelPort;
  annotation (
    defaultComponentName="port_a",
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,0},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid), Text(extent={{-150,110},{150,50}},
            textString="%name")}),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,127,0},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid), Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid)}));
end FuelPort_a;
