within ClaRa.StaticCycles.Check;
model InitSteamCycle_Rostock_HRO_20 "Helps you to find reasonable start values for steam cycles"
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

//________________preheater_HP parameter________________________
parameter ClaRa.Basics.Units.Pressure preheater_HP_p_tap=55.95e5
                                                              annotation(Dialog(group = "preheater_HP",tab="Preheater"));
parameter ClaRa.Basics.Units.MassFlowRate preheater_HP_m_flow_tap=42.812
                                                                       annotation(Dialog(group = "preheater_HP",tab="Preheater"));
//________________preheater_LP1 parameter________________________
parameter ClaRa.Basics.Units.Pressure preheater_LP1_p_tap=0.207e5
                                                               annotation(Dialog(group = "preheater_LP1",tab="Preheater"));
parameter ClaRa.Basics.Units.MassFlowRate preheater_LP1_m_flow_tap=14
                                                                    annotation(Dialog(group = "preheater_LP1",tab="Preheater"));

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
parameter Real efficiency_Turb_IP=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
parameter Real efficiency_Turb_LP=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
//__________________reboiler parameter____________________
parameter SI.Pressure p_reboiler=3.5e5 "Reboiler pressure"       annotation(Dialog(tab="Heat exchangers",group="Reboiler"));
parameter SI.MassFlowRate m_flow_reboiler=150 "Reboiler mass flow rate"
                                                                       annotation(Dialog(tab="Heat exchangers",group="Reboiler"));
// __________________Feewatertank parameter________________
parameter SI.Pressure p_FWT=14e5 "Feedwater tank pressure" annotation(Dialog(tab="Heat exchangers",group="Feedwatertank"));
//___________________condenser parameter___________________
  parameter SI.Pressure p_condenser=4000 "Condenser Pressure" annotation (Dialog(tab="Heat exchangers",group="Condenser"));
//________________ valves parameter________________________
parameter ClaRa.Basics.Units.Pressure valve1_HP_dp_nominal=2e5 annotation(Dialog(tab="Valves"));
parameter ClaRa.Basics.Units.Pressure valve_IP_dp_nominal=1e5  annotation(Dialog(tab="Valves"));
parameter ClaRa.Basics.Units.Pressure valve_LP1_dp_nominal=0.001e5   annotation(Dialog(tab="Valves"));

//parameter Real efficiency_Turb_LP2=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));

  ClaRa.StaticCycles.Pump pump_fw(efficiency=efficiency_Pump_FW)
                                   annotation (Placement(transformation(extent={{-100,
            -134},{-140,-94}})));
  ClaRa.StaticCycles.Turbine turbine_HP(
    efficiency=efficiency_Turb_HP) annotation (Placement(transformation(extent={{-150,
            112},{-120,172}})));
  ClaRa.StaticCycles.Turbine turbine_IP(efficiency=efficiency_Turb_IP)
                                   annotation (Placement(transformation(extent={{-86,114},
            {-56,174}})));
  ClaRa.StaticCycles.Boiler boiler(
    p_LS_out_nom=p_LS_out_nom,
    p_RS_out_nom=p_RS_out_nom,
    CharLine_Delta_p_IP_mRS_=CharLine_dpIP_mRS_,
    T_LS_nom=T_LS_nom,
    T_RS_nom=T_RS_nom,
    CharLine_Delta_p_HP_mLS_=CharLine_dpHP_mLS_,
    Delta_p_LS_nom=dp_LS_nom,
    Delta_p_RS_nom=dp_RS_nom) annotation (Placement(transformation(extent={{-224,52},{-184,92}})));

  ClaRa.StaticCycles.Condenser condenser(p_condenser=p_condenser) annotation (Placement(transformation(extent={{210,-18},
            {252,22}})));
  ClaRa.StaticCycles.Valve_dp_nom1 valve_LP(Delta_p_nom=valve_IP_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=270,
        origin={-34,11})));
  ClaRa.StaticCycles.Feedwatertank3 feedwatertank(p_FWT_nom=p_FWT, m_flow_nom=m_flow_FW) annotation (Placement(transformation(extent={{-8,-124},{-58,-96}})));
  ClaRa.StaticCycles.Valve_dp_nom1 valve_LP1(Delta_p_nom=valve_LP1_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=270,
        origin={90,11})));
  ClaRa.StaticCycles.Pump pump_cond(efficiency=efficiency_Pump_cond)
    annotation (Placement(transformation(extent={{174,-134},{134,-94}})));
  ClaRa.StaticCycles.Turbine turbine_LP1(
    efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{12,114},
            {42,174}})));
  ClaRa.StaticCycles.Split1 split_LP annotation (Placement(transformation(extent={{-44,108},{-24,128}})));
  ClaRa.StaticCycles.Split1 split_LP1 annotation (Placement(transformation(extent={{80,108},{100,128}})));
  ClaRa.StaticCycles.Preheater1 preheater_LP1(p_tap=preheater_LP1_p_tap, m_flow_tap=preheater_LP1_m_flow_tap) annotation (Placement(transformation(extent={{114,-136},{68,-92}})));
  ClaRa.StaticCycles.Turbine turbine_LP2(
    efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{182,114},
            {212,174}})));
  ClaRa.StaticCycles.Preheater1 preheater_HP(m_flow_tap=preheater_HP_m_flow_tap, p_tap=preheater_HP_p_tap) annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={-202,-22})));
  ClaRa.StaticCycles.Split1 split_LP_turbine2 annotation (Placement(transformation(extent={{-98,8},{-118,28}})));
  ClaRa.StaticCycles.Mixer1 mixer2 annotation (Placement(transformation(extent={{22,-126},{42,-106}})));
  ClaRa.StaticCycles.Valve_cutPressure valve annotation (Placement(transformation(extent={{-104,-160},{-84,-144}})));
  ClaRa.StaticCycles.Valve_dp_nom1 valve_dp_nom(Delta_p_nom=valve1_HP_dp_nominal) annotation (Placement(transformation(extent={{-132,-28},{-152,-12}})));
  ClaRa.StaticCycles.Valve_cutPressure valve1 annotation (Placement(transformation(extent={{-152,12},{-172,26}})));
  ClaRa.StaticCycles.Mixer2 mixer2_1
    annotation (Placement(transformation(extent={{194,-126},{214,-106}})));
  ClaRa.StaticCycles.Valve_cutPressure valve2 annotation (Placement(transformation(extent={{148,-166},{168,-150}})));
equation
  connect(boiler.liveSteam, turbine_HP.inlet) annotation (Line(
      points={{-204,92.8},{-204,154},{-147,154}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.reheat_out,turbine_IP. inlet) annotation (Line(
      points={{-196,92.8},{-196,214},{-83,214},{-83,156}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(feedwatertank.cond_out, pump_fw.inlet) annotation (Line(
      points={{-57,-114.667},{-78,-114.667},{-78,-114},{-99.2,-114}},
      color={0,131,169},
      smooth=Smooth.None));

  connect(preheater_LP1.cond_in, pump_cond.outlet) annotation (Line(
      points={{114.92,-114},{133.2,-114}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.tap_in, valve_LP1.outlet) annotation (Line(
      points={{91,-91.12},{91,0.2},{90,0.2}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(feedwatertank.tap_in, valve_LP.outlet) annotation (Line(
      points={{-33,-96.9333},{-33,-44},{-34,-44},{-34,0.2}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP2.outlet, condenser.inlet) annotation (Line(
      points={{211,120},{218,120},{218,118},{231,118},{231,22.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_IP.outlet, split_LP.inlet) annotation (Line(
      points={{-57,120},{-50,120},{-50,124.667},{-43,124.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP.outlet_2, valve_LP.inlet) annotation (Line(
      points={{-34,109},{-34,21.8},{-34,21.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP1.outlet, split_LP1.inlet) annotation (Line(
      points={{41,120},{60,120},{60,124.667},{81,124.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP1.outlet_2, valve_LP1.inlet) annotation (Line(
      points={{90,109},{90,109},{90,21.8},{90,21.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP1.outlet_1,turbine_LP2. inlet) annotation (Line(
      points={{99.4,124.667},{170,124.667},{170,156},{185,156}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.feedwater, preheater_HP.cond_out) annotation (Line(
      points={{-204,51.2},{-202,51.2},{-202,-1.2}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_HP.cond_in, pump_fw.outlet) annotation (Line(
      points={{-202,-42.8},{-202,-114},{-140.8,-114}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP_turbine2.inlet, turbine_HP.outlet) annotation (Line(
      points={{-99,24.6667},{-78,24.6667},{-78,118},{-121,118}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer2.outlet, feedwatertank.cond_in) annotation (Line(
      points={{22.8,-109.333},{8,-109.333},{8,-114.667},{-9,-114.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve.outlet, mixer2.inlet_2) annotation (Line(
      points={{-83.2,-152},{32,-152},{32,-124.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve.inlet, preheater_HP.tap_out) annotation (Line(
      points={{-104.8,-152},{-232,-152},{-232,-22},{-222.8,-22}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_dp_nom.inlet, split_LP_turbine2.outlet_2) annotation (Line(
      points={{-131.2,-20},{-108,-20},{-108,9}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_dp_nom.outlet, preheater_HP.tap_in) annotation (Line(
      points={{-152.8,-20},{-181.2,-20},{-181.2,-22}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve1.inlet, split_LP_turbine2.outlet_1) annotation (Line(
      points={{-151.2,19},{-133.8,19},{-133.8,24.6667},{-117.4,24.6667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve1.outlet, boiler.reheat_in) annotation (Line(
      points={{-172.8,19},{-196,19},{-196,51.2}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP1.inlet, split_LP.outlet_1) annotation (Line(
      points={{15,156},{-8,156},{-8,124.667},{-24.6,124.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.cond_out, mixer2.inlet_1) annotation (Line(
      points={{67.08,-114},{54,-114},{54,-109.333},{41,-109.333}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer2_1.outlet, pump_cond.inlet) annotation (Line(
      points={{194.6,-109.333},{184,-109.333},{184,-114},{174.8,-114}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer2_1.inlet_1, condenser.outlet) annotation (Line(
      points={{213.4,-109.333},{231,-109.333},{231,-18.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve2.outlet, mixer2_1.inlet_2) annotation (Line(
      points={{168.8,-158},{204,-158},{204,-125}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve2.inlet, preheater_LP1.tap_out) annotation (Line(
      points={{147.2,-158},{91,-158},{91,-136.88}},
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
end InitSteamCycle_Rostock_HRO_20;
