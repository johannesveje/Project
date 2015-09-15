within ClaRa.Components.HeatExchangers.Check;
model Test_HEXvle2vle_L3_2ph_CU_ntu
 extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  HEXvle2vle_L3_2ph_CU_ntu hEXvle2vle_L3_2ph_CU_ntu(
    mass_struc=1,
    redeclare model WallMaterial = TILMedia.SolidTypes.TILMedia_Aluminum,
    redeclare model PressureLossTubes = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L2,
    redeclare model PressureLossShell = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L3,
    shell(heatSurfaceAlloc=2),
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2,
    redeclare model HeatTransfer_Shell = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3) annotation (Placement(transformation(extent={{6,-72},{26,-52}})));

  Sensors.Temperature                  Temp_Shell_in
    annotation (Placement(transformation(extent={{26,-8},{46,12}})));
  Sensors.Temperature                  Temp_Shell_out
    annotation (Placement(transformation(extent={{-28,-88},{-8,-68}})));
  Sensors.Temperature                  Temp_Tubes_in
    annotation (Placement(transformation(extent={{26,-38},{46,-18}})));
  Sensors.Temperature                  Temp_Tubes_out
    annotation (Placement(transformation(extent={{26,-72},{46,-92}})));
  Modelica.Blocks.Sources.Ramp h_hot1(
    duration=1500,
    startTime=5000,
    offset=3375e3,
    height=200e3)
    annotation (Placement(transformation(extent={{100,10},{80,30}})));
  Modelica.Blocks.Sources.Ramp m_cold1(
    duration=100,
    startTime=1000,
    offset=333,
    height=30)
    annotation (Placement(transformation(extent={{100,-22},{80,-2}})));
  Modelica.Blocks.Sources.Ramp m_hot1(
    duration=1000,
    startTime=10000,
    offset=15.4,
    height=-5)
    annotation (Placement(transformation(extent={{100,42},{80,62}})));
  VolumesValvesFittings.Valves.ValveVLE_L1                      valve_shell1(
    openingInputIsActive=false,
    checkValve=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         m_flow_nom=if ((15) > 0) then (15) else 10, Delta_p_nom=if ((1000) <>
            0) then (1000) else 1000))
    annotation (Placement(transformation(extent={{-34,-94},{-54,-82}})));
  VolumesValvesFittings.Valves.ValveVLE_L1                      valve_tubes1(
    openingInputIsActive=false,
    checkValve=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         m_flow_nom=if ((333) > 0) then (333) else 10, Delta_p_nom=if ((1000)
             <> 0) then (1000) else 1000))
    annotation (Placement(transformation(extent={{10,-6},{-10,6}},
        rotation=180,
        origin={54,-66})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph(h_const=300e3, p_const=2100000) annotation (Placement(transformation(extent={{-88,-98},{-68,-78}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph1(h_const=2000e3, p_const=25000000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={86,-84})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{60,10},{40,30}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h1(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{64,-48},{44,-28}})));
  Modelica.Blocks.Sources.Ramp h_cold4(
    duration=1000,
    offset=1111e3,
    startTime=1500,
    height=100e3)
    annotation (Placement(transformation(extent={{100,-56},{80,-36}})));
  inner SimCenter simCenter(useHomotopy=true, redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1) annotation (Placement(transformation(extent={{40,48},{60,68}})));
  Visualisation.Hexdisplay_3 hexdisplay_3_1(
    T_o={hEXvle2vle_L3_2ph_CU_ntu.shell.summary.inlet[1].T,hEXvle2vle_L3_2ph_CU_ntu.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_CU_ntu.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_CU_ntu.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_CU_ntu.shell.summary.outlet[1].T,hEXvle2vle_L3_2ph_CU_ntu.shell.summary.outlet[1].T},
    T_i={hEXvle2vle_L3_2ph_CU_ntu.tubes.summary.inlet.T,hEXvle2vle_L3_2ph_CU_ntu.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_CU_ntu.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_CU_ntu.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_CU_ntu.tubes.summary.outlet.T,hEXvle2vle_L3_2ph_CU_ntu.tubes.summary.outlet.T},
    yps_o={0,1,1,1,1,1},
    yps_i={0,1,1,1,1,1},
    Unit="HEX Temperature in K",
    y_min=500,
    y_max=800) annotation (Placement(transformation(extent={{-90,-46},{4,42}})));
equation

  connect(valve_shell1.inlet,Temp_Shell_out. port) annotation (Line(
      points={{-34,-88},{-18,-88}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve_tubes1.inlet,Temp_Tubes_out. port) annotation (Line(
      points={{44,-66},{44,-66},{36,-66},{36,-66},{36,-66},{36,-72},{36,-72}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h.steam_a,Temp_Shell_in. port) annotation (Line(
      points={{40,20},{16,20},{16,-8},{36,-8}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.steam_a,Temp_Tubes_in. port) annotation (Line(
      points={{44,-38},{36,-38}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(m_hot1.y, massFlowSource_h.m_flow) annotation (Line(
      points={{79,52},{72,52},{72,26},{62,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_h.h,h_hot1. y) annotation (Line(
      points={{62,20},{79,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pressureSink_ph.steam_a,valve_shell1. outlet) annotation (Line(
      points={{-68,-88},{-54,-88}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_ph1.steam_a,valve_tubes1. outlet) annotation (Line(
      points={{86,-74},{86,-66},{64,-66}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_2ph_CU_ntu.In2, Temp_Tubes_in.port) annotation (Line(
      points={{26,-56},{36,-56},{36,-38}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_2ph_CU_ntu.Out2, valve_tubes1.inlet) annotation (Line(
      points={{26,-66},{44,-66}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.h, h_cold4.y) annotation (Line(
      points={{66,-38},{72,-38},{72,-46},{79,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_cold1.y, massFlowSource_h1.m_flow) annotation (Line(
      points={{79,-12},{74,-12},{74,-32},{66,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temp_Shell_out.port, hEXvle2vle_L3_2ph_CU_ntu.Out1) annotation (Line(
      points={{-18,-88},{16,-88},{16,-72}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hEXvle2vle_L3_2ph_CU_ntu.In1, massFlowSource_h.steam_a) annotation (Line(
      points={{16,-52.2},{16,20},{40,20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false), graphics={  Text(
          extent={{-96,106},{142,60}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=11,
          textString="______________________________________________________________________________________________
PURPOSE:
>>check HEXvle2vle_L3_2ph_CU_ntu in a number of boundary-side changes. Test robustnes and prove steady-state initialisation
     capabilities
______________________________________________________________________________________________"),
                       Text(
          extent={{-114,104},{44,86}},
          lineColor={0,128,0},
          fontSize=31,
          textString="TESTED -- 2014-10-16 //TT")}),
                                                 Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end Test_HEXvle2vle_L3_2ph_CU_ntu;
