within ClaRa.Components.HeatExchangers.Check;
model Test_HEXvle2vle_L3_2ph_CU_simple
 extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  HEXvle2vle_L3_2ph_CU_simple hEXvle2vle_L3_2ph_CU_simple(
    mass_struc=1,
    redeclare model WallMaterial = TILMedia.SolidTypes.TILMedia_Aluminum,
    redeclare model PressureLossTubes = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L2,
    shell(heatSurfaceAlloc=2),
    redeclare model PressureLossShell = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3,
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2,
    redeclare model HeatTransfer_Shell = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3) annotation (Placement(transformation(extent={{14,-70},{34,-50}})));

  Sensors.Temperature                  Temp_Shell_in
    annotation (Placement(transformation(extent={{14,16},{34,36}})));
  Sensors.Temperature                  Temp_Shell_out
    annotation (Placement(transformation(extent={{-24,-86},{-4,-66}})));
  Sensors.Temperature                  Temp_Tubes_in
    annotation (Placement(transformation(extent={{32,-66},{52,-86}})));
  Sensors.Temperature                  Temp_Tubes_out
    annotation (Placement(transformation(extent={{32,-48},{52,-28}})));
  Modelica.Blocks.Sources.Ramp h_hot1(
    duration=1500,
    startTime=5000,
    offset=3375e3,
    height=200e3)
    annotation (Placement(transformation(extent={{112,-4},{92,16}})));
  Modelica.Blocks.Sources.Ramp m_cold1(
    duration=100,
    startTime=1000,
    offset=333,
    height=30)
    annotation (Placement(transformation(extent={{112,-66},{92,-46}})));
  Modelica.Blocks.Sources.Ramp m_hot1(
    duration=1000,
    startTime=10000,
    offset=15.4,
    height=-5)
    annotation (Placement(transformation(extent={{110,26},{90,46}})));
  VolumesValvesFittings.Valves.ValveVLE_L1                      valve_shell1(
    openingInputIsActive=false,
    checkValve=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         m_flow_nom=if ((15) > 0) then (15) else 10, Delta_p_nom=if ((1000) <>
            0) then (1000) else 1000))
    annotation (Placement(transformation(extent={{-30,-92},{-50,-80}})));
  VolumesValvesFittings.Valves.ValveVLE_L1                      valve_tubes1(
    openingInputIsActive=false,
    checkValve=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         m_flow_nom=if ((333) > 0) then (333) else 10, Delta_p_nom=if ((1000)
             <> 0) then (1000) else 1000))
    annotation (Placement(transformation(extent={{10,6},{-10,-6}},
        rotation=180,
        origin={58,-54})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph(h_const=300e3, p_const=2100000) annotation (Placement(transformation(extent={{-84,-96},{-64,-76}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph1(h_const=2000e3, p_const=25000000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-20})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{52,-4},{32,16}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h1(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{80,-96},{60,-76}})));
  Modelica.Blocks.Sources.Ramp h_cold4(
    duration=1000,
    offset=1111e3,
    startTime=1500,
    height=100e3)
    annotation (Placement(transformation(extent={{112,-96},{92,-76}})));
  inner SimCenter simCenter(useHomotopy=true, redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1) annotation (Placement(transformation(extent={{50,38},{70,58}})));
  Visualisation.Hexdisplay_3 hexdisplay_3_1(
    T_o={hEXvle2vle_L3_2ph_CU_simple.shell.summary.inlet[1].T,hEXvle2vle_L3_2ph_CU_simple.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_CU_simple.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_CU_simple.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_CU_simple.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_CU_simple.shell.summary.outlet[1].T},
    T_i={hEXvle2vle_L3_2ph_CU_simple.tubes.summary.inlet.T,hEXvle2vle_L3_2ph_CU_simple.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_CU_simple.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_CU_simple.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_CU_simple.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_CU_simple.tubes.summary.outlet.T},
    yps_o={0,1,1,1,1,1},
    yps_i={0,1,1,1,1,1},
    Unit="HEX Temperature in K",
    y_min=500,
    y_max=800) annotation (Placement(transformation(extent={{-90,-60},{4,28}})));
equation

  connect(valve_shell1.inlet,Temp_Shell_out. port) annotation (Line(
      points={{-30,-86},{-14,-86}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve_tubes1.inlet,Temp_Tubes_out. port) annotation (Line(
      points={{48,-54},{42,-54},{42,-48}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h.steam_a,Temp_Shell_in. port) annotation (Line(
      points={{32,6},{24,6},{24,16}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.steam_a,Temp_Tubes_in. port) annotation (Line(
      points={{60,-86},{56,-86},{56,-66},{42,-66}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(m_hot1.y, massFlowSource_h.m_flow) annotation (Line(
      points={{89,36},{84,36},{84,12},{54,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_h.h,h_hot1. y) annotation (Line(
      points={{54,6},{91,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pressureSink_ph.steam_a,valve_shell1. outlet) annotation (Line(
      points={{-64,-86},{-50,-86}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_ph1.steam_a,valve_tubes1. outlet) annotation (Line(
      points={{80,-20},{74,-20},{74,-54},{68,-54}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_2ph_CU_simple.In2, Temp_Tubes_in.port) annotation (Line(
      points={{34,-66},{42,-66}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_2ph_CU_simple.Out2, valve_tubes1.inlet) annotation (Line(
      points={{34,-54},{48,-54}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.h, h_cold4.y) annotation (Line(
      points={{82,-86},{91,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_cold1.y, massFlowSource_h1.m_flow) annotation (Line(
      points={{91,-56},{86,-56},{86,-80},{82,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temp_Shell_out.port, hEXvle2vle_L3_2ph_CU_simple.Out1) annotation (Line(
      points={{-14,-86},{24,-86},{24,-70}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_2ph_CU_simple.In1, massFlowSource_h.steam_a) annotation (Line(
      points={{24,-50},{24,6},{32,6}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false), graphics={  Text(
          extent={{-96,102},{142,56}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=11,
          textString="______________________________________________________________________________________________
PURPOSE:
>>check HEXvle2vle_L3_2ph_CU_simple in a number of boundary-side changes. Test robustnes and prove steady-state initialisation
     capabilities
______________________________________________________________________________________________"),
                       Text(
          extent={{-114,102},{44,84}},
          lineColor={0,128,0},
          fontSize=31,
          textString="TESTED -- 2014-10-16 //TT")}),
                                                 Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end Test_HEXvle2vle_L3_2ph_CU_simple;
