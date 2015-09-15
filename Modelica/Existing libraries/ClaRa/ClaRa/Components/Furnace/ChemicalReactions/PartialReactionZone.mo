within ClaRa.Components.Furnace.ChemicalReactions;
partial model PartialReactionZone "Model to regard chemical reactions"
  extends ClaRa.Basics.Icons.Box;

outer parameter TILMedia.GasTypes.BaseGas flueGas;
outer ClaRa.Basics.Units.MassFraction xi_coal_in[coalType.nc - 1];
outer ClaRa.Basics.Units.MassFraction prod_comp[flueGas.nc - 1];
                                                           //Resulting composition of products
//outer ClaRa.Basics.Units.MassFraction xi_prod_comp_test[flueGas.nc-1]; //Resulting composition of products
outer ClaRa.Basics.Units.MassFraction xi_flueGas[flueGas.nc - 1];

parameter Real xi_slag = 0.1 "Fraction of Ash that leaves combustion chamber at bottom due to gravity"
                                                                              annotation (Dialog(group="Slag parameters"));

parameter ClaRa.Basics.Units.DensityVolumeSpecific xi_NOx=1000e-6 "Fraction of burned coal N being converted to NOx"
                                                       annotation(Dialog(group="Toxic substance in fluegas"));
parameter ClaRa.Basics.Units.DensityVolumeSpecific xi_CO=1000e-6 "Fraction of burned coal C being converted to CO"
                                                      annotation(Dialog(group="Toxic substance in fluegas"));

//_________/Educts\__________________
protected
Modelica.SIunits.MolarFlowRate n_flow_C;
Modelica.SIunits.MolarFlowRate n_flow_H;
Modelica.SIunits.MolarFlowRate n_flow_O;
Modelica.SIunits.MolarFlowRate n_flow_N;
Modelica.SIunits.MolarFlowRate n_flow_S;
Modelica.SIunits.MolarFlowRate n_flow_Ash;
Modelica.SIunits.MolarFlowRate n_flow_H2O;

//_________/Products\__________________
Modelica.SIunits.MolarFlowRate n_flow_CO;
Modelica.SIunits.MolarFlowRate n_flow_CO2;
Modelica.SIunits.MolarFlowRate n_flow_H2O_prod;
Modelica.SIunits.MolarFlowRate n_flow_SO2;
Modelica.SIunits.MolarFlowRate n_flow_N2;
Modelica.SIunits.MolarFlowRate n_flow_NO;

  annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                   graphics={
                       Text(
          extent={{-58,12},{62,-8}},
          lineColor={0,131,169},
          textString="Reaction Zone",
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255})}));

end PartialReactionZone;
