within ClaRa.Components.HeatExchangers.Check;
model Test_HEXvle2vle_L3_1ph_BU_ntu
 extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  HEXvle2vle_L3_1ph_BU_ntu hEXvle2vle_L3_1ph_BU_ntu(
    redeclare model WallMaterial = TILMedia.SolidTypes.TILMedia_Aluminum,
    mass_struc=25000,
    redeclare model HeatTransfer_Shell = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltShell1ph_L2,
    redeclare model PressureLossShell = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    h_start_shell=2975e3,
    p_start_shell=21.05e5,
    initTypeShell=ClaRa.Basics.Choices.Init.steadyState,
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe1ph_L2,
    redeclare model PressureLossTubes = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    p_nom_tubes=250e5,
    h_nom_tubes=1130e3,
    h_start_tubes=1130e3,
    p_start_tubes=250e5,
    initTypeTubes=ClaRa.Basics.Choices.Init.steadyState,
    initWall=ClaRa.Basics.Choices.Init.steadyState) annotation (Placement(transformation(extent={{-2,-76},{18,-56}})));

  Sensors.Temperature                  Temp_Shell_in
    annotation (Placement(transformation(extent={{16,2},{36,22}})));
  Sensors.Temperature                  Temp_Shell_out
    annotation (Placement(transformation(extent={{-30,-82},{-10,-62}})));
  Sensors.Temperature                  Temp_Tubes_in
    annotation (Placement(transformation(extent={{16,-42},{36,-22}})));
  Sensors.Temperature                  Temp_Tubes_out
    annotation (Placement(transformation(extent={{16,-80},{36,-100}})));
  Modelica.Blocks.Sources.Ramp h_hot1(
    duration=1500,
    startTime=5000,
    offset=3375e3,
    height=200e3)
    annotation (Placement(transformation(extent={{100,-14},{80,6}})));
  Modelica.Blocks.Sources.Ramp m_cold1(
    duration=100,
    startTime=1000,
    height=30,
    offset=333)
    annotation (Placement(transformation(extent={{100,-46},{80,-26}})));
  Modelica.Blocks.Sources.Ramp m_hot1(
    duration=1000,
    startTime=10000,
    offset=15.4,
    height=-5)
    annotation (Placement(transformation(extent={{100,18},{80,38}})));
  VolumesValvesFittings.Valves.ValveVLE_L1                      valve_shell1(
    openingInputIsActive=false,
    checkValve=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         m_flow_nom=if ((15) > 0) then (15) else 10, Delta_p_nom=if ((1000) <>
            0) then (1000) else 1000))
    annotation (Placement(transformation(extent={{-36,-88},{-56,-76}})));
  VolumesValvesFittings.Valves.ValveVLE_L1                      valve_tubes1(
    openingInputIsActive=false,
    checkValve=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         m_flow_nom=if ((333) > 0) then (333) else 10, Delta_p_nom=if ((1000)
             <> 0) then (1000) else 1000))
    annotation (Placement(transformation(extent={{10,-6},{-10,6}},
        rotation=180,
        origin={42,-72})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph(p_const=2100000, h_const=300e3) annotation (Placement(transformation(extent={{-90,-92},{-70,-72}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph1(h_const=2000e3, p_const=25000000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={66,-92})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{60,-14},{40,6}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h1(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{62,-52},{42,-32}})));
  Modelica.Blocks.Sources.Ramp h_cold4(
    duration=1000,
    offset=1111e3,
    height=100e3,
    startTime=1500)
    annotation (Placement(transformation(extent={{100,-80},{80,-60}})));
  inner SimCenter simCenter(useHomotopy=true, redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1) annotation (Placement(transformation(extent={{40,32},{60,52}})));
  Visualisation.Hexdisplay_3 hexdisplay_3_1(
    T_o={hEXvle2vle_L3_1ph_BU_ntu.shell.summary.inlet.T,hEXvle2vle_L3_1ph_BU_ntu.shell.summary.outlet.T,hEXvle2vle_L3_1ph_BU_ntu.shell.summary.outlet.T,hEXvle2vle_L3_1ph_BU_ntu.shell.summary.outlet.T,hEXvle2vle_L3_1ph_BU_ntu.shell.summary.outlet.T,hEXvle2vle_L3_1ph_BU_ntu.shell.summary.outlet.T},
    T_i={hEXvle2vle_L3_1ph_BU_ntu.tubes.summary.inlet.T,hEXvle2vle_L3_1ph_BU_ntu.tubes.summary.outlet.T,hEXvle2vle_L3_1ph_BU_ntu.tubes.summary.outlet.T,hEXvle2vle_L3_1ph_BU_ntu.tubes.summary.outlet.T,hEXvle2vle_L3_1ph_BU_ntu.tubes.summary.outlet.T,hEXvle2vle_L3_1ph_BU_ntu.tubes.summary.outlet.T},
    yps_o={0,1,1,1,1,1},
    yps_i={0,1,1,1,1,1},
    Unit="HEX Temperature in K",
    y_min=500,
    y_max=800) annotation (Placement(transformation(extent={{-92,-48},{2,40}})));
equation

  connect(valve_shell1.inlet,Temp_Shell_out. port) annotation (Line(
      points={{-36,-82},{-20,-82}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve_tubes1.inlet,Temp_Tubes_out. port) annotation (Line(
      points={{32,-72},{26,-72},{26,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h.steam_a,Temp_Shell_in. port) annotation (Line(
      points={{40,-4},{26,-4},{26,2}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.steam_a,Temp_Tubes_in. port) annotation (Line(
      points={{42,-42},{26,-42}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(m_hot1.y, massFlowSource_h.m_flow) annotation (Line(
      points={{79,28},{72,28},{72,2},{62,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_h.h,h_hot1. y) annotation (Line(
      points={{62,-4},{79,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pressureSink_ph.steam_a,valve_shell1. outlet) annotation (Line(
      points={{-70,-82},{-56,-82}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_ph1.steam_a,valve_tubes1. outlet) annotation (Line(
      points={{66,-82},{66,-72},{52,-72}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_1ph_BU_ntu.In2, Temp_Tubes_in.port) annotation (Line(
      points={{18,-60},{26,-60},{26,-42}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_1ph_BU_ntu.Out2, valve_tubes1.inlet) annotation (Line(
      points={{18,-72},{32,-72}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.h, h_cold4.y) annotation (Line(
      points={{64,-42},{72,-42},{72,-70},{79,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_cold1.y, massFlowSource_h1.m_flow) annotation (Line(
      points={{79,-36},{64,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temp_Shell_out.port, hEXvle2vle_L3_1ph_BU_ntu.Out1) annotation (Line(
      points={{-20,-82},{8,-82},{8,-76}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_1ph_BU_ntu.In1, massFlowSource_h.steam_a) annotation (Line(
      points={{8,-56.2},{8,-4},{40,-4}},
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
>>check HEXvle2vle_L3_1ph_BU_ntu in a number of boundary-side changes. Test robustnes and prove steady-state initialisation
     capabilities
______________________________________________________________________________________________
NOTE: A number of visualisers can be displayed in the simulation window :-)
______________________________________________________________________________________________
"),                                            Text(
          extent={{-96,102},{244,82}},
          lineColor={0,128,0},
          fontSize=23,
          textString="TESTED -- 2013-03-01 //FG",
          horizontalAlignment=TextAlignment.Left)}),
                                                 Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=10000,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end Test_HEXvle2vle_L3_1ph_BU_ntu;
