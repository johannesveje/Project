within ClaRa.StaticCycles.Fundamentals;
connector SteamSignal_green "Signal-based steam connector"

  extends ClaRa.StaticCycles.Fundamentals.SteamSignal_base;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-40,-100},{40,100}}),   graphics={Polygon(
          points={{-40,100},{40,100},{40,-100},{-40,-100},{-40,100}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={170,255,85},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(extent={{-40,-100},{40,100}})));
end SteamSignal_green;
