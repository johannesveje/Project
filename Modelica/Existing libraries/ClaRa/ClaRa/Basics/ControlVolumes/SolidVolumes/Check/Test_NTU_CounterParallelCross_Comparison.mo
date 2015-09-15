within ClaRa.Basics.ControlVolumes.SolidVolumes.Check;
model Test_NTU_CounterParallelCross_Comparison "Comparison of NTU counter cross and parallel flow models"
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

extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;
  import SI = ClaRa.Basics.Units;

  parameter Units.Temperature
                           T_o_in = 450 "Temperature of cold side";
  parameter Units.Temperature
                           T_i_in = 200 "Temperature of hot side";
  parameter Units.MassFlowRate
                            m_flow_o = 1 "Mass flow of cold side";
  parameter Units.MassFlowRate
                            m_flow_i = 0.2 "Mass flow of hot side";
  parameter Units.Pressure
                        p_o = 0.1e5 "Pressure of cold side";
  parameter Units.Pressure
                        p_i = 1e5 "Pressure of hot side";

  parameter Units.CoefficientOfHeatTransfer
                                         alpha_o = 600 "Heat transfer coefficient of cold side";
  parameter Units.CoefficientOfHeatTransfer
                                         alpha_i = 1000 "Heat transfer coefficient of hot side";

  parameter Integer N_tubes = 1 "Number of parallel tubes";
  parameter Integer N_passes = 1 "Number of passes";
  parameter Units.Length
                      diameter_i = 0.05*2 "Diameter of cold side tubes";
  parameter Units.Length
                      diameter_o = (0.05+1e-6)*2 "Diameter of hot side tubes";
  parameter Units.Length
                      radius_i = diameter_i/2 "Diameter of cold side tubes";
  parameter Units.Length
                      radius_o = diameter_o/2 "Diameter of hot side tubes";
  parameter Units.Length
                      length = 4 "Length of tubes";

  parameter Units.EnthalpyMassSpecific
                                    h_o_in = TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(), p_o, T_o_in);
  parameter Units.EnthalpyMassSpecific
                                    h_i_in = TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(), p_i, T_i_in);

  inner SimCenter simCenter(redeclare TILMedia.VLEFluidTypes.TILMedia_Water fluid1) annotation (Placement(transformation(extent={{80,80},{100,100}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.NTU_L3_standalone NTU_counter(
    N_t=N_tubes,
    N_p=N_passes,
    length=length,
    radius_i=radius_i,
    radius_o=radius_o,
    T_w_i_start=ones(3)*T_i_in,
    T_w_o_start=ones(3)*T_o_in,
    p_o=p_o,
    p_i=p_i,
    h_i_inlet=h_i_in,
    h_o_inlet=h_o_in,
    m_flow_i=m_flow_i,
    m_flow_o=m_flow_o,
    alpha_i=ones(3)*alpha_i,
    alpha_o=ones(3)*alpha_o,
    redeclare model HeatExchangerType =
        ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CounterFlow_L3,
    initChoice=ClaRa.Basics.Choices.Init.noInit,
    redeclare function HeatCapacityAveraging =
        ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Functions.ArithmeticMean,
    outerPhaseChange=false) annotation (Placement(transformation(extent={{-80,-60},{-40,-20}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.NTU_L3_standalone NTU_parallel(
    N_t=N_tubes,
    N_p=N_passes,
    length=length,
    radius_i=radius_i,
    radius_o=radius_o,
    T_w_i_start=ones(3)*T_i_in,
    T_w_o_start=ones(3)*T_o_in,
    p_o=p_o,
    p_i=p_i,
    h_i_inlet=h_i_in,
    h_o_inlet=h_o_in,
    m_flow_i=m_flow_i,
    m_flow_o=m_flow_o,
    alpha_i=ones(3)*alpha_i,
    alpha_o=ones(3)*alpha_o,
    redeclare model HeatExchangerType =
        ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.ParallelFlow_L3,
    initChoice=ClaRa.Basics.Choices.Init.noInit,
    redeclare function HeatCapacityAveraging =
        ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Functions.ArithmeticMean,
    outerPhaseChange=false) annotation (Placement(transformation(extent={{-20,-60},{20,-20}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.NTU_L3_standalone NTU_cross(
    N_t=N_tubes,
    N_p=N_passes,
    length=length,
    radius_i=radius_i,
    radius_o=radius_o,
    T_w_i_start=ones(3)*T_i_in,
    T_w_o_start=ones(3)*T_o_in,
    p_o=p_o,
    p_i=p_i,
    h_i_inlet=h_i_in,
    h_o_inlet=h_o_in,
    m_flow_i=m_flow_i,
    m_flow_o=m_flow_o,
    alpha_i=ones(3)*alpha_i,
    alpha_o=ones(3)*alpha_o,
    redeclare model HeatExchangerType =
        ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CrossFlow_L3,
    initChoice=ClaRa.Basics.Choices.Init.noInit,
    redeclare function HeatCapacityAveraging =
        ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Functions.ArithmeticMean,
    outerPhaseChange=false) annotation (Placement(transformation(extent={{40,-60},{80,-20}})));

  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=true),
                      graphics={
                  Text(
          extent={{-100,100},{100,80}},
          lineColor={0,128,0},
          textStyle={TextStyle.Bold},
          horizontalAlignment=TextAlignment.Left,
          fontSize=26,
          textString="Tested! // 31. Jan 2013, AR"),
        Text(
          extent={{-80,20},{-40,0}},
          lineColor={0,0,0},
          textStyle={TextStyle.Bold},
          fontSize=20,
          textString="Counter flow"),
        Text(
          extent={{-20,20},{20,0}},
          lineColor={0,0,0},
          fontSize=20,
          textStyle={TextStyle.Bold},
          textString="Parallel flow"),
        Text(
          extent={{40,20},{80,0}},
          lineColor={0,0,0},
          fontSize=20,
          textStyle={TextStyle.Bold},
          textString="Cross flow"),                Text(
          extent={{-100,90},{100,10}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=8,
          textString="_______________________________________________________________________________________________________
SCENARIO:
*Comparison of NTU counter,parallel and cross flow
*heating water at inner side, cooling steam at outer side
*no phase change 
_______________________________________________________________________________________________________
LOOK AT:
Outlet temperatures of heated liquid: NTU_counter.summary.T_i[6]>NTU_cross.summary.T_i[2]>NTU_parallel.summary.T_i[6]
Outlet temperatures of cooled steam: NTU_counter.summary.T_i[6]<NTU_cross.summary.T_i[2]<NTU_parallel.summary.T_i[6]
_______________________________________________________________________________________________________")}),
                                 Icon(coordinateSystem(extent={{-100,-100},{100,
            100}}, preserveAspectRatio=true),
                    graphics),
    experiment(
      StopTime=1000,
      NumberOfIntervals=1000,
      Tolerance=1e-007,
      Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equdistant=false));
end Test_NTU_CounterParallelCross_Comparison;
