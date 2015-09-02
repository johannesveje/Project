within Tutorial;
model Pipe2
  replaceable package Medium = Modelica.Media.Water.StandardWater constrainedby
    Modelica.Media.Interfaces.PartialMedium                                                                             annotation (choicesAllMatching=true);
  parameter SI.MassFlowRate m_flow_a = 10;
  parameter SI.Pressure p_a = SI.Conversions.from_bar(2);
  parameter SI.SpecificEnthalpy h_a = 1e6;
  parameter Real k=0.5/10;
//   SI.MassFlowRate m_flow_b;
//   SI.Pressure p_b;
//   SI.SpecificEnthalpy h_b;
   SI.PressureDifference dp;
//   SI.Temperature t_a;
//   Water.Temperature t_b;
//   Water.ThermodynamicState state_a;
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium=Medium) annotation (Placement(
        transformation(extent={{-10,-90},{10,-70}}), iconTransformation(extent={
            {-10,-90},{10,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium=Medium) annotation (Placement(
        transformation(extent={{-10,74},{10,94}}), iconTransformation(extent={{-10,
            74},{10,94}})));
equation
    port_a.m_flow + port_b.m_flow = 0;
    port_a.p - port_b.p = dp;
    port_a.m_flow*inStream(port_a.h_outflow) + port_b.m_flow*port_b.h_outflow = 0;
    port_a.m_flow*port_a.h_outflow + port_b.m_flow*inStream(port_b.h_outflow) = 0;
//   m_flow_a + m_flow_b = 0;
//   m_flow_a*h_a + m_flow_b*h_b = 0;
//   dp = p_a - p_b;
   dp = k*port_a.m_flow;
//   state_a = Water.setState_ph(p_a,h_a);
//   t_a = Water.temperature(state_a);
//   t_b = Water.temperature(Water.setState_ph(p_b,h_b));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-20,74},{20,-70}},
          lineColor={28,108,200},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255})}));
end Pipe2;
