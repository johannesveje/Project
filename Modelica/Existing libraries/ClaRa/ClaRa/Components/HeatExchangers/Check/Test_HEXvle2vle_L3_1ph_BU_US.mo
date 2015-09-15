within ClaRa.Components.HeatExchangers.Check;
model Test_HEXvle2vle_L3_1ph_BU_US
 extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  HEXvle2vle_L3_1ph_BU_kA hEXvle2vle_L3_1ph_BU_US(
    mass_struc=1,
    redeclare model WallMaterial = TILMedia.SolidTypes.TILMedia_Aluminum,
    redeclare model PressureLossShell =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    redeclare model PressureLossTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2)
    annotation (Placement(transformation(extent={{-2,-80},{18,-60}})));

  Sensors.Temperature                  Temp_Shell_in
    annotation (Placement(transformation(extent={{10,2},{30,22}})));
  Sensors.Temperature                  Temp_Shell_out
    annotation (Placement(transformation(extent={{-32,-80},{-12,-60}})));
  Sensors.Temperature                  Temp_Tubes_in
    annotation (Placement(transformation(extent={{12,-34},{32,-14}})));
  Sensors.Temperature                  Temp_Tubes_out
    annotation (Placement(transformation(extent={{24,-76},{44,-96}})));
  Modelica.Blocks.Sources.Ramp h_hot1(
    duration=1500,
    startTime=5000,
    offset=3375e3,
    height=200e3)
    annotation (Placement(transformation(extent={{100,-8},{80,12}})));
  Modelica.Blocks.Sources.Ramp m_cold1(
    duration=100,
    startTime=1000,
    height=30,
    offset=333)
    annotation (Placement(transformation(extent={{100,-38},{80,-18}})));
  Modelica.Blocks.Sources.Ramp m_hot1(
    duration=1000,
    startTime=10000,
    offset=15.4,
    height=-5)
    annotation (Placement(transformation(extent={{100,22},{80,42}})));
  VolumesValvesFittings.Valves.ValveVLE_L1                      valve_shell1(
    openingInputIsActive=false,
    checkValve=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         m_flow_nom=if ((15) > 0) then (15) else 10, Delta_p_nom=if ((1000) <>
            0) then (1000) else 1000))
    annotation (Placement(transformation(extent={{-28,-94},{-48,-82}})));
  VolumesValvesFittings.Valves.ValveVLE_L1                      valve_tubes1(
    openingInputIsActive=false,
    checkValve=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         m_flow_nom=if ((333) > 0) then (333) else 10, Delta_p_nom=if ((1000)
             <> 0) then (1000) else 1000))
    annotation (Placement(transformation(extent={{-10,-6},{10,6}},
        rotation=0,
        origin={54,-76})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph(h_const=300e3, p_const=2100000) annotation (Placement(transformation(extent={{-82,-98},{-62,-78}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph1(h_const=2000e3, p_const=25000000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={82,-88})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{58,-8},{38,12}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h1(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{58,-44},{38,-24}})));
  Modelica.Blocks.Sources.Ramp h_cold4(
    duration=1000,
    offset=1111e3,
    height=100e3,
    startTime=1500)
    annotation (Placement(transformation(extent={{100,-68},{80,-48}})));
  inner SimCenter simCenter(useHomotopy=true, redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1) annotation (Placement(transformation(extent={{46,32},{66,52}})));
  Visualisation.Hexdisplay_3 hexdisplay_3_1(
    T_o={hEXvle2vle_L3_1ph_BU_US.shell.summary.inlet.T,hEXvle2vle_L3_1ph_BU_US.shell.summary.outlet.T,hEXvle2vle_L3_1ph_BU_US.shell.summary.outlet.T,hEXvle2vle_L3_1ph_BU_US.shell.summary.outlet.T,hEXvle2vle_L3_1ph_BU_US.shell.summary.outlet.T,hEXvle2vle_L3_1ph_BU_US.shell.summary.outlet.T},
    T_i={hEXvle2vle_L3_1ph_BU_US.tubes.summary.inlet.T,hEXvle2vle_L3_1ph_BU_US.tubes.summary.outlet.T,hEXvle2vle_L3_1ph_BU_US.tubes.summary.outlet.T,hEXvle2vle_L3_1ph_BU_US.tubes.summary.outlet.T,hEXvle2vle_L3_1ph_BU_US.tubes.summary.outlet.T,hEXvle2vle_L3_1ph_BU_US.tubes.summary.outlet.T},
    yps_o={0,1,1,1,1,1},
    yps_i={0,1,1,1,1,1},
    Unit="HEX Temperature in K",
    y_min=500,
    y_max=800) annotation (Placement(transformation(extent={{-94,-48},{0,40}})));
equation

  connect(valve_shell1.inlet,Temp_Shell_out. port) annotation (Line(
      points={{-28,-88},{-22,-88},{-22,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve_tubes1.inlet,Temp_Tubes_out. port) annotation (Line(
      points={{44,-76},{34,-76}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h.steam_a,Temp_Shell_in. port) annotation (Line(
      points={{38,2},{20,2}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.steam_a,Temp_Tubes_in. port) annotation (Line(
      points={{38,-34},{22,-34}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(m_hot1.y, massFlowSource_h.m_flow) annotation (Line(
      points={{79,32},{72,32},{72,8},{60,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_h.h,h_hot1. y) annotation (Line(
      points={{60,2},{79,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pressureSink_ph.steam_a,valve_shell1. outlet) annotation (Line(
      points={{-62,-88},{-48,-88}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_ph1.steam_a,valve_tubes1. outlet) annotation (Line(
      points={{82,-78},{82,-76},{64,-76}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_1ph_BU_US.In2, Temp_Tubes_in.port) annotation (Line(
      points={{18,-63.8},{22,-63.8},{22,-34}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_1ph_BU_US.Out2, valve_tubes1.inlet) annotation (Line(
      points={{18,-76},{44,-76}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.h, h_cold4.y) annotation (Line(
      points={{60,-34},{72,-34},{72,-58},{79,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_cold1.y, massFlowSource_h1.m_flow) annotation (Line(
      points={{79,-28},{60,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temp_Shell_out.port, hEXvle2vle_L3_1ph_BU_US.Out1) annotation (Line(
      points={{-22,-80},{-22,-88},{8,-88},{8,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_1ph_BU_US.In1, massFlowSource_h.steam_a) annotation (
      Line(
      points={{8,-60.2},{8,2},{38,2}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false), graphics={  Text(
          extent={{-94,102},{144,56}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=11,
          textString="______________________________________________________________________________________________
PURPOSE:
>>check HEXvle2vle_L3_1ph_BU_US in a number of boundary-side changes. Test robustnes and prove steady-state initialisation
     capabilities
______________________________________________________________________________________________"),
                       Text(
          extent={{-112,102},{46,84}},
          lineColor={0,128,0},
          fontSize=31,
          textString="TESTED -- 2014-10-16 //TT")}),
                                                 Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=20000,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-005),
    __Dymola_experimentSetupOutput);
end Test_HEXvle2vle_L3_1ph_BU_US;
