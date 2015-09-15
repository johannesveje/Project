within ClaRa.StaticCycles.Check;
model InitSteamCycle_Rostock_3_1 "Helps you to find reasonable start values for steam cycles"
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
  extends ClaRa.Basics.Icons.Init;
  import TILMedia.VLEFluidFunctions.*;
  import SI = ClaRa.Basics.Units;
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));

//__________________global parameter_______________________
  inner parameter Real P_target_= 1 "Value of load in p.u."    annotation(Dialog(group="Global parameter"));
  inner parameter SI.MassFlowRate m_flow_nom=417 "Feedwater massflow rate at nominal point" annotation (Dialog(group="Global parameter"));
  parameter SI.Temperature T_LS_nom=823 "Live steam temperature at nominal point" annotation (Dialog(group="Global parameter"));
  parameter SI.Temperature T_RS_nom=833 "Reheated steam temperature at nominal point" annotation (Dialog(group="Global parameter"));
  parameter String mediumName = "R718" annotation(Dialog(group="Global parameter"));
//  // parameter SI.HeatFlowRate Q_nom=boiler.m_flow_feed*(boiler.h_LS_out - boiler.h_LS_in) + boiler.m_flow_cRH*(boiler.h_RS_out - boiler.h_RS_in)
//     "Nominal heat flow rate"
//     annotation (Dialog(group="Global parameter"));
  final parameter SI.MassFlowRate m_flow_FW=m_flow_nom*P_target_ "Feedwater massflow rate at nominal point" annotation (Dialog(group="Global parameter"));

//____________________boiler parameter_____________________
//  parameter ClaRa.Basics.Units.HeatFlowRate Q_nom = 1150e6 annotation(Dialog(tab="Boiler"));
  parameter SI.Pressure p_LS_out_nom=250.2e5 "Live steam pressure at nomninal point" annotation (Dialog(tab="Boiler"));
  parameter SI.Pressure p_RS_out_nom=51e5 "Reaheated steam pressure at nomninal point" annotation (Dialog(tab="Boiler"));
  parameter SI.Pressure dp_LS_nom=89e5 "Live steam pressure loss in boiler at nomninal point" annotation (Dialog(tab="Boiler"));
  parameter SI.Pressure dp_RS_nom=5e5 "Reheated steam pressure loss in boiler at nomninal point" annotation (Dialog(tab="Boiler"));

  parameter Real CharLine_dpHP_mLS_[:,:]=[0,0; 0.1,0.01; 0.2,0.04; 0.3,0.09; 0.4,
      0.16; 0.5,0.25; 0.6,0.36; 0.7,0.49; 0.8,0.64; 0.9,0.81; 1,1] "Characteristic line of pressure drop as function of mass flow rate"
                                                                         annotation(Dialog(group = "CharLines", tab="Boiler"));
  parameter Real CharLine_dpIP_mRS_[:,:]=[0,0; 0.1,0.01; 0.2,0.04; 0.3,0.09; 0.4,
      0.16; 0.5,0.25; 0.6,0.36; 0.7,0.49; 0.8,0.64; 0.9,0.81; 1,1] "Characteristic line of pressure drop as function of mass flow rate"
                                                                         annotation(Dialog(group = "CharLines",  tab="Boiler"));

//___________________pump parameter________________________
parameter Real efficiency_Pump_FW=1 "Efficiency of freshwater pump" annotation(Dialog(tab="Pumps"));
parameter Real efficiency_Pump_cond=1 "Efficiency of condenser pump" annotation(Dialog(tab="Pumps"));
parameter Real efficiency_Pump_preheat=1 "Efficiency of preheater pump" annotation(Dialog(tab="Pumps"));
//________________turbine parameter________________________
parameter Real efficiency_Turb_HP=1 "Efficiency of turbine" annotation(Dialog(tab= "Turbines"));
parameter Real efficiency_Turb_LP=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
//__________________reheater parameter____________________
parameter SI.Pressure p_shell_preheater=20700 "Pressure on preheater shell side"
                                                                                annotation(Dialog(tab="Heat exchangers",group="Preheater"));
// __________________Feewatertank parameter________________
parameter SI.Pressure p_FWT=14e5 "Feedwater tank pressure" annotation(Dialog(tab="Heat exchangers",group="Feedwatertank"));
//___________________condenser parameter___________________
  parameter SI.Pressure p_condenser=4000 "Condenser Pressure" annotation (Dialog(tab="Heat exchangers",group="Condenser"));
//________________ valves parameter________________________
parameter ClaRa.Basics.Units.Pressure valve_IP_dp_nominal=1e5  annotation(Dialog(tab="Valves"));
parameter ClaRa.Basics.Units.Pressure valve_LP1_dp_nominal=0.001e5   annotation(Dialog(tab="Valves"));

//parameter Real efficiency_Turb_LP2=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));

  ClaRa.StaticCycles.Pump_real
       pump_fw(efficiency=efficiency_Pump_FW)
                                   annotation (Placement(transformation(extent={{-104,
            -128},{-144,-88}})));
  ClaRa.StaticCycles.Turbine turbine_HP(
    efficiency=efficiency_Turb_HP) annotation (Placement(transformation(extent={{-150,
            114},{-120,174}})));
  ClaRa.StaticCycles.Turbine turbine_LP(
    efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{-76,114},
            {-46,174}})));
  ClaRa.StaticCycles.Boiler boiler(
    p_LS_out_nom=p_LS_out_nom,
    p_RS_out_nom=p_RS_out_nom,
    CharLine_Delta_p_IP_mRS_=CharLine_dpIP_mRS_,
    T_LS_nom=T_LS_nom,
    T_RS_nom=T_RS_nom,
    CharLine_Delta_p_HP_mLS_=CharLine_dpHP_mLS_,
    Delta_p_LS_nom=dp_LS_nom,
    Delta_p_RS_nom=dp_RS_nom) annotation (Placement(transformation(extent={{-224,52},{-184,92}})));

  ClaRa.StaticCycles.Condenser condenser(p_condenser=p_condenser) annotation (Placement(transformation(extent={{198,-18},
            {240,22}})));
  ClaRa.StaticCycles.Valve_dp_nom1 valve_LP(Delta_p_nom=valve_IP_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=270,
        origin={-16,9})));
  ClaRa.StaticCycles.Feedwatertank3 feedwatertank(p_FWT_nom=p_FWT, m_flow_nom=m_flow_FW) annotation (Placement(transformation(extent={{10,-120},{-42,-90}})));
  ClaRa.StaticCycles.Valve_dp_nom1 valve_LP1(Delta_p_nom=valve_LP1_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=270,
        origin={91,8})));
  ClaRa.StaticCycles.Pump_real
       pump_cond(efficiency=efficiency_Pump_cond)
    annotation (Placement(transformation(extent={{192,-130},{152,-90}})));
  ClaRa.StaticCycles.Turbine turbine_LP1(
    efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{26,114},
            {56,174}})));
  ClaRa.StaticCycles.Turbine turbine_LP2(
    efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{126,114},
            {156,174}})));
  ClaRa.StaticCycles.Split1 split_LP annotation (Placement(transformation(extent={{-26,108},{-6,128}})));
  ClaRa.StaticCycles.Split1 split_LP1 annotation (Placement(transformation(extent={{80,108},{100,128}})));
  ClaRa.StaticCycles.Preheater1 preheater_LP1(p_tap=p_shell_preheater, m_flow_tap=14) annotation (Placement(transformation(extent={{114,-132},{68,-88}})));
  ClaRa.StaticCycles.Pump_real
       pump_preheater(efficiency=efficiency_Pump_preheat)
    annotation (Placement(transformation(extent={{82,-190},{42,-150}})));
  ClaRa.StaticCycles.Mixer1 mixer annotation (Placement(transformation(extent={{24,-122},{44,-102}})));
equation
  connect(boiler.liveSteam, turbine_HP.inlet) annotation (Line(
      points={{-204,92.8},{-204,156},{-147,156}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.reheat_out, turbine_LP.inlet) annotation (Line(
      points={{-196,92.8},{-196,214},{-73,214},{-73,156}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(feedwatertank.cond_out, pump_fw.inlet) annotation (Line(
      points={{-40.96,-110},{-103.2,-110},{-103.2,-108}},
      color={0,131,169},
      smooth=Smooth.None));

  connect(pump_cond.inlet, condenser.outlet) annotation (Line(
      points={{192.8,-110},{219,-110},{219,-18.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP2.outlet, condenser.inlet) annotation (Line(
      points={{155,120},{219,120},{219,22.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.cond_in, pump_cond.outlet) annotation (Line(
      points={{114.92,-110},{134,-110},{134,-110},{151.2,-110}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.tap_in, valve_LP1.outlet) annotation (Line(
      points={{91,-87.12},{91,-2.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(pump_preheater.inlet, preheater_LP1.tap_out) annotation (Line(
      points={{82.8,-170},{91,-170},{91,-132.88}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer.inlet_2, pump_preheater.outlet) annotation (Line(
      points={{34,-120.667},{34,-170},{41.2,-170}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.cond_out, mixer.inlet_1) annotation (Line(
      points={{67.08,-110},{56,-110},{56,-105.333},{43,-105.333}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer.outlet, feedwatertank.cond_in) annotation (Line(
      points={{24.8,-105.333},{8.96,-105.333},{8.96,-110}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(feedwatertank.tap_in, valve_LP.outlet) annotation (Line(
      points={{-16,-91},{-16,-1.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP.outlet, split_LP.inlet) annotation (Line(
      points={{-47,120},{-36,120},{-36,124.667},{-25,124.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP.outlet_1, turbine_LP1.inlet) annotation (Line(
      points={{-6.6,124.667},{-2,124.667},{-2,120},{4,120},{4,156},{29,156}},
      color={0,131,169},
      smooth=Smooth.None));

  connect(turbine_LP1.outlet, split_LP1.inlet) annotation (Line(
      points={{55,120},{68,120},{68,124.667},{81,124.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP1.outlet_1, turbine_LP2.inlet) annotation (Line(
      points={{99.4,124.667},{106,124.667},{106,156},{129,156}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP1.outlet_2, valve_LP1.inlet) annotation (Line(
      points={{90,109},{91,109},{91,18.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP.outlet_2, valve_LP.inlet) annotation (Line(
      points={{-16,109},{-16,19.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(pump_fw.outlet, boiler.feedwater) annotation (Line(
      points={{-144.8,-108},{-204,-108},{-204,51.2}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_HP.outlet, boiler.reheat_in) annotation (Line(
      points={{-121,120},{-112,120},{-112,20},{-196,20},{-196,51.2}},
      color={0,131,169},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                   graphics),      Diagram(coordinateSystem(preserveAspectRatio=false,
                 extent={{-240,-200},{280,260}}), graphics),
    experiment(
      StopTime=20000,
      NumberOfIntervals=5000,
      Tolerance=1e-005),
    __Dymola_experimentSetupOutput);
end InitSteamCycle_Rostock_3_1;
