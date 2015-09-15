within ClaRa.StaticCycles.Check;
model StaCy_5Components "A Static Cycle with only five components!"
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
//   parameter SI.HeatFlowRate Q_nom=boiler.m_flow_LS*(boiler.h_LS_out - boiler.h_LS_in) + boiler.m_flow_RS*(boiler.h_RS_out - boiler.h_RS_in)
//     "Nominal heat flow rate"

  final parameter SI.MassFlowRate m_flow_FW=m_flow_nom*P_target_ "Feedwater massflow rate at nominal point" annotation (Dialog(group="Global parameter"));

//___________________condenser parameter___________________
  parameter SI.Pressure p_condenser=4000 annotation (Dialog(group="Condenser"));

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
parameter Real efficiency_Pump_FW=1 "Efficiency of pump" annotation(Dialog(tab="Pumps"));

//________________turbine parameter________________________
parameter Real efficiency_Turb_HP=1 "Efficiency of turbine" annotation(Dialog(tab= "Turbines"));
parameter Real efficiency_Turb_LP=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
//parameter Real efficiency_Turb_LP2=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));

  ClaRa.StaticCycles.Pump pump_fw(
    efficiency=efficiency_Pump_FW) annotation (Placement(transformation(extent={{104,-62},{64,-22}})));
  ClaRa.StaticCycles.Turbine turbine_HP(
    efficiency=efficiency_Turb_HP) annotation (Placement(transformation(extent={{-80,158},{-50,218}})));
  ClaRa.StaticCycles.Turbine turbine_LP(
    efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{26,162},
            {56,222}})));
  ClaRa.StaticCycles.Boiler boiler(
    p_LS_out_nom=p_LS_out_nom,
    p_RS_out_nom=p_RS_out_nom,
    CharLine_Delta_p_IP_mRS_=CharLine_dpIP_mRS_,
    T_LS_nom=T_LS_nom,
    T_RS_nom=T_RS_nom,
    CharLine_Delta_p_HP_mLS_=CharLine_dpHP_mLS_,
    Delta_p_LS_nom=dp_LS_nom,
    Delta_p_RS_nom=dp_RS_nom) annotation (Placement(transformation(extent={{-200,100},{-160,140}})));

  ClaRa.StaticCycles.Condenser condenser(p_condenser=p_condenser)
                                               annotation (Placement(transformation(extent={{320,40},{362,80}})));
equation
  connect(condenser.outlet, pump_fw.inlet) annotation (Line(
      points={{341,39.2},{341,-42},{104.8,-42}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.liveSteam, turbine_HP.inlet) annotation (Line(
      points={{-180,140.8},{-180,200},{-77,200}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.reheat_out, turbine_LP.inlet) annotation (Line(
      points={{-172,140.8},{-172,264},{29,264},{29,204}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP.outlet, condenser.inlet) annotation (Line(
      points={{55,168},{341,168},{341,80.8}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_HP.outlet, boiler.reheat_in) annotation (Line(
      points={{-51,164},{-16,164},{-16,72},{-172,72},{-172,99.2}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(pump_fw.outlet, boiler.feedwater) annotation (Line(
      points={{63.2,-42},{-180,-42},{-180,99.2}},
      color={0,131,169},
      smooth=Smooth.None));
    annotation (Dialog(group="Global parameter"),
              Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                   graphics),      Diagram(coordinateSystem(preserveAspectRatio=false,
                 extent={{-240,-200},{400,350}}), graphics),
    experiment(
      StopTime=20000,
      NumberOfIntervals=5000,
      Tolerance=1e-005),
    __Dymola_experimentSetupOutput);
end StaCy_5Components;
