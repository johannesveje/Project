within Tutorial.UnitTest;


model Mixer
  import Tutorial;
  Tutorial.Mixer mixer(redeclare package Medium =
        Modelica.Media.Water.StandardWater)                                           annotation(Placement(transformation(extent = {{-12, -6}, {8, 14}})));
  inner Modelica.Fluid.System system(energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
                                                                                                        annotation(Placement(transformation(extent = {{-94, 72}, {-74, 92}})));
  Modelica.Fluid.Sources.Boundary_ph boundary(redeclare package Medium =
        Modelica.Media.Water.StandardWater,                                                                  p = 200000, nPorts = 1) annotation(Placement(transformation(extent = {{74, -2}, {54, 18}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary1(
    nPorts=1,
    m_flow=10,
    T=285.15,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary2(
    nPorts=1,
    m_flow=10,
    T=333.15,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-56,-10},{-36,10}})));
equation
  connect(mixer.port_b, boundary.ports[1]) annotation(Line(points = {{6.4, 8}, {30, 8}, {54, 8}}, color = {0, 127, 255}));
  connect(boundary1.ports[1], mixer.port_a) annotation (Line(points={{-30,30},{
          -22,30},{-22,8},{-10,8}}, color={0,127,255}));
  connect(boundary2.ports[1], mixer.port_c) annotation (Line(points={{-36,0},{
          -24,0},{-24,2.8},{-9.2,2.8}}, color={0,127,255}));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=false,   extent={{-100,
            -100},{100,100}})));
end Mixer;
