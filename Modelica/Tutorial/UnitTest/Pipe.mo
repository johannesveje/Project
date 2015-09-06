within Tutorial.UnitTest;
model Pipe
  import Tutorial;

  Tutorial.Pipe pipe2_1(
    p_start=300000,
    use_T_start=true,
    T_start=313.15,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-14,6},{6,26}})));
  Modelica.Fluid.Sources.Boundary_ph boundary1(
    p=500000,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
              annotation (Placement(transformation(extent={{72,40},{52,60}})));
  Modelica.Fluid.Sources.MassFlowSource_T
                                     boundary2(
    nPorts=1,
    use_T_in=true,
    m_flow=8000,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
           annotation (Placement(transformation(extent={{-52,0},{-32,20}})));
  inner Modelica.Fluid.System system(energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    annotation (Placement(transformation(extent={{-94,76},{-74,96}})));
  Modelica.Blocks.Sources.Step step(
    height=20,
    startTime=0.5,
    offset=333)
    annotation (Placement(transformation(extent={{-96,22},{-76,42}})));
equation
  connect(boundary2.ports[1], pipe2_1.port_a) annotation (Line(points={{-32,10},
          {-26,10},{-26,8},{-4,8}},color={0,127,255}));
  connect(step.y, boundary2.T_in) annotation (Line(points={{-75,32},{-66,32},{
          -66,14},{-54,14}}, color={0,0,127}));
  connect(pipe2_1.port_b, boundary1.ports[1]) annotation (Line(points={{-4,24.4},
          {24,24.4},{24,50},{52,50}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end Pipe;
