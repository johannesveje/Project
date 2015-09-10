within Tutorial;
model Valve
  parameter SI.PressureDifference dp_nominal
    "Nominal pressure difference at full opening";
  replaceable package Medium = Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialMedium annotation (
      choicesAllMatching=true);
  parameter SI.MassFlowRate m_flow_nominal "Nominal flow rate at full opening";
  final parameter Real k=m_flow_nominal/dp_nominal;
  SI.PressureDifference dp;
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{-60,-10},{-40,10}}),
        iconTransformation(extent={{-60,-10},{-40,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{40,-10},{60,10}}),
        iconTransformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Interfaces.RealInput opening(min=0, max=1)
    "1 is full open, 0 is fully closed " annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={0,52})));
equation
  port_a.m_flow + port_b.m_flow = 0;
  dp = port_a.p - port_b.p;
  port_a.m_flow = dp*k*opening;
  port_a.m_flow*inStream(port_a.h_outflow) + port_b.m_flow*port_b.h_outflow = 0;
  port_a.m_flow*port_a.h_outflow + port_b.m_flow*inStream(port_b.h_outflow) = 0;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{-40,40},{-40,40}},
          lineColor={0,0,127},
          lineThickness=1,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,0},{-40,40},{-40,-40},{0,0}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,0},{40,40},{40,-40},{0,0}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,0},{0,40}},
          color={0,0,127},
          arrow={Arrow.Filled,Arrow.None},
          thickness=1)}));
end Valve;

