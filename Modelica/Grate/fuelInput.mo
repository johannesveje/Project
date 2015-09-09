within Grate;
expandable connector fuelInput
  extends Modelica.Icons.SignalBus;
   constant Real nXi=Modelica.Media.IdealGases.Common.FluidData.C3H7OH.molarMass;
SI.MassFlowRate m_flow annotation ();
Real k annotation ();
Real j annotation ();
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end fuelInput;
