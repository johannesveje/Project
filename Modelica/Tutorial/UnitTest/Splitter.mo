within Tutorial.UnitTest;
model Splitter
  import Tutorial;
  Tutorial.Splitter splitter(redeclare package Medium =
        Modelica.Media.Water.StandardWater)                                                 annotation(Placement(transformation(extent = {{-8, -10}, {12, 10}})));
  inner Modelica.Fluid.System system annotation(Placement(transformation(extent = {{-86, 72}, {-66, 92}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(nPorts = 1, redeclare
      package Medium =
        Modelica.Media.Water.StandardWater,                                                                                   m_flow = 10, use_m_flow_in = true, T = 298.15) annotation(Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {2, -46})));
  Modelica.Fluid.Sources.Boundary_ph boundary1(nPorts = 1, redeclare package
      Medium =
        Modelica.Media.Water.StandardWater,                                                                               p = 200000) annotation(Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {2, 48})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary2(nPorts = 1, redeclare
      package Medium =
        Modelica.Media.Water.StandardWater,                                                                                    m_flow = -3) annotation(Placement(transformation(extent = {{74, -10}, {54, 10}})));
  Modelica.Blocks.Sources.Ramp ramp(height = 8, duration = 8, offset = 4, startTime = 1) annotation(Placement(transformation(extent = {{-74, -68}, {-54, -48}})));
equation
  connect(boundary.ports[1], splitter.port_a) annotation(Line(points = {{2, -36}, {2, -36}, {2, -8}}, color = {0, 127, 255}));
  connect(splitter.port_c, boundary2.ports[1]) annotation(Line(points = {{8.8, 0}, {8.8, 0}, {54, 0}}, color = {0, 127, 255}));
  connect(splitter.port_b, boundary1.ports[1]) annotation(Line(points = {{2, 8.4}, {2, 8.4}, {2, 38}}, color = {0, 127, 255}));
  connect(ramp.y, boundary.m_flow_in) annotation(Line(points = {{-53, -58}, {-30, -58}, {-30, -56}, {-6, -56}}, color = {0, 0, 127}));
  annotation(Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})));
end Splitter;

