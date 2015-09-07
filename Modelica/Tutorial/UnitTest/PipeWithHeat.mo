within Tutorial.UnitTest;
model PipeWithHeat
  import Tutorial;

  Tutorial.PipeWithHeat pipeWithHeat(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Fluid.Sources.Boundary_ph boundary1(nPorts=1, redeclare package
      Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(
    nPorts=1,
    m_flow=10,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow fixedHeatFlow
    annotation (Placement(transformation(extent={{-46,38},{-26,58}})));
  inner Modelica.Fluid.System system(energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
  Modelica.Blocks.Sources.Step step(
    height=42e4,
    offset=42e3,
    startTime=500)
    annotation (Placement(transformation(extent={{-90,34},{-70,54}})));
equation
  connect(boundary.ports[1], pipeWithHeat.port_a)
    annotation (Line(points={{-38,0},{-22,0},{-8.2,0}}, color={0,127,255}));
  connect(pipeWithHeat.port_b, boundary1.ports[1])
    annotation (Line(points={{8.2,0},{60,0}}, color={0,127,255}));
  connect(fixedHeatFlow.port, pipeWithHeat.heatPorts_a) annotation (Line(points
        ={{-26,48},{0,48},{0,2.5},{-0.1,2.5}}, color={191,0,0}));
  connect(step.y, fixedHeatFlow.Q_flow) annotation (Line(points={{-69,44},{-56,
          44},{-56,48},{-46,48}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end PipeWithHeat;
