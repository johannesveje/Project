within ClaRa.Basics.Functions;
function Stepsmoother_der "Time derivative of continouus interpolation for x"
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

  extends Modelica.Icons.Function;
  input Real func "input for that result = 1";
  input Real nofunc "input for that result = 0";
  input Real x "input for interpolation";
  input Real dfunc "derivative of func";
  input Real dnofunc "derivative of nofunc";
  input Real dx "derivative of x";
  output Real dresult;

protected
  Real m = Modelica.Constants.pi/(func - nofunc);
  Real b = -Modelica.Constants.pi/2 - m*nofunc;
algorithm

  dresult := if x >= 0.999*(func - nofunc) + nofunc and func>nofunc or x
<= 0.999*(func - nofunc) + nofunc and nofunc>func or x <= 0.001*(func -
nofunc) + nofunc and func>nofunc or x >= 0.001*(func - nofunc) + nofunc
 and  nofunc>func then 0
 else
((1-Modelica.Math.tanh(Modelica.Math.tan(m*x+b))^2)*(1 +
Modelica.Math.tan(m*x+b)^2)*m*(dx-dnofunc+m/Modelica.Constants.pi*(dnofunc-dfunc)*(x-nofunc))) /2;
//((1-Modelica.Math.tanh(Modelica.Math.tan(m*x+b))^2)*(1 +
//Modelica.Math.tan(m*x+b)^2)*m*dx)/2;

  annotation (
    Window(
      x=0.01,
      y=0.09,
      width=0.66,
      height=0.6),
    Documentation(info="<html>
<h4>StepSmoother_der</h4>

<p>
The function StepSmoother_der  is implemented as the time derivative of StepSmoother.<br><br>

<img src=\"../figures/StepSmoother_der_equation005.png\" alt=\"\"><br></p>

</p>

<h5>Definition</h5>

<p>
The following shorthands are used:<br><br>
<img src=\"../figures/StepSmoother_der_equation003.png\" alt=\"\"><br>
</p>


<p>
Two different cases  n &lt; f and n &gt; f are distiguished:<br><br>
</p>
<img src=\"../figures/StepSmoother_der_equation002.png\" alt=\"\"><br>
<img src=\"../figures/StepSmoother_der_Function_n_less_f.png\" alt=\"\"><br><br>
<img src=\"../figures/StepSmoother_der_equation004.png\" alt=\"\"><br>
<img src=\"../figures/StepSmoother_der_Function_n_greater_f.png\" alt=\"\"><br>
</p>


<h5>References:</h5>
<p>
</p>
</html>"));
end Stepsmoother_der;
