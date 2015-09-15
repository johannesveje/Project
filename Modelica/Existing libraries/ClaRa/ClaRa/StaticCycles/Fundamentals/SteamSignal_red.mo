within ClaRa.StaticCycles.Fundamentals;
connector SteamSignal_red "Signal-based steam connector"

  extends ClaRa.StaticCycles.Fundamentals.SteamSignal_base;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-40,-100},{40,100}}),   graphics={
          Rectangle(
          extent={{-40,100},{40,-100}},
          lineColor={0,131,169},
          fillColor={255,170,213},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(extent={{-40,-100},{40,100}})));
end SteamSignal_red;
