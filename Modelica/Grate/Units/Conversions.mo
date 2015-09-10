within Grate.Units;
package Conversions

   function to_kJ_kg "Convert from J/kg to kJ/kg"
     extends Modelica.SIunits.Icons.Conversion;
     input Modelica.SIunits.SpecificEnergy J_kg "J per kg value";
     output Grate.Units.LowerHeatingValue kJ_kg "kJ per kg value";
   algorithm
     kJ_kg := J_kg * 1e3;
     annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
               -100},{100,100}}), graphics={Text(
             extent={{-20,100},{-100,20}},
             lineColor={0,0,0},
             textString="K"), Text(
             extent={{100,-20},{20,-100}},
             lineColor={0,0,0},
             textString="degC")}));
   end to_kJ_kg;

   function to_MJ_kg "Convert from J/kg to MJ/kg"
     extends Modelica.SIunits.Icons.Conversion;
     input Modelica.SIunits.SpecificEnergy J_kg "J per kg value";
     output Grate.Units.LowerHeatingValue MJ_kg "MJ per kg value";
   algorithm
     MJ_kg := J_kg * 1e6;
     annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
               -100},{100,100}}), graphics={Text(
             extent={{-20,100},{-100,20}},
             lineColor={0,0,0},
             textString="K"), Text(
             extent={{100,-20},{20,-100}},
             lineColor={0,0,0},
             textString="degC")}));
   end to_MJ_kg;
end Conversions;
