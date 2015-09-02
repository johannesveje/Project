within Tutorial.UnitTest;
model Pipe2
  import Tutorial;

  Tutorial.Pipe2 pipe2_1
    annotation (Placement(transformation(extent={{-14,6},{6,26}})));
  Modelica.Fluid.Sources.Boundary_ph boundary1(
    nPorts=1,
    use_p_in=false,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=100000) annotation (Placement(transformation(extent={{-36,62},{-16,82}})));
  Modelica.Fluid.Sources.Boundary_ph boundary2(
    nPorts=1,
    use_p_in=false,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=300000,
    h=2e6) annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
equation
  connect(pipe2_1.port_b, boundary1.ports[1]) annotation (Line(points={{-4,24.4},
          {2,24.4},{2,72},{-16,72}}, color={0,127,255}));
  connect(boundary2.ports[1], pipe2_1.port_a) annotation (Line(points={{-48,0},
          {-26,0},{-26,8},{-4,8}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end Pipe2;
