within Grate;
model FuelSource
  parameter SI.MassFlowRate m_flow;
  constant Integer n "Number of outputs";
  parameter SI.MassFraction prox[3]
    "Proximate analysis, Moisture, Combustibles, Ash";

  Modelica.Blocks.Interfaces.RealOutput y[n]
    annotation (Placement(transformation(extent={{30,-10},{50,10}}),
        iconTransformation(extent={{30,-10},{50,10}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
          extent={{-30,30},{30,-30}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid), Text(
          extent={{-20,16},{18,-14}},
          lineColor={0,140,72},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="Fuel")}), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={Rectangle(
          extent={{-30,30},{30,-30}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid), Text(
          extent={{-18,18},{18,-16}},
          lineColor={0,140,72},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="Fuel")}));
end FuelSource;
