within ClaRa.Basics.Interfaces;
connector Coal_outlet
  extends ClaRa.Basics.Interfaces.Coal_inlet;
  annotation (Icon(graphics={
                            Ellipse(
          extent={{-60,60},{60,-60}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          lineColor={27,36,42},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid)}));
end Coal_outlet;
