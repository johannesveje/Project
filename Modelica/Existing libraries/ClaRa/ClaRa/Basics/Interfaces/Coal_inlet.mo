within ClaRa.Basics.Interfaces;
connector Coal_inlet
parameter ClaRa.Basics.Media.Fuel.PartialFuel coalType;
                                                   //= ClaRa.Basics.Media.Coal.Coal_v1();//(nc = 7);
    //"Medium model";

   Modelica.SIunits.AbsolutePressure p "Thermodynamic pressure in the connection point";
  flow Modelica.SIunits.MassFlowRate m_flow "Mass flow rate from the connection point into the component";
  stream Modelica.SIunits.Temperature T_outflow "Specific thermodynamic enthalpy close to the connection point if m_flow < 0";
  stream Modelica.SIunits.MassFraction xi_outflow[coalType.nc-1] "Independent mixture mass fractions m_i/m close to the connection point if m_flow < 0";
  annotation (Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={27,36,42},
          lineThickness=0.5,
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid)}));
end Coal_inlet;
