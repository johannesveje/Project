within Grate.Utilities;
function cp_bm
  extends Modelica.Icons.Function;
  input SI.MolarMass MM_bm "Molar mass of the biomass";
  input SI.Temperature T1
    "Temperature of the biomass or temperature of interval";
  input SI.Temperature T2=T1 "Temperature of interval";
  output SI.SpecificHeatCapacity cp_T
    "Specific heat capacity at temperature T1, or average over T1 and T2 interval";
  constant Modelica.Media.IdealGases.Common.DataRecord data=Modelica.Media.IdealGases.Common.SingleGasesData.C;

algorithm
  if T1 == T2 then
    cp_T := (Modelica.Media.IdealGases.Common.SingleGasesData.C.MM/MM_bm)*
      Modelica.Media.IdealGases.Common.Functions.cp_T(data, T1);
  else
    if T1 > T2 then
      if (T1 + T2)/2 < data.Tlimit then
        cp_T := data.R*(1/(T1 - T2)*(-data.alow[1]*(T1^(-1) - T2^(-1)) + data.alow[
          2]*log(T1/T2) + data.alow[3]*(T1 - T2) + data.alow[4]/2*(T1^2 - T2^2)
           + data.alow[5]/3*(T1^3 - T2^3) + data.alow[6]/4*(T1^4 - T2^4) + data.alow[
          7]/5*(T1^5 - T2^5)));
      else
        cp_T := data.R*(1/(T1 - T2)*(-data.ahigh[1]*(T1^(-1) - T2^(-1)) + data.ahigh[
          2]*log(T1/T2) + data.ahigh[3]*(T1 - T2) + data.ahigh[4]/2*(T1^2 - T2^
          2) + data.ahigh[5]/3*(T1^3 - T2^3) + data.ahigh[6]/4*(T1^4 - T2^4) +
          data.ahigh[7]/5*(T1^5 - T2^5)));
      end if;
    else
      if (T1 + T2)/2 < data.Tlimit then
        cp_T := data.R*(1/(T2 - T1)*(-data.alow[1]*(T2^(-1) - T1^(-1)) + data.alow[
          2]*log(T2/T1) + data.alow[3]*(T2 - T1) + data.alow[4]/2*(T2^2 - T1^2)
           + data.alow[5]/3*(T2^3 - T1^3) + data.alow[6]/4*(T2^4 - T1^4) + data.alow[
          7]/5*(T2^5 - T1^5)));
      else
        cp_T := data.R*(1/(T2 - T1)*(-data.ahigh[1]*(T2^(-1) - T1^(-1)) + data.ahigh[
          2]*log(T2/T1) + data.ahigh[3]*(T2 - T1) + data.ahigh[4]/2*(T2^2 - T1^
          2) + data.ahigh[5]/3*(T2^3 - T1^3) + data.ahigh[6]/4*(T2^4 - T1^4) +
          data.ahigh[7]/5*(T2^5 - T1^5)));
      end if;
    end if;
  end if;
end cp_bm;
