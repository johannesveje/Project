within Grate.Utilities;
function cp_bm
  extends Modelica.Icons.Function;
  input SI.MolarMass MM_bm "Molar mass of the biomass";
  input SI.Temperature T1
    "Temperature of the biomass or temperature of interval";
  input SI.Temperature T2=T1 "Temperature of interval";
  output SI.SpecificHeatCapacity cp_T
    "Specific heat capacity ot temperature T1, or average over T1 and T2 interval";
  constant Modelica.Media.IdealGases.Common.DataRecord data=Modelica.Media.IdealGases.Common.SingleGasesData.C;

algorithm
  if T1 == T2 then
    cp_T := (Modelica.Media.IdealGases.Common.SingleGasesData.C.MM/MM_bm)*
      Modelica.Media.IdealGases.Common.Functions.cp_T(data, T1);
  end if;
end cp_bm;
