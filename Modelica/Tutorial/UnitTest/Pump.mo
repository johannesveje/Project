within Tutorial.UnitTest;
model Pump
  import Tutorial;

  Tutorial.Pump pump(fixed_diameter=false)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Fluid.Sources.Boundary_ph boundary(
    nPorts=1,
    h=2e6,
    p=500000,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-72,-14},{-52,6}})));
  Modelica.Fluid.Sources.Boundary_ph boundary1(
    nPorts=1,
    p=1500000,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{54,-12},{74,8}})));
  Modelica.Mechanics.Rotational.Sources.ConstantSpeed constantSpeed(w_fixed(
        displayUnit="rpm") = 303.68728984701)
    annotation (Placement(transformation(extent={{-26,30},{-6,50}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-86,72},{-66,92}})));
equation
  connect(boundary.ports[1], pump.port_a) annotation (Line(points={{-52,-4},{
          -30,-4},{-30,0},{-5,0}}, color={0,127,255}));
  connect(boundary1.ports[1], pump.port_b) annotation (Line(points={{74,-2},{40,
          -2},{40,-0.2},{5,-0.2}}, color={0,127,255}));
  connect(constantSpeed.flange, pump.shaft) annotation (Line(points={{-6,40},{
          -4,40},{-4,5.8},{0,5.8}}, color={0,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end Pump;
