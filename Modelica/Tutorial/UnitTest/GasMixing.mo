within Tutorial.UnitTest;
model GasMixing
  import Tutorial;

  Modelica.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium =
        Modelica.Media.IdealGases.MixtureGases.FlueGasSixComponents,
    m_flow=10,
    nPorts=1,
    X={0.6,0.1,0.05,0.2,0,0.05},
    T=473.15) annotation (Placement(transformation(extent={{-84,54},{-64,74}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary1(
    redeclare package Medium =
        Modelica.Media.IdealGases.MixtureGases.FlueGasSixComponents,
    m_flow=10,
    T=473.15,
    nPorts=1) annotation (Placement(transformation(extent={{-84,14},{-64,34}})));
  Modelica.Fluid.Sources.Boundary_pT boundary2(
    redeclare package Medium =
        Modelica.Media.IdealGases.MixtureGases.FlueGasSixComponents,
    nPorts=1,
    p=100000,
    T=473.15) annotation (Placement(transformation(extent={{64,30},{44,50}})));
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal(redeclare package
      Medium = Modelica.Media.IdealGases.MixtureGases.FlueGasSixComponents)
    annotation (Placement(transformation(extent={{-12,26},{8,46}})));
equation
  connect(boundary1.ports[1], teeJunctionIdeal.port_1) annotation (Line(points=
          {{-64,24},{-38,24},{-38,36},{-12,36}}, color={0,127,255}));
  connect(boundary.ports[1], teeJunctionIdeal.port_3) annotation (Line(points={
          {-64,64},{-34,64},{-34,46},{-2,46}}, color={0,127,255}));
  connect(teeJunctionIdeal.port_2, boundary2.ports[1]) annotation (Line(points=
          {{8,36},{26,36},{26,40},{44,40}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end GasMixing;
