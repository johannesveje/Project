within ClaRa.Components.Utilities.Blocks;
block VariableGradientLimiter "Limit the range of a signal with variable limits"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                            //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright © 2013-2015, DYNCAP research team.                              //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  extends Modelica.Blocks.Interfaces.SISO;
  import ClaRa.Basics.Functions.Stepsmoother;
  parameter Real Nd(min=Modelica.Constants.small) = 10 "|Expert Settings|Input - Output Coupling|The higher Nd, the closer y follows u";

  parameter Boolean useThresh=false "|Expert Settings|Numerical Noise Suppression|Use threshould for suppression of numerical noise";
  parameter Real thres(max=1e-6)=1e-7 "If abs(u-y)< thres, y becomes a simple pass through of u. Increasing thres can improve simulation speed. However to large values can make the simulation unstable. 
     A good starting point is the choice thres = tolerance/1000."                         annotation (Dialog(enable = useThresh,tab="Expert Settings",group="Numerical Noise Suppression"));
  parameter Boolean constantLimits= false "True, if gradient limits are constant";
  parameter Real maxGrad_const = 1 "Constant max gradient" annotation (Dialog(enable = constantLimits));
  parameter Real minGrad_const = -1 "Constant min gradient" annotation (Dialog(enable = constantLimits));

  Modelica.Blocks.Interfaces.RealInput maxGrad(value=maxGrad_) if not constantLimits "Maximum Gradient allowd"
                              annotation (Placement(transformation(extent={{
            -140,60},{-100,100}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput minGrad(value=minGrad_) if not constantLimits "Minimum Gradient allowd"
                              annotation (Placement(transformation(extent={{
            -140,-100},{-100,-60}}, rotation=0)));

protected
  Real maxGrad_;
  Real minGrad_;
  Real y_aux;
equation

  if constantLimits then
    maxGrad_ = maxGrad_const;
    minGrad_ = minGrad_const;
  end if;
  der(y_aux) = smooth(1,noEvent(min(maxGrad_,max(minGrad_,(u-y_aux)*Nd))));

  if useThresh then
     y= Stepsmoother(1, 0.1, abs(der(y_aux))/thres)*y_aux + (1-Stepsmoother(1, 0.1, abs(der(y_aux))/thres))*u;
  else
    y=y_aux;
  end if;

initial equation
  y_aux=u;

  annotation (
    Documentation(info="<html>
<p>
The Limiter block passes its input signal as output signal
as long as the input is within the upper and lower
limits specified by the two additional inputs limit1 and
limit2. If this is not the case, the corresponding limit
is passed as output.
</p>
</HTML>
"), Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                    graphics={
        Line(points={{0,-90},{0,68}}, color={192,192,192}),
        Line(points={{-90,0},{68,0}}, color={192,192,192}),
        Polygon(
          points={{90,0},{68,-8},{68,8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Line(points={{-100,80},{66,80},{66,70}}, color={0,0,127}),
        Line(points={{-100,-80},{-64,-80},{-64,-70}}, color={0,0,127}),
        Polygon(points={{-64,-70},{-66,-74},{-62,-74},{-64,-70}}, lineColor={
              0,0,127}),
        Polygon(points={{66,70},{64,74},{68,74},{66,70}}, lineColor={0,0,127}),
        Polygon(
          points={{0,90},{-8,68},{8,68},{0,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-50,-70},{60,70},{12,70},{-50,-70}},
          lineColor={44,91,135},
          smooth=Smooth.None,
          fillColor={44,91,135},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-70},{-50,-70},{12,70},{80,70}}, color={0,0,0})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Line(points={{0,-60},{0,50}}, color={192,192,192}),
        Polygon(
          points={{0,60},{-5,50},{5,50},{0,60}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-60,0},{50,0}}, color={192,192,192}),
        Polygon(
          points={{60,0},{50,-5},{50,5},{60,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-48,-40},{-28,-40},{32,40},{52,40}}, color={0,0,0}),
        Text(
          extent={{46,-6},{68,-18}},
          lineColor={128,128,128},
          textString="inPort"),
        Text(
          extent={{-86,68},{-5,50}},
          lineColor={128,128,128},
          textString="outPort"),
        Text(
          extent={{-66,-40},{-26,-20}},
          lineColor={128,128,128},
          textString="uMin"),
        Text(
          extent={{30,20},{98,38}},
          lineColor={128,128,128},
          textString="uMax"),
        Line(points={{-100,80},{40,80},{40,40}}, color={0,0,255}),
        Line(points={{-100,-80},{-40,-80},{-40,-40}}, color={0,0,255}),
        Polygon(points={{40,40},{35,50},{45,50},{40,40}}, lineColor={0,0,255}),
        Polygon(points={{-40,-40},{-45,-50},{-35,-50},{-40,-40}}, lineColor={
              0,0,255})}));
end VariableGradientLimiter;
