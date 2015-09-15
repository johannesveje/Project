within ClaRa.Visualisation.Check;
model TestHEXdisplay "Illustrates the capabilities of the HEXdisplay"
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

extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;

  import SI = ClaRa.Basics.Units;
  parameter SI.Temperature T_i_in=100 + 273.15 "Temperature of cold side";
  parameter SI.Temperature T_o_in=300 + 273.15 "Temperature of hot side";
  parameter SI.MassFlowRate m_flow_i=10 "Mass flow of cold side";
  parameter SI.MassFlowRate m_flow_o=100 "Mass flow of hot side";
  parameter SI.Pressure p_i=2e5 "Pressure of cold side";
  parameter SI.Pressure p_o=300e5 "Pressure of hot side";

  parameter SI.CoefficientOfHeatTransfer alpha_i=730 "Heat transfer coefficient of cold side";
  parameter SI.CoefficientOfHeatTransfer alpha_o=7300 "Heat transfer coefficient of hot side";

  parameter Integer N_tubes = 200 "Number of parallel tubes";
  parameter Integer N_passes = 1 "Number of passes";
  parameter SI.Length diameter_i=0.05*2 "Diameter of cold side tubes";
  parameter SI.Length diameter_o=(0.05 + 1e-6)*2 "Diameter of hot side tubes";
  parameter SI.Length radius_i=diameter_i/2 "Diameter of cold side tubes";
  parameter SI.Length radius_o=diameter_o/2 "Diameter of hot side tubes";
  parameter SI.Length length=4 "Length of tubes";
  parameter Integer N_cv = 400 "Number of Cells";

  SI.EnthalpyMassSpecific h_i_in=
      TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
      TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),
      p_i,
      T_i_in);
  SI.EnthalpyMassSpecific h_o_in=
      TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
      TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),
      p_o,
      T.y);

//    SI.HeatFlowRate Q_flow_tot;
//    SI.HeatCapacityMassSpecific cp_h_m;
//    SI.HeatCapacityMassSpecific cp_c_m;
//    SI.HeatCapacityMassSpecific cp_h[N_cv];
//    SI.HeatCapacityMassSpecific cp_c[N_cv];
//
//    Real x[N_cv];
//    Real val = pipe_ColdSide.fluid[1].VLE.h_v;
//    Integer Cell_hv "Zelle bei der Phasenwechsel auftritt";
//    Integer Cells_hv_p1=Cell_hv+1;

  inner SimCenter simCenter(
    steamCycleAllowFlowReversal=true,
    useHomotopy=false,
    redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1) annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

  Visualisation.Hexdisplay_3 ConterFlowDisplay(
    y_min=373,
    T_o=NTU.summary.T_o,
    T_i=NTU.summary.T_i,
    yps_o=NTU.summary.eCom.z_o,
    yps_i=NTU.summary.eCom.z_i,
    Unit="CounterFlow",
    y_max=610) annotation (Placement(transformation(extent={{-18,-108},{94,-4}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.NTU_L3_standalone NTU(
    N_t=N_tubes,
    N_p=N_passes,
    length=length,
    outerPhaseChange=false,
    initChoice=ClaRa.Basics.Choices.Init.steadyTemperature,
    redeclare function HeatCapacityAveraging = ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Functions.ArithmeticMean,
    radius_i=radius_i,
    radius_o=radius_o,
    p_o=p_o,
    p_i=p_i,
    h_i_inlet=h_i_in,
    h_o_inlet=h_o_in,
    m_flow_i=m_flow_i,
    m_flow_o=m_flow_o,
    alpha_i=ones(3)*alpha_i,
    alpha_o=ones(3)*alpha_o,
    T_w_i_start=ones(3)*T_i_in,
    T_w_o_start=ones(3)*T_o_in,
    redeclare model HeatExchangerType = ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CounterFlow_L3,
    showExpertSummary=true,
    PI_1ph_in(initType=Modelica.Blocks.Types.InitPID.NoInit),
    PI_2ph(initType=Modelica.Blocks.Types.InitPID.NoInit)) annotation (Placement(transformation(extent={{74,-106},{94,-86}})));

  Hexdisplay_3 hexdisplay_3_2(
    y_min=373,
    T_i=wall_NTU.summary.T_i,
    T_o=wall_NTU.summary.T_o,
    yps_i=wall_NTU.summary.eCom.z_i,
    yps_o=wall_NTU.summary.eCom.z_o,
    Unit="Parallel Flow",
    y_max=610) annotation (Placement(transformation(extent={{128,-108},{240,-4}})));
  Hexdisplay_3 hexdisplay_3_3(
    y_min=373,
    Unit="Cross Flow",
    T_o=wall_NTU1.summary.T_o,
    T_i=wall_NTU1.summary.T_i,
    yps_o=wall_NTU1.summary.eCom.z_o,
    yps_i=wall_NTU1.summary.eCom.z_i,
    y_max=610) annotation (Placement(transformation(extent={{278,-108},{390,-4}})));
  Basics.ControlVolumes.SolidVolumes.NTU_L3_standalone wall_NTU1(
    N_t=N_tubes,
    N_p=N_passes,
    length=length,
    outerPhaseChange=false,
    initChoice=ClaRa.Basics.Choices.Init.steadyTemperature,
    redeclare function HeatCapacityAveraging = ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Functions.ArithmeticMean,
    radius_i=radius_i,
    radius_o=radius_o,
    p_o=p_o,
    p_i=p_i,
    h_i_inlet=h_i_in,
    h_o_inlet=h_o_in,
    m_flow_i=m_flow_i,
    m_flow_o=m_flow_o,
    alpha_i=ones(3)*alpha_i,
    alpha_o=ones(3)*alpha_o,
    T_w_i_start=ones(3)*T_i_in,
    T_w_o_start=ones(3)*T_o_in,
    redeclare model HeatExchangerType = ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CrossFlow_L3,
    showExpertSummary=true,
    PI_2ph(initType=Modelica.Blocks.Types.InitPID.NoInit),
    PI_1ph_in(initType=Modelica.Blocks.Types.InitPID.NoInit)) annotation (Placement(transformation(extent={{368,-108},{388,-88}})));
  Modelica.Blocks.Sources.Ramp T(
    height=20,
    offset=T_o_in,
    duration=10,
    startTime=10)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation
//   for i in 1:pipe_InnerSide.nCells loop
//
//      //x[i]=pipe_ColdSide.fluid[i].h;
//    end for;
//
// //   for i in 1:N_cv loop
// //      if i>=Cell_hv then
// //         cp_h[i]=pipe_HotSide.fluid[i].cp;
// //         cp_c[i]=pipe_ColdSide.fluid[i].cp;
// //      else
// //         cp_h[i]=0;
// //         cp_c[i]=0;
// //      end if;
// //    end for;
//
//   Q_flow_tot=sum(pipe_InnerSide.heat[i].Q_flow for i in 1:N_cv);

//   cp_h_m=sum(cp_h)/(max(1,N_cv-Cell_hv));
//   cp_c_m=sum(cp_c)/(max(1,N_cv-Cell_hv));

 // Cell_hv=integer(ClaRa.Basics.ControlVolumes.SolidVolumes.ValidateThermalElements.findValue_Case2(x,val));

public
  Basics.ControlVolumes.SolidVolumes.NTU_L3_standalone wall_NTU(
    N_t=N_tubes,
    N_p=N_passes,
    length=length,
    outerPhaseChange=false,
    initChoice=ClaRa.Basics.Choices.Init.steadyTemperature,
    radius_i=radius_i,
    radius_o=radius_o,
    p_o=p_o,
    p_i=p_i,
    h_i_inlet=h_i_in,
    h_o_inlet=h_o_in,
    m_flow_i=m_flow_i,
    m_flow_o=m_flow_o,
    alpha_i=ones(3)*alpha_i,
    alpha_o=ones(3)*alpha_o,
    T_w_i_start=ones(3)*T_i_in,
    T_w_o_start=ones(3)*T_o_in,
    redeclare model HeatExchangerType = ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.ParallelFlow_L3,
    redeclare function HeatCapacityAveraging = ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Functions.ArithmeticMean,
    PI_2ph(initType=Modelica.Blocks.Types.InitPID.NoInit),
    PI_1ph_in(initType=Modelica.Blocks.Types.InitPID.NoInit)) annotation (Placement(transformation(extent={{220,-108},{240,-88}})));

  annotation (                                                        Diagram(
        coordinateSystem(extent={{-100,-120},{400,100}}, preserveAspectRatio=true),
        graphics),
    experiment(
      StopTime=30,
      NumberOfIntervals=1500,
      Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true),
        graphics));
end TestHEXdisplay;
