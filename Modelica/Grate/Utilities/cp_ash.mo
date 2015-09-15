within Grate.Utilities;
function cp_ash
  extends Modelica.Icons.Function;
  input SI.Temperature T1
    "Temperature of the biomass or temperature of interval";
  input SI.Temperature T2=T1 "Temperature of interval";
  output SI.SpecificHeatCapacity cp_T
    "Specific heat capacity at temperature T1, or average over T1 and T2 interval";

algorithm
  if T1 == T2 then
    cp_T := 594 + 5.86e-5*T1;
  else
    if T1 > T2 then
      cp_T := 1/(T1 - T2)*(594*(T1 - T2) + 5.86e-5/2*(T1^2 - T2^2));
    else
      cp_T := 1/(T2 - T1)*(594*(T2 - T1) + 5.86e-5/2*(T2^2 - T1^2));
    end if;
  end if;
end cp_ash;
