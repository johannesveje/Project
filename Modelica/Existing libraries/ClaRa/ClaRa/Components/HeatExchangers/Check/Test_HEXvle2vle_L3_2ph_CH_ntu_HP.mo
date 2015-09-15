within ClaRa.Components.HeatExchangers.Check;
model Test_HEXvle2vle_L3_2ph_CH_ntu_HP "A test scenario for a HP rreheater "
 extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;
  parameter String TablePath=
      "../DYNCAPGit/ClaRa/TableBase/Val_WDK_Ausgabe22.3-23.03.mif";

  BoundaryConditions.BoundaryVLE_pTxi steamInlet(variable_p=true, variable_T=true) annotation (Placement(transformation(extent={{76,2},{56,22}})));
  BoundaryConditions.BoundaryVLE_Txim_flow feedwaterInlet(variable_T=true, variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={76,-50})));
  BoundaryConditions.BoundaryVLE_phxi feedwaterOutlet(variable_p=true, h_const=1200e3) annotation (Placement(transformation(extent={{-50,-60},{-30,-40}})));
  BoundaryConditions.BoundaryVLE_phxi condensateOutlet(h_const=1200e3, variable_p=true) annotation (Placement(transformation(extent={{-52,-94},{-32,-74}})));
  inner SimCenter simCenter(redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid2, redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1) annotation (Placement(transformation(extent={{56,42},{76,62}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1     valve_TubeSide(
    checkValve=false, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         m_flow_nom=if ((360) > 0) then (360) else 10, Delta_p_nom=if ((100000)
             <> 0) then (100000) else 1000))
                       annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=180,
        origin={14,-50})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1     valve_shellSide(
    checkValve=true,
    openingInputIsActive=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         m_flow_nom=if ((32) > 0) then (32) else 10, Delta_p_nom=if ((0.2e5)
             <> 0) then (0.2e5) else 1000))
                      annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=180,
        origin={14,-84})));
  Modelica.Blocks.Sources.RealExpression PH_A7_absLevel2(y=PH_A7.shell.phaseBorder.level_abs) annotation (Placement(transformation(extent={{76,-78},{56,-64}})));
  Modelica.Blocks.Continuous.LimPID PI(
    Td=1,
    yMax=1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=10/PI.k,
    yMin=0.01,
    k=0.1,
    y_start=0.8,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput)
           annotation (Placement(transformation(extent={{40,-76},{30,-66}})));
  Visualisation.Quadruple quadruple
    annotation (Placement(transformation(extent={{-2,-71},{-22,-61}})));
  Visualisation.Quadruple quadruple1
    annotation (Placement(transformation(extent={{-2,-99},{-22,-89}})));
  Modelica.Blocks.Sources.RealExpression PH_A7_absLevel1(y=1.2)
    annotation (Placement(transformation(extent={{76,-88},{56,-74}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1
    valve_shellSide1(
    checkValve=true,
    openingInputIsActive=false,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         m_flow_nom=if ((32) > 0) then (32) else 10, Delta_p_nom=if ((200000)
             <> 0) then (200000) else 1000))
                       annotation (Placement(transformation(
        extent={{10,6},{-10,-6}},
        rotation=90,
        origin={50,-18})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-10,
    duration=10,
    startTime=1000,
    offset=586)
    annotation (Placement(transformation(extent={{100,2},{90,12}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=-2e5,
    duration=100,
    startTime=5000,
    offset=45e5)
    annotation (Placement(transformation(extent={{100,18},{90,28}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=10,
    height=-2e5,
    startTime=8000,
    offset=40e5)
    annotation (Placement(transformation(extent={{-100,-82},{-90,-72}})));
  Modelica.Blocks.Sources.Ramp ramp3(
    duration=10,
    height=-2e5,
    startTime=10000,
    offset=247e5)
    annotation (Placement(transformation(extent={{-100,-48},{-90,-38}})));
  Modelica.Blocks.Sources.Ramp ramp4(
    duration=10,
    height=+20,
    startTime=12000,
    offset=490)
    annotation (Placement(transformation(extent={{72,-16},{82,-6}})));
  Modelica.Blocks.Sources.Ramp ramp5(
    duration=10,
    height=+20,
    startTime=14000,
    offset=363)
    annotation (Placement(transformation(extent={{72,-34},{82,-24}})));
  HEXvle2vle_L3_2ph_CH_ntu PH_A7(
    redeclare model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    length=14,
    diameter=2.6,
    diameter_i=18.9e-3,
    diameter_o=26.9e-3,
    N_passes=3,
    T_w_tube_start=ones(3)*(211 + 273),
    T_w_shell_start=ones(3)*(256 + 273),
    staggeredAlignment=true,
    Delta_z_par=1.5*PH_A7.diameter_o,
    Delta_z_ort=1.5*PH_A7.diameter_o,
    z_out_shell=0,
    z_in_tubes=0.1,
    z_in_shell=13.5,
    h_start_tubes=1161e3,
    p_start_tubes=260e5,
    p_start_shell=43.02e5,
    length_tubes=1900/(Modelica.Constants.pi*(22.67e-3)*PH_A7.N_tubes*PH_A7.N_passes),
    level_rel_start=0.085,
    redeclare model PressureLossTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2,
    z_out_tubes=PH_A7.length_tubes - 0.1,
    Q_flow_nom=1e9,
    N_tubes=700,
    initTypeWall=ClaRa.Basics.Choices.Init.noInit,
    Tau_cond=0.1,
    Tau_evap=0.1,
    alpha_ph=4000,
    initTypeShell=ClaRa.Basics.Choices.Init.steadyDensity,
    redeclare model HeatTransferTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2 (                      alpha_nom=4000),
    initTypeTubes=ClaRa.Basics.Choices.Init.noInit,
    redeclare function HeatCapacityAveraging =
        ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Functions.InputOnly,
    orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
    redeclare model HeatTransfer_Shell =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (             alpha_nom=
                                                                                            {6000,6000}),
    redeclare model PressureLossShell =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3,
    showExpertSummary=true) annotation (Placement(transformation(extent={{40,-62},{60,-42}})));

  Visualisation.Hexdisplay_3 hexdisplay_3_1(
    T_o={PH_A7.shell.summary.inlet[1].T,PH_A7.shell.summary.outlet[1].T,PH_A7.shell.summary.outlet[1].T,PH_A7.shell.summary.outlet[1].T,PH_A7.shell.summary.outlet[1].T,PH_A7.shell.summary.outlet[1].T},
    T_i={PH_A7.tubes.summary.inlet.T,PH_A7.tubes.summary.outlet.T,PH_A7.tubes.summary.outlet.T,PH_A7.tubes.summary.outlet.T,PH_A7.tubes.summary.outlet.T,PH_A7.tubes.summary.outlet.T},
    yps_o={0,1,1,1,1,1},
    yps_i={0,1,1,1,1,1},
    Unit="HEX Temperature in K",
    y_min=500,
    y_max=800) annotation (Placement(transformation(extent={{-66,-32},{28,56}})));
equation
  connect(valve_shellSide.outlet, condensateOutlet.steam_a) annotation (Line(
      points={{4,-84},{-32,-84}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(valve_TubeSide.outlet, feedwaterOutlet.steam_a) annotation (Line(
      points={{4,-50},{-30,-50}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PI.y, valve_shellSide.opening_in) annotation (Line(
      points={{29.5,-71},{14,-71},{14,-75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PH_A7_absLevel2.y, PI.u_s) annotation (Line(
      points={{55,-71},{52,-71},{48,-71},{41,-71}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PH_A7_absLevel1.y, PI.u_m) annotation (Line(
      points={{55,-81},{35,-81},{35,-77}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(steamInlet.steam_a, valve_shellSide1.inlet) annotation (Line(
      points={{56,12},{50,12},{50,-8}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, steamInlet.T) annotation (Line(
      points={{89.5,7},{84,7},{84,12},{76,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, steamInlet.p) annotation (Line(
      points={{89.5,23},{84,23},{84,22},{84,22},{84,18},{76,18}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(ramp2.y, condensateOutlet.p) annotation (Line(
      points={{-89.5,-77},{-52,-77},{-52,-78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valve_TubeSide.inlet, PH_A7.Out2) annotation (Line(
      points={{24,-50},{40,-50}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PH_A7.In2, feedwaterInlet.steam_a) annotation (Line(
      points={{60,-50},{66,-50}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve_shellSide.inlet, PH_A7.Out1) annotation (Line(
      points={{24,-84},{50,-84},{50,-62}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve_shellSide1.outlet, PH_A7.In1) annotation (Line(
      points={{50,-28},{50,-42.2}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp4.y, feedwaterInlet.T) annotation (Line(
      points={{82.5,-11},{98,-11},{98,-50},{88,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(feedwaterInlet.m_flow, ramp5.y) annotation (Line(
      points={{88,-56},{94,-56},{94,-29},{82.5,-29}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(feedwaterOutlet.p, ramp3.y) annotation (Line(
      points={{-50,-44},{-50,-43},{-89.5,-43}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valve_shellSide.eye, quadruple1.eye) annotation (Line(
      points={{4,-88},{2,-88},{2,-94},{-2,-94}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(valve_TubeSide.eye, quadruple.eye) annotation (Line(
      points={{4,-54},{2,-54},{2,-66},{-2,-66}},
      color={190,190,190},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false),graphics={   Text(
          extent={{32,92},{-96,66}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=11,
          textString="______________________________________________________________________________________________
PURPOSE:
>>check HEXvle2vle_L3_2ph_CH_ntu_HP in a number of boundary-side changes. Test robustnes and prove steady-state initialisation
     capabilities
______________________________________________________________________________________________"),
                       Text(
          extent={{-114,102},{44,84}},
          lineColor={0,128,0},
          fontSize=31,
          textString="TESTED -- 2014-10-16 //TT")}),
    experiment(
      StopTime=50000,
      __Dymola_NumberOfIntervals=5000,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equdistant=false),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end Test_HEXvle2vle_L3_2ph_CH_ntu_HP;
