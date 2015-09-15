within ClaRa.Components.VolumesValvesFittings.Pipes.Check.OnePhaseFlow;
model Test_Pipe_L1_TML_LongDistanceAndGravitationalPressureDrop
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.0.0                        //
  //                                                                           //
  // Licensed by the DYNCAP research team under Modelica License 2.            //
  // Copyright © 2013-2015, DYNCAP research team.                                   //
  //___________________________________________________________________________//
  // DYNCAP is a research project supported by the German Federal Ministry of  //
  // Economics and Technology (FKZ 03ET2009).                                  //
  // The DYNCAP research team consists of the following project partners:      //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  Modelica.Blocks.Math.MultiSum multiSum(nu=2) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={289,78})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource(
    m_flow_const=0.1,
    variable_m_flow=true,
    h_const=200e3,
    m_flow_nom=0,
    variable_h=true,
    p_nom=1000) annotation (Placement(transformation(extent={{260,-40},{240,-20}})));
  inner SimCenter simCenter(
    redeclare replaceable TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1,
    useHomotopy=false,
    useClaRaDelay=true,
    p_amb=1000000) annotation (Placement(transformation(extent={{-100,180},{-80,200}})));
  TubeBundle_L1_TML tube(
    showExpertSummary=true,
    kappa=1.25,
    showData=true,
    m_flow_nom=100,
    diameter_i=0.5,
    adiabaticWall=false,
    alpha=1000,
    f_ps=0.01,
    N_cv=10,
    length=10000,
    Delta_p_nom=1/7*1e5,
    z_in=150,
    z_out=150)           annotation (Placement(transformation(extent={{20,77},{0,97}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSink(
    variable_p=true,
    h_const=100e3,
    m_flow_nom=100,
    p_const=1000000,
    Delta_p=5e4) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-28,87})));
  Modelica.Blocks.Sources.Step outlet_pressure(
    offset=10e5,
    height=5e5,
    startTime=1000) annotation (Placement(transformation(extent={{-100,37},{-78,60}})));
  Modelica.Blocks.Sources.Ramp mass_flow_1(
    duration=1,
    height=10,
    offset=0,
    startTime=2500)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={270,130})));

  Modelica.Blocks.Sources.Ramp T_wall(
    offset=293.15,
    height=20,
    duration=3600,
    startTime=10000)
                annotation (Placement(transformation(
        extent={{-10.5,-10.5},{10.5,10.5}},
        rotation=0,
        origin={-89.5,151.5})));
  Utilities.Blocks.RealInputMultiplyer realInputMultiplyer(N=tube1.N_cv)
                                                                        annotation (Placement(transformation(extent={{-66,142},{-52,161}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinWall_L4 thinWall(
    diameter_o=0.55,
    diameter_i=0.5,
    length=tube.length,
    Delta_x=tube.Delta_x,
    N_ax=tube.N_cv,
    T_start=320*ones(tube.N_cv),
    initChoice=ClaRa.Basics.Choices.Init.noInit,
    stateLocation=1) annotation (Placement(transformation(extent={{4,107},{16,112}})));
  Modelica.Blocks.Sources.Ramp mass_flow_2(
    offset=100,
    duration=1,
    height=0,
    startTime=2500) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={310,130})));

  Modelica.Blocks.Sources.Step inlet_pressure1(
    offset=200e3,
    startTime=2000,
    height=20e3)    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={310,-30})));

  TubeBundle_L1_TML tube1(
    showExpertSummary=true,
    kappa=1.25,
    showData=true,
    m_flow_nom=100,
    diameter_i=0.5,
    adiabaticWall=false,
    alpha=1000,
    f_ps=0.01,
    N_cv=10,
    length=10000,
    Delta_p_nom=1/7*1e5,
    z_in=250,
    z_out=250)           annotation (Placement(transformation(
        extent={{10,-4},{-10,4}},
        rotation=0,
        origin={138,160})));
  TubeBundle_L1_TML tube2(
    showExpertSummary=true,
    kappa=1.25,
    showData=true,
    m_flow_nom=100,
    diameter_i=0.5,
    adiabaticWall=false,
    alpha=1000,
    f_ps=0.01,
    N_cv=10,
    length=10000,
    Delta_p_nom=1/7*1e5,
    z_in=100,
    z_out=100)           annotation (Placement(transformation(extent={{80,31},{60,51}})));
  TubeBundle_L1_TML tube3(
    showExpertSummary=true,
    kappa=1.25,
    showData=true,
    m_flow_nom=100,
    diameter_i=0.5,
    adiabaticWall=false,
    alpha=1000,
    f_ps=0.01,
    N_cv=10,
    length=10000,
    Delta_p_nom=1/7*1e5,
    z_in=250,
    z_out=100)           annotation (Placement(transformation(
        extent={{10,4},{-10,-4}},
        rotation=90,
        origin={122,110})));
  TubeBundle_L1_TML tube4(
    showExpertSummary=true,
    kappa=1.25,
    showData=true,
    m_flow_nom=100,
    diameter_i=0.5,
    adiabaticWall=false,
    alpha=1000,
    f_ps=0.01,
    N_cv=10,
    length=10000,
    Delta_p_nom=1/7*1e5,
    z_in=100,
    z_out=150)           annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={52,77})));
  TubeBundle_L1_TML tube5(
    showExpertSummary=true,
    kappa=1.25,
    showData=true,
    m_flow_nom=100,
    diameter_i=0.5,
    adiabaticWall=false,
    alpha=1000,
    f_ps=0.01,
    N_cv=10,
    length=10000,
    Delta_p_nom=1/7*1e5,
    z_in=0,
    z_out=250)           annotation (Placement(transformation(
        extent={{-10,4},{10,-4}},
        rotation=90,
        origin={170,110})));
  TubeBundle_L1_TML tube6(
    showExpertSummary=true,
    kappa=1.25,
    showData=true,
    m_flow_nom=100,
    diameter_i=0.5,
    adiabaticWall=false,
    alpha=1000,
    f_ps=0.01,
    N_cv=10,
    length=10000,
    Delta_p_nom=1/7*1e5,
    z_in=0,
    z_out=0)             annotation (Placement(transformation(
        extent={{10,-4.5},{-10,4.5}},
        rotation=0,
        origin={210,-29.5})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinWall_L4 thinWall1(
    diameter_o=0.55,
    diameter_i=0.5,
    length=tube.length,
    Delta_x=tube.Delta_x,
    N_ax=tube.N_cv,
    T_start=320*ones(tube.N_cv),
    initChoice=ClaRa.Basics.Choices.Init.noInit,
    stateLocation=1) annotation (Placement(transformation(
        extent={{-7.99999,2.49999},{8.00021,-2.49999}},
        rotation=90,
        origin={72.5,77})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinWall_L4 thinWall2(
    diameter_o=0.55,
    diameter_i=0.5,
    length=tube.length,
    Delta_x=tube.Delta_x,
    N_ax=tube.N_cv,
    T_start=320*ones(tube.N_cv),
    initChoice=ClaRa.Basics.Choices.Init.noInit,
    stateLocation=1) annotation (Placement(transformation(
        extent={{-6,-2},{6,2}},
        rotation=270,
        origin={137,110})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinWall_L4 thinWall3(
    diameter_o=0.55,
    diameter_i=0.5,
    length=tube.length,
    Delta_x=tube.Delta_x,
    N_ax=tube.N_cv,
    T_start=320*ones(tube.N_cv),
    initChoice=ClaRa.Basics.Choices.Init.noInit,
    stateLocation=1) annotation (Placement(transformation(
        extent={{-6.99985,-2.49994},{6.99985,2.49996}},
        rotation=90,
        origin={183.5,110})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinWall_L4 thinWall4(
    diameter_o=0.55,
    diameter_i=0.5,
    length=tube.length,
    Delta_x=tube.Delta_x,
    N_ax=tube.N_cv,
    T_start=320*ones(tube.N_cv),
    initChoice=ClaRa.Basics.Choices.Init.noInit,
    stateLocation=1) annotation (Placement(transformation(extent={{64,55},{76,60}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinWall_L4 thinWall5(
    diameter_o=0.55,
    diameter_i=0.5,
    length=tube.length,
    Delta_x=tube.Delta_x,
    N_ax=tube.N_cv,
    T_start=320*ones(tube.N_cv),
    initChoice=ClaRa.Basics.Choices.Init.noInit,
    stateLocation=1) annotation (Placement(transformation(extent={{132,174},{144,178}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinWall_L4 thinWall6(
    diameter_o=0.55,
    diameter_i=0.5,
    length=tube.length,
    Delta_x=tube.Delta_x,
    N_ax=tube.N_cv,
    T_start=320*ones(tube.N_cv),
    initChoice=ClaRa.Basics.Choices.Init.noInit,
    stateLocation=1) annotation (Placement(transformation(extent={{204,-17},{216,-12}})));
  TubeBundle_L1_TML tube7(
    Delta_V_flow_out(start=0),
    z_in=0,
    showExpertSummary=true,
    kappa=1.25,
    showData=true,
    m_flow_nom=100,
    diameter_i=0.5,
    adiabaticWall=false,
    alpha=1000,
    f_ps=0.01,
    length=70000,
    N_cv=70,
    z_out=150,
    Delta_p_nom=100000) annotation (Placement(transformation(extent={{82,-71},{62,-51}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSink1(
    variable_p=true,
    h_const=100e3,
    m_flow_nom=100,
    p_const=1000000,
    Delta_p=5e4) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-26,-61})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource1(
    m_flow_const=0.1,
    variable_m_flow=true,
    h_const=200e3,
    m_flow_nom=0,
    variable_h=true,
    p_nom=1000) annotation (Placement(transformation(extent={{260,-99},{240,-80}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinWall_L4 thinWall7(
    diameter_o=0.55,
    diameter_i=0.5,
    initChoice=ClaRa.Basics.Choices.Init.noInit,
    stateLocation=1,
    N_ax=tube7.N_cv,
    length=tube7.length,
    T_start=320*ones(tube7.N_cv),
    Delta_x=tube7.Delta_x) annotation (Placement(transformation(extent={{66,-43},{78,-38}})));
  Modelica.Blocks.Math.MultiSum multiSum1(
                                         nu=2) annotation (Placement(
        transformation(
        extent={{4.5,-5},{-4.5,5}},
        rotation=180,
        origin={-58.5,81})));
  Modelica.Blocks.Sources.Step outlet_pressure2(
    height=-5e5,
    offset=0,
    startTime=1002) annotation (Placement(transformation(extent={{-100,100},{-78,121}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature1[tube1.N_cv] annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={126,190})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature2[tube1.N_cv] annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={54,-29})));
equation
  connect(multiSum.y, massFlowSource.m_flow) annotation (Line(
      points={{289,70.98},{289,-24},{262,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.u[1], mass_flow_1.y) annotation (Line(
      points={{291.1,84},{291.1,130},{281,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSink.steam_a, tube.outlet) annotation (Line(
      points={{-18,87},{0,87}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_wall.y, realInputMultiplyer.Signal) annotation (Line(
      points={{-77.95,151.5},{-66.42,151.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thinWall.innerPhase, tube.heat) annotation (Line(
      points={{10,107},{10,95}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(mass_flow_2.y, multiSum.u[2]) annotation (Line(
      points={{299,130},{299,84},{286.9,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource.h, inlet_pressure1.y) annotation (Line(
      points={{262,-30},{299,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tube.inlet, tube4.outlet) annotation (Line(
      points={{20,87},{52,87}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tube4.inlet, tube2.outlet) annotation (Line(
      points={{52,67},{52,41},{60,41}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tube2.inlet, tube3.outlet) annotation (Line(
      points={{80,41},{122,41},{122,100}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tube3.inlet, tube1.outlet) annotation (Line(
      points={{122,120},{122,160},{128,160}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tube1.inlet, tube5.outlet) annotation (Line(
      points={{148,160},{170,160},{170,120}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tube5.inlet, tube6.outlet) annotation (Line(
      points={{170,100},{170,-29.5},{200,-29.5}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tube6.inlet, massFlowSource.steam_a) annotation (Line(
      points={{220,-29.5},{228,-29.5},{228,-30},{240,-30}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(thinWall1.innerPhase, tube4.heat) annotation (Line(
      points={{70,77.0001},{60,77.0001},{60,77}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(thinWall4.innerPhase, tube2.heat) annotation (Line(
      points={{70,55},{70,49}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tube5.heat, thinWall3.outerPhase) annotation (Line(
      points={{173.2,110},{181,110}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(thinWall6.innerPhase, tube6.heat) annotation (Line(
      points={{210,-17},{210,-25.9}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSink1.steam_a, tube7.outlet) annotation (Line(
      points={{-16,-61},{62,-61}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tube7.inlet, massFlowSource1.steam_a) annotation (Line(
      points={{82,-61},{158,-61},{158,-89.5},{240,-89.5}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(inlet_pressure1.y, massFlowSource1.h) annotation (Line(
      points={{299,-30},{294,-30},{294,-89.5},{262,-89.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.y, massFlowSource1.m_flow) annotation (Line(
      points={{289,70.98},{289,-83.8},{262,-83.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thinWall7.innerPhase, tube7.heat) annotation (Line(
      points={{72,-43},{72,-53}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(outlet_pressure.y, multiSum1.u[1]) annotation (Line(
      points={{-76.9,48.5},{-76.9,79.25},{-63,79.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(outlet_pressure2.y, multiSum1.u[2]) annotation (Line(
      points={{-76.9,110.5},{-76.9,84},{-77,84},{-77,82.75},{-63,82.75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum1.y, massFlowSink.p) annotation (Line(
      points={{-53.235,81},{-38,81}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum1.y, massFlowSink1.p) annotation (Line(
      points={{-53.235,81},{-44,81},{-44,-67},{-36,-67}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tube3.heat, thinWall2.innerPhase) annotation (Line(
      points={{125.2,110},{135,110}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(thinWall5.innerPhase, tube1.heat) annotation (Line(
      points={{138,174},{138,163.2}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(prescribedTemperature1.port, thinWall5.outerPhase) annotation (Line(
      points={{132,190},{138,190},{138,178}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[1].port, thinWall7.outerPhase[21]) annotation (Line(
      points={{60,-29},{72,-29},{72,-38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[2].port, thinWall7.outerPhase[22]) annotation (Line(
      points={{60,-29},{72,-29},{72,-38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[3].port, thinWall7.outerPhase[23]) annotation (Line(
      points={{60,-29},{72,-29},{72,-38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[4].port, thinWall7.outerPhase[24]) annotation (Line(
      points={{60,-29},{72,-29},{72,-38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[5].port, thinWall7.outerPhase[25]) annotation (Line(
      points={{60,-29},{72,-29},{72,-38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[6].port, thinWall7.outerPhase[26]) annotation (Line(
      points={{60,-29},{72,-29},{72,-38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[7].port, thinWall7.outerPhase[27]) annotation (Line(
      points={{60,-29},{72,-29},{72,-38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[8].port, thinWall7.outerPhase[28]) annotation (Line(
      points={{60,-29},{72,-29},{72,-38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[9].port, thinWall7.outerPhase[29]) annotation (Line(
      points={{60,-29},{72,-29},{72,-38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[10].port, thinWall7.outerPhase[30]) annotation (Line(
      points={{60,-29},{72,-29},{72,-38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(realInputMultiplyer.y, prescribedTemperature1.T) annotation (Line(
      points={{-53.4,151.5},{72,151.5},{72,190},{118.8,190}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realInputMultiplyer.y, prescribedTemperature2.T) annotation (Line(
      points={{-53.4,151.5},{-2,151.5},{-2,-29},{46.8,-29}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{320,200}}),
                        graphics),
    experiment(
      StopTime=20000,
      __Dymola_NumberOfIntervals=50000,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(
      derivatives=false,
      equidistant=false,
      events=false),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            true)));
end Test_Pipe_L1_TML_LongDistanceAndGravitationalPressureDrop;
