within ClaRa.Basics.Interfaces;
connector CoalDust_inlet "Port describing Coal and CombustionAir flow"

 parameter ClaRa.Basics.Media.Fuel.PartialFuel coalType;

  ClaRa.Basics.Interfaces.GasPortIn flueGas
    annotation (Placement(transformation(extent={{-30,-70},{30,-10}})));
  ClaRa.Basics.Interfaces.Coal_inlet coal(coalType=coalType)
    annotation (Placement(transformation(extent={{-30,10},{30,70}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),
                   graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={118,106,98},
          lineThickness=0.5,
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                                                    graphics));
end CoalDust_inlet;
