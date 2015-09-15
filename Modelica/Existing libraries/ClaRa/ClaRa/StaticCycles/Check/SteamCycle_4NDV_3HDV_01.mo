within ClaRa.StaticCycles.Check;
model SteamCycle_4NDV_3HDV_01 "Helps you to find reasonable start values for steam cycles"
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
  final parameter SI.HeatFlowRate Q_nom=boiler.m_flow_feed*(boiler.h_LS_out - boiler.h_LS_in) + boiler.m_flow_cRH*(boiler.h_RS_out - boiler.h_RS_in) "Nominal heat flow rate"
     annotation (Dialog(group="Global parameter"));
  final parameter SI.MassFlowRate m_flow_FW=m_flow_nom*P_target_ "Feedwater massflow rate at nominal point" annotation (Dialog(group="Global parameter"));

//________________preheater_HP parameter________________________
parameter ClaRa.Basics.Units.Pressure preheater_HP_p_tap=55.95e5
                                                              annotation(Dialog(group = "preheater_HP",tab="Preheater"));
parameter ClaRa.Basics.Units.MassFlowRate preheater_HP_m_flow_tap=42.812
                                                                       annotation(Dialog(group = "preheater_HP",tab="Preheater"));

//________________preheater_IP1 parameter________________________
parameter ClaRa.Basics.Units.Pressure preheater_IP1_p_tap=26.77e5
                                                               annotation(Dialog(group = "preheater_IP1",tab="Preheater"));
parameter ClaRa.Basics.Units.MassFlowRate preheater_IP1_m_flow_tap=19.337
                                                                    annotation(Dialog(group = "preheater_IP1",tab="Preheater"));

//________________turbine_IP2 parameter________________________
parameter ClaRa.Basics.Units.Pressure p_out_IP2=13.2e5         annotation(Dialog(group = "turbine_IP2",tab="Preheater"));
parameter ClaRa.Basics.Units.MassFlowRate IP2_m_flow_tap=17.102     annotation(Dialog(group = "turbine_IP2",tab="Preheater"));

//________________preheater_IP3 parameter________________________
parameter ClaRa.Basics.Units.Pressure preheater_IP3_p_tap=6.488e5
                                                               annotation(Dialog(group = "preheater_IP3",tab="Preheater"));
parameter ClaRa.Basics.Units.MassFlowRate preheater_IP3_m_flow_tap=23.75
                                                                    annotation(Dialog(group = "preheater_IP3",tab="Preheater"));

//________________preheater_LP1 parameter________________________
parameter ClaRa.Basics.Units.Pressure preheater_LP1_p_tap=2.011e5
                                                               annotation(Dialog(group = "preheater_LP1",tab="Preheater"));
parameter ClaRa.Basics.Units.MassFlowRate preheater_LP1_m_flow_tap=23.072
                                                                    annotation(Dialog(group = "preheater_LP1",tab="Preheater"));

//________________preheater_LP2 parameter________________________
parameter ClaRa.Basics.Units.Pressure preheater_LP2_p_tap=0.49e5
                                                               annotation(Dialog(group = "preheater_LP2",tab="Preheater"));
parameter ClaRa.Basics.Units.MassFlowRate preheater_LP2_m_flow_tap=7.724
                                                                    annotation(Dialog(group = "preheater_LP2",tab="Preheater"));
//________________preheater_LP3 parameter________________________
parameter ClaRa.Basics.Units.Pressure preheater_LP3_p_tap=0.207e5
                                                               annotation(Dialog(group = "preheater_LP3",tab="Preheater"));
parameter ClaRa.Basics.Units.MassFlowRate preheater_LP3_m_flow_tap=14.504
                                                                    annotation(Dialog(group = "preheater_LP3",tab="Preheater"));

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
parameter Real efficiency_Pump_preheater_IP3=1 "Efficiency of pump" annotation(Dialog(tab="Pumps"));
parameter Real efficiency_Pump_preheater_LP1=1 "Efficiency of pump" annotation(Dialog(tab="Pumps"));
parameter Real efficiency_Pump_preheater_LP2=1 "Efficiency of pump" annotation(Dialog(tab="Pumps"));
parameter Real efficiency_Pump_preheater_LP3=1 "Efficiency of pump" annotation(Dialog(tab="Pumps"));

//________________turbine parameter________________________
parameter Real efficiency_Turb_HP=1 "Efficiency of turbine" annotation(Dialog(tab= "Turbines"));
parameter Real efficiency_Turb_IP1=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
parameter Real efficiency_Turb_IP2=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
parameter Real efficiency_Turb_IP3=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
parameter Real efficiency_Turb_LP1=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
parameter Real efficiency_Turb_LP2=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
parameter Real efficiency_Turb_LP3=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
parameter Real efficiency_Turb_LP4=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));

// __________________Feewatertank parameter________________
parameter SI.Pressure p_FWT=14e5 "Feedwater tank pressure" annotation(Dialog(tab="Heat exchangers",group="Feedwatertank"));

//___________________condenser parameter___________________
  parameter SI.Pressure p_condenser=4000 "Condenser Pressure" annotation (Dialog(tab="Heat exchangers",group="Condenser"));

  //________________ valves parameter________________________
  parameter ClaRa.Basics.Units.Pressure valve_HP_control_dp_nominal=2e5
                                                             annotation(Dialog(tab="Valves"));
parameter ClaRa.Basics.Units.Pressure valve_IP_control_dp_nominal=2e5
                                                             annotation(Dialog(tab="Valves"));
parameter ClaRa.Basics.Units.Pressure valve1_HP_dp_nominal=2e5 annotation(Dialog(tab="Valves"));
parameter ClaRa.Basics.Units.Pressure valve_IP1_dp_nominal=1e5  annotation(Dialog(tab="Valves"));
parameter ClaRa.Basics.Units.Pressure valve_IP2_dp_nominal=0.8e5
                                                            annotation(Dialog(tab="Valves"));
parameter ClaRa.Basics.Units.Pressure valve_IP3_dp_nominal=1e5
                                                            annotation(Dialog(tab="Valves"));
parameter ClaRa.Basics.Units.Pressure valve_LP1_dp_nominal=0.001e5
                                                                 annotation(Dialog(tab="Valves"));
parameter ClaRa.Basics.Units.Pressure valve_LP2_dp_nominal=0.001e5
                                                                 annotation(Dialog(tab="Valves"));
parameter ClaRa.Basics.Units.Pressure valve_LP3_dp_nominal=0.001e5
                                                                 annotation(Dialog(tab="Valves"));

//parameter Real efficiency_Turb_LP2=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));

  ClaRa.StaticCycles.Pump pump_fw(efficiency=efficiency_Pump_FW)
                                   annotation (Placement(transformation(extent={{78,-190},
            {38,-150}})));
  ClaRa.StaticCycles.Turbine turbine_HP(
    efficiency=efficiency_Turb_HP) annotation (Placement(transformation(extent={{0,90},{
            30,150}})));
  ClaRa.StaticCycles.Turbine turbine_IP2(efficiency=efficiency_Turb_IP2)
    annotation (Placement(transformation(extent={{256,116},{286,176}})));
  ClaRa.StaticCycles.Boiler boiler(
    p_LS_out_nom=p_LS_out_nom,
    p_RS_out_nom=p_RS_out_nom,
    CharLine_Delta_p_IP_mRS_=CharLine_dpIP_mRS_,
    T_LS_nom=T_LS_nom,
    T_RS_nom=T_RS_nom,
    CharLine_Delta_p_HP_mLS_=CharLine_dpHP_mLS_,
    Delta_p_LS_nom=dp_LS_nom,
    Delta_p_RS_nom=dp_RS_nom) annotation (Placement(transformation(extent={{-110,54},{-70,94}})));

  ClaRa.StaticCycles.Condenser condenser(p_condenser=p_condenser) annotation (Placement(transformation(extent={{1010,
            -16},{1052,24}})));
  ClaRa.StaticCycles.Valve_dp_nom1 valve_IP2(Delta_p_nom=p_out_IP2 - p_FWT) annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=270,
        origin={326,31})));
  ClaRa.StaticCycles.Feedwatertank3 feedwatertank(p_FWT_nom=p_FWT, m_flow_nom=m_flow_nom) annotation (Placement(transformation(extent={{318,-180},{268,-152}})));
  ClaRa.StaticCycles.Valve_dp_nom1 valve_LP3(Delta_p_nom=valve_LP3_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=270,
        origin={890,33})));
  ClaRa.StaticCycles.Pump pump_cond(efficiency=efficiency_Pump_cond)
    annotation (Placement(transformation(extent={{1018,-190},{978,-150}})));
  ClaRa.StaticCycles.Turbine turbine_LP1(efficiency=efficiency_Turb_LP1)
                                   annotation (Placement(transformation(extent={{596,116},
            {626,176}})));
  ClaRa.StaticCycles.Split1 split_LP annotation (Placement(transformation(extent={{316,110},{336,130}})));
  ClaRa.StaticCycles.Split1 split_LP1 annotation (Placement(transformation(extent={{880,110},{900,130}})));
  ClaRa.StaticCycles.Preheater1 preheater_LP3(m_flow_tap=preheater_LP3_m_flow_tap, p_tap=preheater_LP3_p_tap - valve_LP3_dp_nominal) annotation (Placement(transformation(extent={{914,-192},{868,-148}})));
  ClaRa.StaticCycles.Turbine turbine_LP4(efficiency=efficiency_Turb_LP4)
                                   annotation (Placement(transformation(extent={{952,116},
            {982,176}})));
  ClaRa.StaticCycles.Preheater1 preheater_HP(m_flow_tap=preheater_HP_m_flow_tap, p_tap=preheater_HP_p_tap - valve1_HP_dp_nominal) annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={-90,-62})));
  ClaRa.StaticCycles.Split1 split_LP_turbine2 annotation (Placement(transformation(extent={{14,28},{-6,48}})));
  ClaRa.StaticCycles.Valve_dp_nom1 valve_dp_nom(Delta_p_nom=valve1_HP_dp_nominal) annotation (Placement(transformation(extent={{-22,-67},{-42,-57}})));
  ClaRa.StaticCycles.Valve_cutPressure valve1 annotation (Placement(transformation(extent={{-24,34},{-44,48}})));
  ClaRa.StaticCycles.Mixer1 mixer annotation (Placement(transformation(extent={{940,-180},{960,-168}})));
  ClaRa.StaticCycles.Preheater1 preheater_LP2(p_tap=preheater_LP2_p_tap - valve_LP2_dp_nominal, m_flow_tap=preheater_LP1_m_flow_tap + preheater_LP2_m_flow_tap) annotation (Placement(transformation(extent={{808,-192},{762,-148}})));
  ClaRa.StaticCycles.Valve_dp_nom1 valve_LP2(Delta_p_nom=valve_LP2_dp_nominal) annotation (Placement(transformation(
        extent={{-9.5,-4.5},{9.5,4.5}},
        rotation=270,
        origin={739.5,-65.5})));
  ClaRa.StaticCycles.Turbine turbine_LP3(efficiency=efficiency_Turb_LP3)
                                   annotation (Placement(transformation(extent={{814,116},
            {844,176}})));
  ClaRa.StaticCycles.Split1 split_LP2 annotation (Placement(transformation(extent={{768,110},{788,130}})));
  ClaRa.StaticCycles.Pump pump_preheater_LP2(efficiency=efficiency_Pump_preheater_LP2)
    annotation (Placement(transformation(extent={{772,-248},{732,-208}})));
  ClaRa.StaticCycles.Mixer1 mixer1 annotation (Placement(transformation(extent={{706,-180},{723,-168}})));
  ClaRa.StaticCycles.Pump Pump_preheater_LP3(efficiency=efficiency_Pump_preheater_LP3)
    annotation (Placement(transformation(extent={{898,-248},{938,-208}})));
  ClaRa.StaticCycles.Turbine turbine_LP2(efficiency=efficiency_Turb_LP2)
    annotation (Placement(transformation(extent={{710,116},{740,176}})));
  ClaRa.StaticCycles.Split1 split_LP3 annotation (Placement(transformation(extent={{650,110},{670,130}})));
  ClaRa.StaticCycles.Preheater1 preheater_LP1(m_flow_tap=preheater_LP1_m_flow_tap, p_tap=preheater_LP1_p_tap - valve_LP1_dp_nominal) annotation (Placement(transformation(extent={{684,-192},{638,-148}})));
  ClaRa.StaticCycles.Valve_dp_nom1 valve_LP1(Delta_p_nom=valve_LP1_dp_nominal) annotation (Placement(transformation(
        extent={{-10.5,-5},{10.5,5}},
        rotation=270,
        origin={661,-66.5})));
  ClaRa.StaticCycles.Mixer3 mixer3_1
    annotation (Placement(transformation(extent={{750,-98},{730,-110}})));
  ClaRa.StaticCycles.Valve_cutPressure valve2 annotation (Placement(transformation(
        extent={{-12,-6},{12,6}},
        rotation=90,
        origin={696,-130})));
  ClaRa.StaticCycles.Split1 split_LP4 annotation (Placement(transformation(extent={{462,108},{482,128}})));
  ClaRa.StaticCycles.Turbine turbine_IP3(efficiency=efficiency_Turb_IP3)
                                   annotation (Placement(transformation(extent={{374,114},
            {404,174}})));
  ClaRa.StaticCycles.Preheater1 preheater_IP3(m_flow_tap=preheater_IP3_m_flow_tap, p_tap=preheater_IP3_p_tap - valve_IP3_dp_nominal) annotation (Placement(transformation(extent={{494,-192},{448,-148}})));
  ClaRa.StaticCycles.Pump pump_preheater_IP3(efficiency=efficiency_Pump_preheater_IP3)
    annotation (Placement(transformation(extent={{448,-250},{408,-210}})));
  ClaRa.StaticCycles.Mixer1 mixer3 annotation (Placement(transformation(extent={{386,-182},{406,-162}})));
  ClaRa.StaticCycles.Mixer3 mixer3_2
    annotation (Placement(transformation(extent={{230,-112},{210,-132}})));
  ClaRa.StaticCycles.Turbine turbine_IP1(efficiency=efficiency_Turb_IP1)
                                   annotation (Placement(transformation(extent={{144,114},
            {174,174}})));
  ClaRa.StaticCycles.Split1 split_LP5 annotation (Placement(transformation(extent={{198,108},{218,128}})));
  ClaRa.StaticCycles.Valve_dp_nom1 valve_IP1(Delta_p_nom=valve_IP1_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=270,
        origin={208,29})));
  ClaRa.StaticCycles.Preheater1 preheater_IP1(
    m_flow_tap=preheater_IP1_m_flow_tap,
    p_tap=preheater_IP1_p_tap - valve_IP1_dp_nominal,
    h_tap_out=preheater_IP1.h_tap_in - 8e6/preheater_IP1.m_flow_tap) annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={-90,4})));
  ClaRa.StaticCycles.Valve_cutPressure valve4 annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=180,
        origin={-130,-62})));
  ClaRa.StaticCycles.Valve_cutPressure valve3 annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=180,
        origin={-130,4})));
  ClaRa.StaticCycles.Mixer1 mixer4_1 annotation (Placement(transformation(
        extent={{-10,-3.99991},{10,3.99992}},
        rotation=90,
        origin={-156,-61})));
  ClaRa.StaticCycles.Preheater2 preheater_HP_IP1(p_tap=preheater_IP1_p_tap - valve_IP1_dp_nominal)
                                                        annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-90,-124})));
  ClaRa.StaticCycles.Valve_cutPressure valve5 annotation (Placement(transformation(
        extent={{10,-5},{-10,5}},
        rotation=180,
        origin={-30,-124})));
  ClaRa.StaticCycles.Valve_dp_nom1 valve_IP3(Delta_p_nom=valve_IP3_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=270,
        origin={472,29})));
  ClaRa.StaticCycles.Valve_dp_nom2 valve_dp_nom2_1(Delta_p_nom=valve_HP_control_dp_nominal) annotation (Placement(transformation(extent={{-40,126},{-20,140}})));
  ClaRa.StaticCycles.Valve_dp_nom2 valve_IP_control(Delta_p_nom=valve_IP_control_dp_nominal) annotation (Placement(transformation(extent={{-40,150},{-20,164}})));
  ClaRa.StaticCycles.Valve_dp_nom3 valve_dp_nom3_1(Delta_p_nom=6e5) annotation (Placement(transformation(extent={{364,-176},{344,-162}})));
equation
  connect(feedwatertank.cond_out, pump_fw.inlet) annotation (Line(
      points={{269,-170.667},{174,-170.667},{174,-170},{78.8,-170}},
      color={0,131,169},
      smooth=Smooth.None));

  connect(preheater_LP3.tap_in, valve_LP3.outlet) annotation (Line(
      points={{891,-147.12},{891,-60.6},{890,-60.6},{890,22.2}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP4.outlet, condenser.inlet) annotation (Line(
      points={{981,122},{1032,122},{1032,74},{1031,74},{1031,24.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_IP2.outlet, split_LP.inlet) annotation (Line(
      points={{285,122},{300,122},{300,126.667},{317,126.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP.outlet_2, valve_IP2.inlet) annotation (Line(
      points={{326,111},{326,41.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP1.outlet_2, valve_LP3.inlet) annotation (Line(
      points={{890,111},{890,43.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP1.outlet_1,turbine_LP4. inlet) annotation (Line(
      points={{899.4,126.667},{928,126.667},{928,158},{953,158}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP_turbine2.inlet, turbine_HP.outlet) annotation (Line(
      points={{13,44.6667},{32,44.6667},{32,96},{29,96}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_dp_nom.inlet, split_LP_turbine2.outlet_2) annotation (Line(
      points={{-21.2,-62},{4,-62},{4,29}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_dp_nom.outlet, preheater_HP.tap_in) annotation (Line(
      points={{-42.8,-62},{-69.2,-62}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve1.inlet, split_LP_turbine2.outlet_1) annotation (Line(
      points={{-23.2,41},{-19.8,41},{-19.8,44.6667},{-5.4,44.6667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve1.outlet, boiler.reheat_in) annotation (Line(
      points={{-44.8,41},{-82,41},{-82,53.2}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(condenser.outlet, pump_cond.inlet) annotation (Line(
      points={{1031,-16.8},{1031,-170},{1018.8,-170}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer.inlet_1, pump_cond.outlet) annotation (Line(
      points={{959,-170},{977.2,-170}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer.outlet,preheater_LP3. cond_in) annotation (Line(
      points={{940.8,-170},{914.92,-170}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP2.cond_in,preheater_LP3. cond_out) annotation (Line(
      points={{808.92,-170},{867.08,-170}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP3.outlet, split_LP1.inlet) annotation (Line(
      points={{843,122},{862,122},{862,126.667},{881,126.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP2.outlet_1, turbine_LP3.inlet) annotation (Line(
      points={{787.4,126.667},{800,126.667},{800,158},{815,158}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP2.outlet_2, valve_LP2.inlet) annotation (Line(
      points={{778,111},{778,40},{739.5,40},{739.5,-55.24}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(pump_preheater_LP2.inlet, preheater_LP2.tap_out) annotation (Line(
      points={{772.8,-228},{785,-228},{785,-192.88}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer1.inlet_2, pump_preheater_LP2.outlet) annotation (Line(
      points={{714.5,-179.2},{715.111,-179.2},{715.111,-228},{731.2,-228}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer1.inlet_1, preheater_LP2.cond_out) annotation (Line(
      points={{722.15,-170},{761.08,-170}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Pump_preheater_LP3.inlet,preheater_LP3. tap_out) annotation (Line(
      points={{897.2,-228},{888,-228},{888,-192.88},{891,-192.88}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Pump_preheater_LP3.outlet, mixer.inlet_2) annotation (Line(
      points={{938.8,-228},{950,-228},{950,-179.2}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP2.outlet, split_LP2.inlet) annotation (Line(
      points={{739,122},{754,122},{754,126.667},{769,126.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP3.outlet_1, turbine_LP2.inlet) annotation (Line(
      points={{669.4,126.667},{696,126.667},{696,158},{711,158}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP3.inlet, turbine_LP1.outlet) annotation (Line(
      points={{651,126.667},{636,126.667},{636,122},{625,122}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.cond_in, mixer1.outlet) annotation (Line(
      points={{684.92,-170},{706.68,-170}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_LP1.inlet, split_LP3.outlet_2) annotation (Line(
      points={{661,-55.16},{661,111},{660,111}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_LP1.outlet, preheater_LP1.tap_in) annotation (Line(
      points={{661,-77.84},{661,-147.12}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.tap_out, valve2.inlet) annotation (Line(
      points={{661,-192.88},{662,-192.88},{662,-228},{696,-228},{696,-142.96}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve2.outlet, mixer3_1.inlet_1) annotation (Line(
      points={{696,-117.04},{696,-108},{730.6,-108}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_LP2.outlet, mixer3_1.inlet_2) annotation (Line(
      points={{739.5,-75.76},{739.5,-76},{740,-76},{740,-98.6}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer3_1.outlet, preheater_LP2.tap_in) annotation (Line(
      points={{749.4,-108},{785,-108},{785,-147.12}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP.outlet_1,turbine_IP3. inlet) annotation (Line(
      points={{335.4,126.667},{364,126.667},{364,156},{375,156}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_IP3.outlet, split_LP4.inlet) annotation (Line(
      points={{403,120},{432,120},{432,124.667},{463,124.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP4.outlet_1, turbine_LP1.inlet) annotation (Line(
      points={{481.4,124.667},{568,124.667},{568,158},{597,158}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_IP3.cond_in, preheater_LP1.cond_out) annotation (Line(
      points={{494.92,-170},{637.08,-170}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_IP3.tap_out, pump_preheater_IP3.inlet) annotation (Line(
      points={{471,-192.88},{471,-230},{448.8,-230}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer3.inlet_1,preheater_IP3. cond_out) annotation (Line(
      points={{405,-165.333},{432,-165.333},{432,-170},{447.08,-170}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(pump_preheater_IP3.outlet, mixer3.inlet_2) annotation (Line(
      points={{407.2,-230},{396,-230},{396,-180.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(feedwatertank.tap_in, mixer3_2.outlet) annotation (Line(
      points={{293,-152.933},{293,-128.667},{229.4,-128.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer3_2.inlet_2, valve_IP2.outlet) annotation (Line(
      points={{220,-113},{220,-44},{326,-44},{326,20.2}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP5.outlet_1, turbine_IP2.inlet) annotation (Line(
      points={{217.4,124.667},{232,124.667},{232,158},{257,158}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP5.inlet, turbine_IP1.outlet) annotation (Line(
      points={{199,124.667},{184,124.667},{184,120},{173,120}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_IP1.inlet, split_LP5.outlet_2) annotation (Line(
      points={{208,39.8},{208,109}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_HP.cond_out,preheater_IP1. cond_in) annotation (Line(
      points={{-90,-41.2},{-90,-16.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_IP1.cond_out, boiler.feedwater) annotation (Line(
      points={{-90,24.8},{-90,53.2}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_IP1.tap_in,valve_IP1. outlet) annotation (Line(
      points={{-69.2,4},{208,4},{208,18.2}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve4.inlet, preheater_HP.tap_out) annotation (Line(
      points={{-119.2,-62},{-110.8,-62}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_IP1.tap_out, valve3.inlet) annotation (Line(
      points={{-110.8,4},{-119.2,4}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_HP_IP1.cond_out, preheater_HP.cond_in) annotation (Line(
      points={{-90,-103.2},{-90,-82.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_HP_IP1.cond_in, pump_fw.outlet) annotation (Line(
      points={{-90,-144.8},{-90,-170},{37.2,-170}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer4_1.inlet_1, valve3.outlet) annotation (Line(
      points={{-158.667,-52},{-158.667,4},{-140.8,4}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer4_1.outlet, preheater_HP_IP1.tap_in) annotation (Line(
      points={{-158.667,-70.2},{-158.667,-124},{-110.8,-124}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve5.outlet, mixer3_2.inlet_1) annotation (Line(
      points={{-19.2,-124},{92,-124},{92,-128.667},{210.6,-128.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve5.inlet, preheater_HP_IP1.tap_out) annotation (Line(
      points={{-40.8,-124},{-69.2,-124}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP4.outlet_2,valve_IP3. inlet) annotation (Line(
      points={{472,109},{472,39.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_IP3.outlet,preheater_IP3. tap_in) annotation (Line(
      points={{472,18.2},{472,-147.12},{471,-147.12}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer4_1.inlet_2, valve4.outlet) annotation (Line(
      points={{-152.533,-61},{-144,-61},{-144,-62},{-140.8,-62}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.liveSteam, valve_dp_nom2_1.inlet) annotation (Line(
      points={{-90,94.8},{-86,94.8},{-86,132},{-40.8,132},{-40.8,133}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_dp_nom2_1.outlet, turbine_HP.inlet) annotation (Line(
      points={{-19.2,133},{-6,133},{-6,132},{1,132}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.reheat_out, valve_IP_control.inlet) annotation (Line(
      points={{-82,94.8},{-74,94.8},{-74,157},{-40.8,157}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_IP_control.outlet, turbine_IP1.inlet) annotation (Line(
      points={{-19.2,157},{-8,157},{-8,156},{145,156}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_dp_nom3_1.inlet, mixer3.outlet) annotation (Line(
      points={{364.8,-169},{373.2,-169},{373.2,-165.333},{386.8,-165.333}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_dp_nom3_1.outlet, feedwatertank.cond_in) annotation (Line(
      points={{343.2,-169},{331.8,-169},{331.8,-170.667},{317,-170.667}},
      color={0,131,169},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                   graphics),      Diagram(coordinateSystem(preserveAspectRatio=false,
                 extent={{-180,-280},{1080,240}}),graphics),
    experiment(
      StopTime=20000,
      NumberOfIntervals=5000,
      Tolerance=1e-005),
    __Dymola_experimentSetupOutput);
end SteamCycle_4NDV_3HDV_01;
