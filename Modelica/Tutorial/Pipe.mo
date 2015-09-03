within Tutorial;
model Pipe
  replaceable package Medium = Modelica.Media.Water.StandardWater constrainedby
    Modelica.Media.Interfaces.PartialMedium                                                                             annotation (choicesAllMatching=true);

  parameter Real k=0.5/10;

  SI.PressureDifference dp;

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
    dp = k*port_a.m_flow;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-20,74},{20,-70}},
          lineColor={28,108,200},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255})}));
end Pipe;
