within Grate.UnitTest;
model Bus

  Modelica.Blocks.Sources.Ramp ramp(duration=0.8, startTime=0.1)
    annotation (Placement(transformation(extent={{-70,34},{-50,54}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=0.8,
    startTime=0.1,
    height=5e3,
    offset=80e3)
    annotation (Placement(transformation(extent={{-70,-4},{-50,16}})));
  fuelInput fuelInput1 annotation (Placement(transformation(extent={{-18,12},{2,
            32}}), iconTransformation(extent={{-188,14},{-148,54}})));
  Modelica.Fluid.Sources.MassFlowSource_h boundary(
    use_m_flow_in=true,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1,
    use_h_in=false)
    annotation (Placement(transformation(extent={{12,4},{32,24}})));
  Tutorial.Valve valve(m_flow_nominal=2, dp_nominal=200000)
    annotation (Placement(transformation(extent={{44,4},{64,24}})));
  Modelica.Fluid.Sources.Boundary_pT boundary1(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=100000) annotation (Placement(transformation(extent={{76,4},{96,24}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=0.8,
    startTime=0.1,
    height=5e3,
    offset=80e3)
    annotation (Placement(transformation(extent={{-68,-42},{-48,-22}})));
  FuelSource fuelSource
    annotation (Placement(transformation(extent={{-2,-48},{18,-28}})));
equation
  connect(boundary.ports[1], valve.port_a)
    annotation (Line(points={{32,14},{38,14},{49,14}}, color={0,127,255}));
  connect(boundary1.ports[1], valve.port_b)
    annotation (Line(points={{96,14},{76,14},{59,14}}, color={0,127,255}));
  connect(fuelInput1.m_flow, boundary.m_flow_in) annotation (Line(
      points={{-7.95,22.05},{2,22},{12,22}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(fuelInput1.k, valve.opening) annotation (Line(
      points={{-7.95,22.05},{0,22.05},{0,52},{54,52},{54,19.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(ramp1.y, fuelInput1.k) annotation (Line(points={{-49,6},{-28,6},{-28,
          22.05},{-7.95,22.05}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(ramp2.y, fuelInput1.j) annotation (Line(points={{-47,-32},{-28,-32},{
          -28,22.05},{-7.95,22.05}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(ramp.y, fuelInput1.m_flow) annotation (Line(points={{-49,44},{-28,44},
          {-28,22.05},{-7.95,22.05}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end Bus;
