within Tutorial.UnitTest;
model Mixer
  import Tutorial;
  Tutorial.Mixer mixer(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-12,-6},{8,14}})));
  inner Modelica.Fluid.System system(energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    annotation (Placement(transformation(extent={{-94,72},{-74,92}})));
  Modelica.Fluid.Sources.Boundary_ph boundary(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=200000,
    nPorts=1) annotation (Placement(transformation(extent={{78,-2},{58,18}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary1(
    nPorts=1,
    m_flow=10,
    T=285.15,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary2(
    nPorts=1,
    m_flow=10,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_m_flow_in=true,
    use_T_in=false,
    T=333.15)
    annotation (Placement(transformation(extent={{-52,-10},{-32,10}})));
  Modelica.Blocks.Sources.Step step(
    height=-9,
    offset=10,
    startTime=2)
    annotation (Placement(transformation(extent={{-98,-2},{-78,18}})));
equation
  connect(mixer.port_b, boundary.ports[1])
    annotation (Line(points={{6.4,8},{22,8},{58,8}}, color={0,127,255}));
  connect(boundary1.ports[1], mixer.port_a) annotation (Line(points={{-30,30},{
          -22,30},{-22,8},{-10,8}}, color={0,127,255}));
  connect(boundary2.ports[1], mixer.port_c) annotation (Line(points={{-32,0},{-24,
          0},{-24,2.8},{-9.2,2.8}}, color={0,127,255}));
  connect(step.y, boundary2.m_flow_in)
    annotation (Line(points={{-77,8},{-64,8},{-52,8}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end Mixer;

