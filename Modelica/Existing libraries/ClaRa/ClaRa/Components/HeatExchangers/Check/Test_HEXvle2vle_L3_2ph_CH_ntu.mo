within ClaRa.Components.HeatExchangers.Check;
model Test_HEXvle2vle_L3_2ph_CH_ntu
 extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  HEXvle2vle_L3_2ph_CH_ntu hEXvle2vle_L3_2ph_CH_ntu(
    mass_struc=1,
    redeclare model WallMaterial = TILMedia.SolidTypes.TILMedia_Aluminum,
    redeclare model PressureLossTubes = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L2,
    redeclare model PressureLossShell = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L3,
    shell(heatSurfaceAlloc=2),
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2,
    redeclare model HeatTransfer_Shell = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3) annotation (Placement(transformation(extent={{-16,-72},{4,-52}})));

  Sensors.Temperature                  Temp_Shell_in
    annotation (Placement(transformation(extent={{6,-22},{26,-2}})));
  Sensors.Temperature                  Temp_Shell_out
    annotation (Placement(transformation(extent={{-40,-88},{-20,-68}})));
  Sensors.Temperature                  Temp_Tubes_in
    annotation (Placement(transformation(extent={{6,-60},{26,-40}})));
  Sensors.Temperature                  Temp_Tubes_out
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Modelica.Blocks.Sources.Ramp h_hot1(
    duration=1500,
    startTime=5000,
    offset=3375e3,
    height=200e3)
    annotation (Placement(transformation(extent={{88,-32},{68,-12}})));
  Modelica.Blocks.Sources.Ramp m_cold1(
    duration=100,
    startTime=1000,
    offset=333,
    height=30)
    annotation (Placement(transformation(extent={{86,-64},{66,-44}})));
  Modelica.Blocks.Sources.Ramp m_hot1(
    duration=1000,
    startTime=10000,
    offset=15.4,
    height=-5)
    annotation (Placement(transformation(extent={{88,0},{68,20}})));
  VolumesValvesFittings.Valves.ValveVLE_L1                      valve_shell1(
    openingInputIsActive=false,
    checkValve=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         m_flow_nom=if ((15) > 0) then (15) else 10, Delta_p_nom=if ((1000) <>
            0) then (1000) else 1000))
    annotation (Placement(transformation(extent={{-40,-94},{-60,-82}})));
  VolumesValvesFittings.Valves.ValveVLE_L1                      valve_tubes1(
    openingInputIsActive=false,
    checkValve=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         m_flow_nom=if ((333) > 0) then (333) else 10, Delta_p_nom=if ((1000)
             <> 0) then (1000) else 1000))
    annotation (Placement(transformation(extent={{10,-6},{-10,6}},
        rotation=0,
        origin={-54,-60})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph(h_const=300e3, p_const=2100000) annotation (Placement(transformation(extent={{-94,-98},{-74,-78}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph1(h_const=2000e3, p_const=25000000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-84,-60})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{50,-32},{30,-12}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h1(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{50,-70},{30,-50}})));
  Modelica.Blocks.Sources.Ramp h_cold4(
    duration=1000,
    offset=1111e3,
    startTime=1500,
    height=100e3)
    annotation (Placement(transformation(extent={{86,-96},{66,-76}})));
  inner SimCenter simCenter(useHomotopy=true, redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1) annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Visualisation.Hexdisplay_3 hexdisplay_3_1(
    T_o={hEXvle2vle_L3_2ph_CH_ntu.shell.summary.inlet[1].T,hEXvle2vle_L3_2ph_CH_ntu.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_CH_ntu.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_CH_ntu.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_CH_ntu.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_CH_ntu.shell.summary.outlet[1].T},
    T_i={hEXvle2vle_L3_2ph_CH_ntu.tubes.summary.inlet.T,hEXvle2vle_L3_2ph_CH_ntu.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_CH_ntu.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_CH_ntu.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_CH_ntu.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_CH_ntu.tubes.summary.outlet.T},
    Unit="HEX Temperature in K",
    y_min=500,
    y_max=800,
    yps_o=hEXvle2vle_L3_2ph_CH_ntu.wall.summary.eCom.z_o,
    yps_i=hEXvle2vle_L3_2ph_CH_ntu.wall.summary.eCom.z_i)
               annotation (Placement(transformation(extent={{-94,-34},{0,54}})));
equation

  connect(valve_shell1.inlet,Temp_Shell_out. port) annotation (Line(
      points={{-40,-88},{-30,-88}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve_tubes1.inlet,Temp_Tubes_out. port) annotation (Line(
      points={{-44,-60},{-30,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h.steam_a,Temp_Shell_in. port) annotation (Line(
      points={{30,-22},{16,-22}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(m_hot1.y, massFlowSource_h.m_flow) annotation (Line(
      points={{67,10},{60,10},{60,-16},{52,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_h.h,h_hot1. y) annotation (Line(
      points={{52,-22},{67,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pressureSink_ph.steam_a,valve_shell1. outlet) annotation (Line(
      points={{-74,-88},{-60,-88}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_ph1.steam_a,valve_tubes1. outlet) annotation (Line(
      points={{-74,-60},{-74,-60},{-72,-60},{-72,-60},{-64,-60},{-64,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_2ph_CH_ntu.Out2, valve_tubes1.inlet) annotation (Line(
      points={{-16,-60},{-44,-60}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.h, h_cold4.y) annotation (Line(
      points={{52,-60},{58,-60},{58,-86},{65,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_cold1.y, massFlowSource_h1.m_flow) annotation (Line(
      points={{65,-54},{52,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temp_Shell_out.port, hEXvle2vle_L3_2ph_CH_ntu.Out1) annotation (Line(
      points={{-30,-88},{-6,-88},{-6,-72}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_2ph_CH_ntu.In1, massFlowSource_h.steam_a) annotation (Line(
      points={{-6,-52.2},{-6,-42},{16,-42},{16,-22},{30,-22}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.steam_a, hEXvle2vle_L3_2ph_CH_ntu.In2) annotation (Line(
      points={{30,-60},{4,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.steam_a, Temp_Tubes_in.port) annotation (Line(
      points={{30,-60},{16,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false), graphics={  Text(
          extent={{-96,100},{142,54}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=11,
          textString="______________________________________________________________________________________________
PURPOSE:
>>check HEXvle2vle_L3_2ph_CH_ntu in a number of boundary-side changes. Test robustnes and prove steady-state initialisation
     capabilities
______________________________________________________________________________________________"),
                       Text(
          extent={{-114,102},{44,84}},
          lineColor={0,128,0},
          fontSize=31,
          textString="TESTED -- 2014-10-16 //TT")}),
                                                 Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end Test_HEXvle2vle_L3_2ph_CH_ntu;
