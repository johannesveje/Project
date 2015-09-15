within ClaRa.Components.Adapters.Check;
model TestFluidConverters
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;
  Fluid2ClaRa fluid2ClaRa
    annotation (Placement(transformation(extent={{-20,14},{0,34}})));
  Modelica.Fluid.Sources.Boundary_ph boundary(
    use_p_in=false,
    use_h_in=false,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=1000000,
    h=100e3)
    annotation (Placement(transformation(extent={{-80,14},{-60,34}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_T(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{60,14},{40,34}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-2,
    duration=0.1,
    offset=1,
    startTime=0.75) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,30})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=0.1,
    offset=1e5,
    startTime=0.25,
    height=3e6)     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,0})));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-36,34},{-56,14}})));
  Modelica.Fluid.Sensors.Temperature temperature(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-34,24},{-14,44}})));
  Visualisation.DynDisplay dynDisplay(
    varname="MSL.m_flow",
    unit="kg/s",
    x1=massFlowRate.m_flow)
    annotation (Placement(transformation(extent={{-82,0},{-46,12}})));
  Visualisation.DynDisplay dynDisplay1(
    varname="MSL.T",
    x1=temperature.T - 273.15,
    unit="°C")
    annotation (Placement(transformation(extent={{-4,34},{32,46}})));
  Visualisation.Quadruple quadruple
    annotation (Placement(transformation(extent={{26,0},{-12,10}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_T1(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{60,-34},{40,-14}})));
  Visualisation.Quadruple quadruple1
    annotation (Placement(transformation(extent={{26,-48},{-12,-38}})));
  ThermoPower2ClaRa thermoPower2ClaRa
    annotation (Placement(transformation(extent={{-20,-34},{0,-14}})));
  Visualisation.DynDisplay dynDisplay2(
    varname="MSL.T",
    unit="°C",
    x1=sensT.T - 273.15)
    annotation (Placement(transformation(extent={{-28,-18},{8,-6}})));
  Visualisation.DynDisplay dynDisplay3(
    varname="MSL.m_flow",
    unit="kg/s",
    x1=sensT.outlet.w)
    annotation (Placement(transformation(extent={{-82,-48},{-46,-36}})));
  Fundamentals.SourceP sourceP(p0=1000000)
    annotation (Placement(transformation(extent={{-80,-34},{-60,-14}})));
  Fundamentals.SensT sensT
    annotation (Placement(transformation(extent={{-44,-30},{-24,-10}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_T2(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{60,-84},{40,-64}})));
  Visualisation.Quadruple quadruple2
    annotation (Placement(transformation(extent={{26,-98},{-12,-88}})));
  ClaRa2ThermoPower thermoPower2ClaRa1
    annotation (Placement(transformation(extent={{0,-84},{-20,-64}})));
  Visualisation.DynDisplay dynDisplay4(
    unit="°C",
    varname="TP.T",
    x1=sensT1.T - 273.15)
    annotation (Placement(transformation(extent={{-24,-70},{12,-58}})));
  Visualisation.DynDisplay dynDisplay5(
    unit="kg/s",
    varname="TP.m_flow",
    x1=sensT1.inlet.w)
    annotation (Placement(transformation(extent={{-82,-98},{-46,-86}})));
  Fundamentals.SinkP   sourceP1(p0=1000000)
    annotation (Placement(transformation(extent={{-60,-84},{-80,-64}})));
  Fundamentals.SensT sensT1
    annotation (Placement(transformation(extent={{-24,-80},{-44,-60}})));
equation
  connect(ramp.y, massFlowSource_T.m_flow) annotation (Line(
      points={{79,30},{62,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, massFlowSource_T.h) annotation (Line(
      points={{79,0},{74,0},{74,24},{62,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowRate.port_a, fluid2ClaRa.port_a) annotation (Line(
      points={{-36,24},{-28,24},{-19.8,24}},
      color={0,127,255},
      smooth=Smooth.Bezier));
  connect(boundary.ports[1], massFlowRate.port_b) annotation (Line(
      points={{-60,24},{-56,24}},
      color={0,127,255},
      smooth=Smooth.Bezier));
  connect(temperature.port, massFlowRate.port_a) annotation (Line(
      points={{-24,24},{-36,24}},
      color={0,127,255},
      smooth=Smooth.Bezier));
  connect(ramp.y, massFlowSource_T1.m_flow) annotation (Line(
      points={{79,30},{72,30},{72,-18},{62,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, massFlowSource_T1.h) annotation (Line(
      points={{79,0},{74,0},{74,-24},{62,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_T.steam_a, fluid2ClaRa.steam_a) annotation (Line(
      points={{40,24},{19.975,24},{19.975,23.9975},{-0.05,23.9975}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_T1.steam_a, thermoPower2ClaRa.outlet) annotation (Line(
      points={{40,-24},{0,-24}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_T1.eye, quadruple1.eye) annotation (Line(
      points={{40,-32},{34,-32},{34,-43},{26,-43}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(massFlowSource_T.eye, quadruple.eye) annotation (Line(
      points={{40,16},{34,16},{34,5},{26,5}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(sensT.outlet, thermoPower2ClaRa.flangeA) annotation (Line(
      points={{-28,-24},{-19.8,-24}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceP.flange, sensT.inlet) annotation (Line(
      points={{-60,-24},{-40,-24}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(massFlowSource_T2.eye,quadruple2. eye) annotation (Line(
      points={{40,-82},{34,-82},{34,-93},{26,-93}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(sensT1.outlet, sourceP1.flange) annotation (Line(
      points={{-40,-74},{-60,-74}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(thermoPower2ClaRa1.flangeB, sensT1.inlet) annotation (Line(
      points={{-20,-74},{-28,-74}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(thermoPower2ClaRa1.inlet, massFlowSource_T2.steam_a) annotation (Line(
      points={{0,-74},{40,-74}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp1.y, massFlowSource_T2.h) annotation (Line(
      points={{79,0},{74,0},{74,-74},{62,-74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, massFlowSource_T2.m_flow) annotation (Line(
      points={{79,30},{72,30},{72,-68},{62,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics={  Text(
          extent={{-92,100},{106,60}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:

______________________________________________________________________________________________
"),                    Text(
          extent={{-132,104},{68,84}},
          lineColor={0,128,0},
          fontSize=31,
          textString="TESTED -- YYYY-MM-DD //XX"),Text(
          extent={{-92,60},{72,46}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________________________
Remarks: 
______________________________________________________________________________________________________________
",        fontSize=8),Text(
          extent={{-92,74},{108,56}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
Scenario:  

______________________________________________________________________________________________
")}));
end TestFluidConverters;
