within Tutorial.UnitTest;
model Valve
  import Tutorial;

  Tutorial.Valve valve(dp_nominal=400000, m_flow_nominal=10)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Fluid.Sources.Boundary_ph boundary(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    h=2e6,
    use_p_in=true,
    p=100000)
    annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));
  Modelica.Fluid.Sources.Boundary_ph boundary1(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=500000) annotation (Placement(transformation(extent={{76,-10},{56,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-1,
    offset=1,
    duration=8,
    startTime=11)
    annotation (Placement(transformation(extent={{-32,44},{-12,64}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=-8,
    offset=9,
    duration=8,
    startTime=1)
    annotation (Placement(transformation(extent={{-96,24},{-76,44}})));
protected
  Modelica.Blocks.Math.UnitConversions.From_bar from_bar
    annotation (Placement(transformation(extent={{-64,-2},{-44,18}})));
equation
  connect(boundary.ports[1], valve.port_a)
    annotation (Line(points={{-16,0},{-16,0},{-5,0}}, color={0,127,255}));
  connect(valve.port_b, boundary1.ports[1])
    annotation (Line(points={{5,0},{30,0},{56,0}}, color={0,127,255}));
  connect(ramp.y, valve.opening) annotation (Line(points={{-11,54},{-6,54},{-6,5.2},
          {0,5.2}}, color={0,0,127}));
  connect(from_bar.y, boundary.p_in)
    annotation (Line(points={{-43,8},{-38,8}}, color={0,0,127}));
  connect(ramp1.y, from_bar.u) annotation (Line(points={{-75,34},{-72,34},{-72,8},
          {-66,8}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end Valve;
