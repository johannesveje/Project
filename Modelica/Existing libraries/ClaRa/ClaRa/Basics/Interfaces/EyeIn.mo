within ClaRa.Basics.Interfaces;
expandable connector EyeIn "Signal bus featuring pressure, specific enthalpy, temperature, specific entropy and mass flow rate"
  import SI = ClaRa.Basics.Units;
   input Real p "Pressure in bar" annotation(HideResult=false);
   input Real h "Specific enthalpy in kJ/kg" annotation(HideResult=false);
   input Real m_flow "Mass flow rate in kg/s" annotation(HideResult=false);
   input SI.Temperature_DegC T "Tempearture in degC" annotation(HideResult=false);
   input Real s "Specific entropy in kJ/kgK" annotation(HideResult=false);

  annotation (defaultComponentName="eyeIn",
  Icon(graphics={Polygon(
          points={{-100,100},{100,0},{-100,-100},{-100,100}},
          lineColor={190,190,190},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid)},
       coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true, initialScale=0.2)),
  Diagram(coordinateSystem(
        preserveAspectRatio=true, initialScale=0.2,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={Polygon(
          points={{0,50},{100,0},{0,-50},{0,50}},
          lineColor={153,205,221},
          fillColor={153,205,221},
          fillPattern=FillPattern.Solid), Text(
          extent={{-10,85},{-10,60}},
          lineColor={153,205,221},
          textString="%name"),
        Polygon(
          points={{6,40},{85,0},{6,-40},{6,40}},
          lineColor={27,36,42},
          smooth=Smooth.None,
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid)}));
end EyeIn;
