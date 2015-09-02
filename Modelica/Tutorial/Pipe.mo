within Tutorial;
model Pipe
  package Water = Modelica.Media.Water.StandardWater;
  parameter SI.MassFlowRate m_flow_a = 10;
  parameter SI.Pressure p_a = SI.Conversions.from_bar(2);
  parameter SI.SpecificEnthalpy h_a = 1e6;
  parameter Real k=0.5/10;
  SI.MassFlowRate m_flow_b;
  SI.Pressure p_b;
  SI.SpecificEnthalpy h_b;
  SI.PressureDifference dp;
  SI.Temperature t_a;
  Water.Temperature t_b;
  Water.ThermodynamicState state_a;
equation
  m_flow_a + m_flow_b = 0;
  m_flow_a*h_a + m_flow_b*h_b = 0;
  dp = p_a - p_b;
  dp = k*m_flow_a;
  state_a = Water.setState_ph(p_a,h_a);
  t_a = Water.temperature(state_a);
  t_b = Water.temperature(Water.setState_ph(p_b,h_b));
end Pipe;
