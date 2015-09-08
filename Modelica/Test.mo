model Test
  replaceable package Medium = Modelica.Media.Water.StandardWater constrainedby Modelica.Media.Interfaces.PartialMedium annotation(choicesAllMatching = true);
  Modelica.Fluid.Sources.Boundary_ph boundary(nPorts = 1, redeclare package Medium = Medium) annotation(Placement(visible = true, transformation(origin = {-72, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary1(nPorts = 1, redeclare package Medium = Medium) annotation(Placement(visible = true, transformation(origin = {66, 46}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(Placement(visible = true, transformation(origin = {-72, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Tutorial.Pipe pipe1(redeclare package Medium = Medium) annotation(Placement(visible = true, transformation(origin = {-22, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(boundary.ports[1], pipe1.port_a) annotation(Line(points = {{-62, 48}, {-30, 48}}, color = {0, 127, 255}));
  connect(boundary1.ports[1], pipe1.port_b) annotation(Line(points = {{56, 46}, {20, 46}, {20, 48}, {-14, 48}}, color = {0, 127, 255}));
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), experiment(StartTime = 0, StopTime = 1000, Tolerance = 1e-06, Interval = 2));
end Test;