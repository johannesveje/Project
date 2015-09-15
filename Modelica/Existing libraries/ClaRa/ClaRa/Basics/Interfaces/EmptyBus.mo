within ClaRa.Basics.Interfaces;
expandable connector EmptyBus "A bus"
  extends Modelica.Icons.SignalBus;

annotation (defaultComponentPrefixes="protected",
              Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),       graphics={Rectangle(
          extent={{-20,2},{22,-2}},
          lineColor={255,204,51},
          lineThickness=0.5)}),
    Diagram(graphics));
end EmptyBus;
