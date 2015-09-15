within ClaRa.Components.HeatExchangers.Check;
model Test_HEXvle2vle_L3_2ph_BU_ntu
 extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  HEXvle2vle_L3_2ph_BU_ntu hEXvle2vle_L3_2ph_BU_ntu(
    mass_struc=1,
    redeclare model WallMaterial = TILMedia.SolidTypes.TILMedia_Aluminum,
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe1ph_L2,
    p_start_tubes=250e5,
    h_start_tubes=1000e3,
    m_flow_nom_tubes=333,
    p_nom_tubes=250e5,
    h_nom_tubes=1000e3,
    redeclare model PressureLossTubes = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.PressureLossCoeffcient_L2 (Delta_p_smooth=100, zeta_TOT=5),
    redeclare model HeatTransfer_Shell = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (alpha_nom={5000,10000}),
    redeclare model PressureLossShell = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3,
    z_in_shell=3,
    z_in_aux1=3,
    z_in_aux2=3,
    z_out_shell=0.01) annotation (Placement(transformation(extent={{16,-68},{36,-48}})));

  Sensors.Temperature                  Temp_Shell_in
    annotation (Placement(transformation(extent={{30,6},{50,26}})));
  Sensors.Temperature                  Temp_Shell_out
    annotation (Placement(transformation(extent={{-10,-86},{10,-66}})));
  Sensors.Temperature                  Temp_Tubes_in
    annotation (Placement(transformation(extent={{30,-68},{50,-88}})));
  Sensors.Temperature                  Temp_Tubes_out
    annotation (Placement(transformation(extent={{30,-24},{50,-4}})));
  Modelica.Blocks.Sources.Ramp h_hot1(
    duration=1500,
    startTime=5000,
    offset=3375e3,
    height=200e3)
    annotation (Placement(transformation(extent={{120,-34},{100,-14}})));
  Modelica.Blocks.Sources.Ramp m_cold1(
    duration=100,
    startTime=1000,
    height=30,
    offset=333)
    annotation (Placement(transformation(extent={{120,-66},{100,-46}})));
  Modelica.Blocks.Sources.Ramp m_hot1(
    duration=1000,
    startTime=10000,
    offset=15.4,
    height=-5)
    annotation (Placement(transformation(extent={{120,-4},{100,16}})));
  VolumesValvesFittings.Valves.ValveVLE_L1                      valve_shell1(
    openingInputIsActive=false,
    checkValve=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         m_flow_nom=if ((15) > 0) then (15) else 10, Delta_p_nom=if ((1000) <>
            0) then (1000) else 1000))
    annotation (Placement(transformation(extent={{-14,-92},{-34,-80}})));
  VolumesValvesFittings.Valves.ValveVLE_L1                      valve_tubes1(
    openingInputIsActive=false,
    checkValve=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         Delta_p_nom=1000, m_flow_nom=333))
    annotation (Placement(transformation(extent={{10,-6},{-10,6}},
        rotation=180,
        origin={54,-32})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph(h_const=300e3, p_const=21e5) annotation (Placement(transformation(extent={{-68,-96},{-48,-76}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph1(h_const=2000e3, p_const=250e5) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,-32})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{86,-10},{66,10}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h1(
    variable_m_flow=true,
    variable_h=true,
    showData=true) annotation (Placement(transformation(extent={{88,-72},{68,-52}})));
  Modelica.Blocks.Sources.Ramp h_cold4(
    duration=1000,
    offset=1111e3,
    height=100e3,
    startTime=1500)
    annotation (Placement(transformation(extent={{120,-96},{100,-76}})));
  inner SimCenter simCenter(
    useHomotopy=true,
    redeclare TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1,
    showExpertSummary=true) annotation (Placement(transformation(extent={{54,30},{74,50}})));
  Visualisation.Hexdisplay_3 hexdisplay_3_1(
    T_o={hEXvle2vle_L3_2ph_BU_ntu.shell.summary.inlet[1].T,hEXvle2vle_L3_2ph_BU_ntu.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_BU_ntu.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_BU_ntu.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_BU_ntu.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_BU_ntu.shell.summary.outlet[1].T},
    T_i={hEXvle2vle_L3_2ph_BU_ntu.tubes.summary.inlet.T,hEXvle2vle_L3_2ph_BU_ntu.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_BU_ntu.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_BU_ntu.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_BU_ntu.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_BU_ntu.tubes.summary.outlet.T},
    yps_o={0,1,1,1,1,1},
    yps_i={0,1,1,1,1,1},
    Unit="HEX Temperature in K",
    y_min=500,
    y_max=800) annotation (Placement(transformation(extent={{-92,-52},{2,36}})));
equation

  connect(valve_shell1.inlet,Temp_Shell_out. port) annotation (Line(
      points={{-14,-86},{0,-86}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve_tubes1.inlet,Temp_Tubes_out. port) annotation (Line(
      points={{44,-32},{40,-32},{40,-24}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h.steam_a,Temp_Shell_in. port) annotation (Line(
      points={{66,0},{40,0},{40,6}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.steam_a,Temp_Tubes_in. port) annotation (Line(
      points={{68,-62},{40,-62},{40,-68}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(m_hot1.y, massFlowSource_h.m_flow) annotation (Line(
      points={{99,6},{88,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_h.h,h_hot1. y) annotation (Line(
      points={{88,0},{96,0},{96,-24},{99,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pressureSink_ph.steam_a,valve_shell1. outlet) annotation (Line(
      points={{-48,-86},{-34,-86}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_ph1.steam_a,valve_tubes1. outlet) annotation (Line(
      points={{70,-32},{64,-32}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_2ph_BU_ntu.In2, Temp_Tubes_in.port) annotation (Line(
      points={{35.8,-62},{40,-62},{40,-68}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_2ph_BU_ntu.Out2, valve_tubes1.inlet) annotation (Line(
      points={{35.8,-52},{40,-52},{40,-32},{44,-32}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.h, h_cold4.y) annotation (Line(
      points={{90,-62},{96,-62},{96,-86},{99,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_cold1.y, massFlowSource_h1.m_flow) annotation (Line(
      points={{99,-56},{90,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temp_Shell_out.port, hEXvle2vle_L3_2ph_BU_ntu.Out1) annotation (Line(
      points={{0,-86},{26,-86},{26,-68}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_2ph_BU_ntu.In1, massFlowSource_h.steam_a) annotation (Line(
      points={{26,-48.2},{26,0},{66,0}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false), graphics={  Text(
          extent={{-96,96},{142,50}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=11,
          textString="______________________________________________________________________________________________
PURPOSE:
>>check HEXvle2vle_L3_2ph_BU_ntu in a number of boundary-side changes. Test robustnes and prove steady-state initialisation
     capabilities
______________________________________________________________________________________________"),
                       Text(
          extent={{-114,100},{44,82}},
          lineColor={0,128,0},
          fontSize=31,
          textString="TESTED -- 2014-10-16 //TT")}),
                                                 Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=50000,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-005),
    __Dymola_experimentSetupOutput);
end Test_HEXvle2vle_L3_2ph_BU_ntu;
