within ClaRa.Components.HeatExchangers.Check;
model Test_HEXvle2vle_L3_2ph_CH_simple
 extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  HEXvle2vle_L3_2ph_CH_simple hEXvle2vle_L3_2ph_CH_simple(
    mass_struc=1,
    redeclare model WallMaterial = TILMedia.SolidTypes.TILMedia_Aluminum,
    redeclare model PressureLossTubes = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L2,
    redeclare model PressureLossShell = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticParallelZones_L3,
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2,
    redeclare model HeatTransfer_Shell = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3) annotation (Placement(transformation(extent={{-6,-72},{14,-52}})));

  Sensors.Temperature                  Temp_Shell_in
    annotation (Placement(transformation(extent={{14,-28},{34,-48}})));
  Sensors.Temperature                  Temp_Shell_out
    annotation (Placement(transformation(extent={{-34,-88},{-14,-68}})));
  Sensors.Temperature                  Temp_Tubes_in
    annotation (Placement(transformation(extent={{16,-64},{36,-84}})));
  Sensors.Temperature                  Temp_Tubes_out
    annotation (Placement(transformation(extent={{-34,-60},{-14,-40}})));
  Modelica.Blocks.Sources.Ramp h_hot1(
    duration=1500,
    startTime=5000,
    offset=3375e3,
    height=200e3)
    annotation (Placement(transformation(extent={{98,-32},{78,-12}})));
  Modelica.Blocks.Sources.Ramp m_cold1(
    duration=100,
    startTime=1000,
    offset=333,
    height=30)
    annotation (Placement(transformation(extent={{98,-64},{78,-44}})));
  Modelica.Blocks.Sources.Ramp m_hot1(
    duration=1000,
    startTime=10000,
    offset=15.4,
    height=-5)
    annotation (Placement(transformation(extent={{98,-2},{78,18}})));
  VolumesValvesFittings.Valves.ValveVLE_L1                      valve_shell1(
    openingInputIsActive=false,
    checkValve=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         m_flow_nom=if ((15) > 0) then (15) else 10, Delta_p_nom=if ((1000) <>
            0) then (1000) else 1000))
    annotation (Placement(transformation(extent={{-42,-94},{-62,-82}})));
  VolumesValvesFittings.Valves.ValveVLE_L1                      valve_tubes1(
    openingInputIsActive=false,
    checkValve=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         m_flow_nom=if ((333) > 0) then (333) else 10, Delta_p_nom=if ((1000)
             <> 0) then (1000) else 1000))
    annotation (Placement(transformation(extent={{10,-6},{-10,6}},
        rotation=0,
        origin={-56,-60})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph(h_const=300e3, p_const=2100000) annotation (Placement(transformation(extent={{-96,-98},{-76,-78}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph1(h_const=2000e3, p_const=25000000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-86,-60})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{56,-32},{36,-12}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h1(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{56,-70},{36,-50}})));
  Modelica.Blocks.Sources.Ramp h_cold4(
    duration=1000,
    offset=1111e3,
    startTime=1500,
    height=100e3)
    annotation (Placement(transformation(extent={{98,-94},{78,-74}})));
  inner SimCenter simCenter(useHomotopy=true, redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1) annotation (Placement(transformation(extent={{50,24},{70,44}})));
  Visualisation.Hexdisplay_3 hexdisplay_3_1(
    T_o={hEXvle2vle_L3_2ph_CH_simple.shell.summary.inlet[1].T,hEXvle2vle_L3_2ph_CH_simple.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_CH_simple.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_CH_simple.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_CH_simple.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_CH_simple.shell.summary.outlet[1].T},
    T_i={hEXvle2vle_L3_2ph_CH_simple.tubes.summary.inlet.T,hEXvle2vle_L3_2ph_CH_simple.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_CH_simple.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_CH_simple.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_CH_simple.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_CH_simple.tubes.summary.outlet.T},
    yps_o={0,1,1,1,1,1},
    yps_i={0,1,1,1,1,1},
    Unit="HEX Temperature in K",
    y_min=500,
    y_max=800) annotation (Placement(transformation(extent={{-94,-34},{0,54}})));
equation

  connect(valve_shell1.inlet,Temp_Shell_out. port) annotation (Line(
      points={{-42,-88},{-24,-88}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve_tubes1.inlet,Temp_Tubes_out. port) annotation (Line(
      points={{-46,-60},{-24,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(m_hot1.y, massFlowSource_h.m_flow) annotation (Line(
      points={{77,8},{64,8},{64,-16},{58,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_h.h,h_hot1. y) annotation (Line(
      points={{58,-22},{77,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pressureSink_ph.steam_a,valve_shell1. outlet) annotation (Line(
      points={{-76,-88},{-62,-88}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_ph1.steam_a,valve_tubes1. outlet) annotation (Line(
      points={{-76,-60},{-66,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_2ph_CH_simple.Out2, valve_tubes1.inlet) annotation (Line(
      points={{-6,-60},{-46,-60}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.h, h_cold4.y) annotation (Line(
      points={{58,-60},{66,-60},{66,-84},{77,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_cold1.y, massFlowSource_h1.m_flow) annotation (Line(
      points={{77,-54},{58,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temp_Shell_out.port, hEXvle2vle_L3_2ph_CH_simple.Out1) annotation (Line(
      points={{-24,-88},{4,-88},{4,-72}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_2ph_CH_simple.In1, massFlowSource_h.steam_a) annotation (Line(
      points={{4,-52.2},{4,-22},{36,-22}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_2ph_CH_simple.In2, massFlowSource_h1.steam_a) annotation (Line(
      points={{14,-59.8},{36,-59.8},{36,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_2ph_CH_simple.In1, Temp_Shell_in.port) annotation (Line(
      points={{4,-52.2},{4,-22},{24,-22},{24,-28}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_2ph_CH_simple.In2, Temp_Tubes_in.port) annotation (Line(
      points={{14,-59.8},{27,-59.8},{27,-64},{26,-64}},
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
>>check HEXvle2vle_L3_2ph_CH_simple in a number of boundary-side changes. Test robustnes and prove steady-state initialisation
     capabilities
______________________________________________________________________________________________"),
                       Text(
          extent={{-114,102},{44,84}},
          lineColor={0,128,0},
          fontSize=31,
          textString="TESTED -- 2014-10-16 //TT")}),
                                                 Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(StopTime=15000),
    __Dymola_experimentSetupOutput);
end Test_HEXvle2vle_L3_2ph_CH_simple;
