within Grate;
model CombustionSystem
  extends Modelica.Fluid.System;
  replaceable package FlueGas =
      Modelica.Media.IdealGases.MixtureGases.FlueGasSixComponents
    constrainedby Modelica.Media.Interfaces.PartialMedium annotation (
      choicesAllMatching=true);

end CombustionSystem;
