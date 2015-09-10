within Grate;
model CombustionSystem
  extends Modelica.Fluid.System;
  replaceable package FlueGas =
      Modelica.Media.IdealGases.MixtureGases.FlueGasSixComponents
    constrainedby Modelica.Media.Interfaces.PartialMedium annotation (
      choicesAllMatching=true);

protected
  package Index
    package Proximate
      constant Integer Moisture=1;
      constant Integer Combustibles=2;
      constant Integer Ash=3;
    end Proximate;
  end Index;
equation

end CombustionSystem;
