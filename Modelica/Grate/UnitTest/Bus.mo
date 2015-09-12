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
  Modelica.Fluid.Sources.MassFlowSource_h boundary(
    nPorts=1,
    use_h_in=false,
    redeclare package Medium =
        Modelica.Media.IdealGases.MixtureGases.FlueGasSixComponents,
    use_m_flow_in=false)
    annotation (Placement(transformation(extent={{24,4},{44,24}})));
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
  Fuels.FuelSource fuelSource
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Evaporation evaporation
    annotation (Placement(transformation(extent={{-4,-12},{16,8}})));
  CombustionSystem combustionSystem
    annotation (Placement(transformation(extent={{-82,72},{-62,92}})));
  Fuels.BasePackage.fuelInput fuelInput annotation (Placement(transformation(
          extent={{8,48},{28,68}}), iconTransformation(extent={{-220,44},{-180,
            84}})));
equation
  connect(boundary.ports[1], valve.port_a)
    annotation (Line(points={{44,14},{44,14},{49,14}}, color={0,127,255}));
  connect(boundary1.ports[1], valve.port_b)
    annotation (Line(points={{96,14},{76,14},{59,14}}, color={0,127,255}));
  connect(fuelSource.fuelOutput1, evaporation.fuelInput) annotation (Line(
      points={{-21,10},{-6,10},{-6,-2},{-3,-2}},
      color={255,204,51},
      thickness=0.5));
  connect(fuelSource.fuelOutput1, fuelInput) annotation (Line(
      points={{-21,10},{-2,10},{-2,58},{18,58}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})));
end Bus;
