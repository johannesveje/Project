within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Channel;
package Overall "FluidDissipation: Overall regime of channel"
extends
  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Channel.BaseChannelPL;


redeclare function extends massFlowRate_dp

  //input records for channel function
  input
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Channel.Overall.PressureLossInput_con
    IN_con annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  input
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Channel.Overall.PressureLossInput_var
    IN_var annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  input SI.Pressure dp "Pressure loss" annotation (Dialog(tab="Input"));

algorithm
  M_FLOW := FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_MFLOW(
    IN_con,
    IN_var,
    dp);

  annotation (Documentation(info="<html>
<p>
In this package the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_MFLOW\"> dp_internalFlowOverall </a> of a channel out of the <b> FluidDissipation </b> library is  
implemented into an usable form for the replaceable pressure loss calculations of a <a  
href=\"Modelica://FluidDissipation.Examples.Applications.PressureLoss.Channel\"> channel </a> with the <b>Modelica.Fluid </b>  
library as thermo-hydraulic framework. 
</p>
 
<p>
This function executes the calculation of a channel function at the overall flow regime for an incompressible and single-phase  
fluid flow. Here the mass flow rate (M_FLOW) is calculated in dependence of a known  
pressure loss (dp).
</p>
 
<p>
A test case ready for the simulation of a Modelica.Fluid channel function can be found in <a  
href=\"Modelica://FluidDissipation.Examples.TestCases.PressureLoss.Channel\"> Test: channel functions </a>.
</p>
 
</html>
"));
end massFlowRate_dp;

end Overall;
