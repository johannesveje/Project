within ClaRa.Basics.Interfaces;
expandable connector SteamSignal "Signal bus featuring pressure, specific enthalpy and mass flow rate"
  extends Modelica.Icons.SignalBus;

   Real p_ "Pressure in p.u." annotation(HideResult=false);
   Real h_ "Specific enthalpy in p.u." annotation(HideResult=false);
   Real m_flow_ "Mass flow rate in p.u." annotation(HideResult=false);

annotation (defaultComponentPrefixes="protected",
              Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),       graphics={Rectangle(
          extent={{-20,2},{22,-2}},
          lineColor={255,204,51},
          lineThickness=0.5)}),
    Diagram(graphics));
end SteamSignal;
