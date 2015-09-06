within Tutorial.UnitTest;
model Mixer
  import Tutorial;

  Tutorial.Mixer mixer(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-12,-6},{8,14}})));
  inner Modelica.Fluid.System system(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{-94,72},{-74,92}})));
  Modelica.Fluid.Sources.Boundary_pT boundary(
    nPorts=1,
    p=200000,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{80,-4},{60,16}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary1(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow=10,
    T=285.15) annotation (Placement(transformation(extent={{-64,0},{-44,20}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary2(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow=10,
    T=343.15)
    annotation (Placement(transformation(extent={{-64,-28},{-44,-8}})));
equation
  connect(mixer.port_b, boundary.ports[1]) annotation (Line(points={{6.4,8},{34,
          8},{34,6},{60,6}}, color={0,127,255}));
  connect(boundary1.ports[1], mixer.port_a) annotation (Line(points={{-44,10},{
          -28,10},{-28,8},{-10,8}}, color={0,127,255}));
  connect(boundary2.ports[1], mixer.port_c) annotation (Line(points={{-44,-18},
          {-26,-18},{-26,2.8},{-9.2,2.8}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end Mixer;
