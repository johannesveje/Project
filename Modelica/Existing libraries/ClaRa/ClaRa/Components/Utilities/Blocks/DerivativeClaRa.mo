within ClaRa.Components.Utilities.Blocks;
block DerivativeClaRa "Derivative block ( can be adjusted to behave as ideal or approximated)"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                            //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright � 2013-2015, DYNCAP research team.                              //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  import Modelica.Blocks.Types.Init;
  parameter Real k(unit="1")=1 "Gains";
  parameter Modelica.SIunits.Time Tau(min=Modelica.Constants.small)=0.01 "Time constant (Tau>0 for approxomated derivative; Tau=0 is ideal derivative block)";
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.NoInit "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
                                                                                    annotation(Evaluate=true,
      Dialog(group="Initialization"));
  parameter Real x_start=0 "Initial or guess value of state"
    annotation (Dialog(group="Initialization"));
  parameter Real y_start=0 "Initial value of output (= state)"
    annotation(Dialog(enable=initType == Init.InitialOutput, group=
          "Initialization"));
  extends Modelica.Blocks.Interfaces.SISO;

  output Real x(start=x_start) "State of block";

protected
  parameter Boolean zeroGain = abs(k) < Modelica.Constants.eps;
initial equation
  if initType == Init.SteadyState then
    der(x) = 0;
  elseif initType == Init.InitialState then
    x = x_start;
  elseif initType == Init.InitialOutput then
    if zeroGain then
       x = u;
    else
       y = y_start;
    end if;
  end if;
equation
  der(x) = if zeroGain or Tau==0 then 0 else (u - x)/Tau;
  if zeroGain then
    y=0;
  elseif Tau==0 then
    y=k*der(u);
  else
    y =(k/Tau)*(u - x);
  end if;
  annotation (
    Documentation(info="
<HTML>
<p>
This blocks defines the transfer function between the
input u and the output y
(element-wise) as <i>approximated derivative</i>:
</p>
<pre>
             k * s
     y = ------------ * u
            Tau * s + 1
</pre>
<p>
If you would like to be able to change easily between different
transfer functions (FirstOrder, SecondOrder, ... ) by changing
parameters, use the general block <b>TransferFunction</b> instead
and model a derivative block with parameters<br>
b = {k,0}, a = {Tau, 1}.
</p>

<p>
If k=0, the block reduces to y=0.
</p>
</HTML>
"), Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-80},{-80,60},{-70,17.95},{-60,-11.46},{-50,-32.05},
              {-40,-46.45},{-30,-56.53},{-20,-63.58},{-10,-68.51},{0,-71.96},
              {10,-74.37},{20,-76.06},{30,-77.25},{40,-78.07},{50,-78.65},{60,
              -79.06}}, color={0,0,127}),
        Text(
          extent={{-30,14},{86,60}},
          lineColor={192,192,192},
          textString="DT1"),
        Text(
          extent={{-150,-150},{150,-110}},
          lineColor={0,0,0},
          textString="k=%k")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Text(
          extent={{-54,52},{50,10}},
          lineColor={0,0,0},
          textString="k s"),
        Text(
          extent={{-54,-6},{52,-52}},
          lineColor={0,0,0},
          textString="T s + 1"),
        Line(points={{-50,0},{50,0}}, color={0,0,0}),
        Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,0,255}),
        Line(points={{-100,0},{-60,0}}, color={0,0,255}),
        Line(points={{60,0},{100,0}}, color={0,0,255})}));
end DerivativeClaRa;
