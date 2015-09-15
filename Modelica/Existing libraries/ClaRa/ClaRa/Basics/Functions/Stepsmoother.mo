within ClaRa.Basics.Functions;
function Stepsmoother "Continouus interpolation for x "
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                        //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright © 2013-2015, DYNCAP research team.                                   //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  input Real func "input for that result = 1";
  input Real nofunc "input for that result = 0";
  input Real x "input for interpolation";
  output Real result;

protected
  Real m = Modelica.Constants.pi/(func - nofunc);
  Real b = -Modelica.Constants.pi/2 - m*nofunc;
  Real r_1 = tan(m*x + b);

algorithm
  result := if x >= 0.999*(func - nofunc) + nofunc and func>nofunc or x
<= 0.999*(func - nofunc) + nofunc and nofunc>func then  1 else if x <=
0.001*(func - nofunc) + nofunc and func>nofunc or x >= 0.001*(func -
nofunc) + nofunc and nofunc>func then 0 else ((0.5*(exp(
    r_1) - exp(-r_1))/(0.5*(exp(r_1) + exp(-r_1))) + 1)/2);
  annotation (derivative=Stepsmoother_der,
    Window(
      x=0.01,
      y=0.09,
      width=0.66,
      height=0.6),
    Documentation(info="<html>
<h4>StepSmoother</h4>

<p>
The function StepSmoother(x) interpolates continuously between 0 and 1 if x varies from the lower threshold n to the upper threshold f.<br>
</p>

<h5>Definition</h5>

<p>
The following shorthands are used:<br><br>
<img src=\"../figures/StepSmoother_equation.png\" ><br>
</p>



<p>
Two different cases  n &lt; f and n &gt; f are distiguished:<br><br>
<img src=\"../figures/StepSmoother_equation001.png\" ><br>
<img src=\"..figures/StepSmoother_function_plot_n_less_f.png\" ><br>
<img src=\"../figures/StepSmoother_equation003.png\" ><br>
<img src=\"..figures/StepSmoother_function_plot_n_greater_f.png\" ><br>
</p>


<h5>Numerical Prpoerties</h5>
<p>
By the properties of the tan function we have:<br><br>
<img src=\"../figures/StepSmoother_equation004.png\" ><br><br>

Due to finite numerical precision this implies   <br><br>
<img src=\"../figures/StepSmoother_equation005.png\" ><br><br>
which justifies the choice of interpolation intervals in the definition above. <br>
</p>



<h5>References:</h5>
<p>
<br>
</p>
</html>"));
end Stepsmoother;
