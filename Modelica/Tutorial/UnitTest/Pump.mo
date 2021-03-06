within Tutorial.UnitTest;
model Pump
  import Tutorial;
  Tutorial.Pump pump(
    allowFlowReversal=false,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    z=10,
    fixed_diameter=false,
    eta_pump=0.8,
    diameter_a=0.1,
    diameter_b=0.08,
    m_flow_nominal=2.5,
    head_nominal=25)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Fluid.Sources.Boundary_ph boundary(
    nPorts=1,
    h=1e5,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_p_in=false,
    p=500000) annotation (Placement(transformation(extent={{-72,-14},{-52,6}})));
  Modelica.Fluid.Sources.Boundary_ph boundary1(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=1000000) annotation (Placement(transformation(extent={{54,-12},{74,8}})));
  inner Modelica.Fluid.System system(allowFlowReversal=false, energyDynamics=
        Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-86,72},{-66,92}})));
  Modelica.Mechanics.Rotational.Sources.ConstantSpeed constantSpeed(w_fixed(
        displayUnit="rpm") = 628.31853071796)
    annotation (Placement(transformation(extent={{-32,42},{-12,62}})));
equation
  connect(boundary.ports[1], pump.port_a) annotation (Line(points={{-52,-4},{-30,
          -4},{-30,0},{-5,0}}, color={0,127,255}));
  connect(boundary1.ports[1], pump.port_b) annotation (Line(points={{74,-2},{40,
          -2},{40,-0.2},{5,-0.2}}, color={0,127,255}));
  connect(constantSpeed.flange, pump.shaft) annotation (Line(points={{-12,52},{
          -6,52},{-6,5.8},{0,5.8}}, color={0,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end Pump;

