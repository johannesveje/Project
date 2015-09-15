within ClaRa.Basics.ControlVolumes.SolidVolumes.Check.DynamicValidation;
model TestNTU_Case1_Validation_Dynamic "Validation with TestThermalElements.TestNTU_Case2"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 0.1 alpha                        //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright © 2013, DYNCAP research team.                                   //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  import SI = ClaRa.Basics.Units;
  parameter Units.Temperature
                           T_i_in = 100+273.15;
  parameter Units.Temperature
                           T_o_in = 300+273.15;
   parameter Units.EnthalpyMassSpecific
                                     h_i_in = TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(), p_i, T_i_in);
   parameter Units.EnthalpyMassSpecific
                                     h_o_in = TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(), p_o, T_o_in);
  parameter Units.MassFlowRate
                            m_flow_i = 10;
  parameter Units.MassFlowRate
                            m_flow_o = 100;
  parameter Units.Pressure
                        p_i = 0.9e5;
  parameter Units.Pressure
                        p_o = 300e5;

  parameter Units.CoefficientOfHeatTransfer
                                         alpha_i = 730;
  parameter Units.CoefficientOfHeatTransfer
                                         alpha_o = 7300;

  parameter Integer N_tubes = 200;
  parameter Integer N_passes = 1;
  parameter Units.Length
                      radius_i = 0.05;
  parameter Units.Length
                      radius_o = 0.05+1e-6;
  parameter Units.Length
                      diameter_i = radius_i*2;
  parameter Units.Length
                      diameter_o = radius_o*2;
  parameter Units.Length
                      length = 4;
  parameter Integer N_cv = 258;

    Units.HeatFlowRate
                    Q_flow_tot;
//    SI.HeatCapacityMassSpecific cp_o_m;
//    SI.HeatCapacityMassSpecific cp_i_m;
//    SI.HeatCapacityMassSpecific cp_o[N_cv];
//    SI.HeatCapacityMassSpecific cp_i[N_cv];

//    Real x[N_cv];
//    Real val = pipe_ColdSide.fluid[1].VLE.h_v;
//    Integer Cell_hv "Zelle bei der Phasenwechsel auftritt";
//    Integer Cells_hv_p1=Cell_hv+1;

  inner SimCenter simCenter(
    steamCycleAllowFlowReversal=true,
    useHomotopy=false,
    redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1) annotation (Placement(transformation(extent={{100,60},{120,80}})));

  Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple pipe_HotSide(
    length=length,
    N_tubes=N_tubes,
    N_cv=N_cv,
    diameter_i=diameter_o,
    Delta_x=ones(N_cv)*length/N_cv,
    m_flow_nom=m_flow_o,
    h_start=linspace(
        1328.89e3,
        1080.51e3,
        N_cv),
    h_nom=linspace(
        1328.89e3,
        1080.51e3,
        N_cv),
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4 (             Delta_p_nom(displayUnit="Pa") = 100),
    p_start=linspace(
        p_o + 100,
        p_o,
        N_cv),
    p_nom=linspace(
        p_o + 100,
        p_o,
        N_cv),
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (                      PL_kc=[0,1; 0.5,1; 0.7,1; 1,1], alpha_nom=alpha_o),
    initType=ClaRa.Basics.Choices.Init.steadyState) annotation (Placement(transformation(extent={{-60,44},{-40,32}})));
  Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple pipe_ColdSide(
    length=length,
    N_tubes=N_tubes,
    N_cv=N_cv,
    diameter_i=diameter_i,
    Delta_x=ones(N_cv)*length/N_cv,
    m_flow_nom=m_flow_i,
    p_start=linspace(
        p_i + 100,
        p_i,
        N_cv),
    p_nom=linspace(
        p_i + 100,
        p_i,
        N_cv),
    h_nom=linspace(
        419240,
        450e3,
        N_cv),
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (                      PL_kc=[0,1; 0.5,1; 0.7,1; 1,1], alpha_nom=alpha_i),
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4 (             Delta_p_nom(displayUnit="Pa") = 100),
    h_start=linspace(
        h_i_in,
        h_i_in + 30000,
        N_cv),
    initType=ClaRa.Basics.Choices.Init.steadyState) annotation (Placement(transformation(extent={{-38,-28},{-58,-16}})));
  Components.BoundaryConditions.BoundaryVLE_Txim_flow OuterSide_in(
    m_flow_const=m_flow_o,
    T_const=T_o_in,
    variable_m_flow=false,
    variable_T=false) annotation (Placement(transformation(extent={{-150,28},{-130,48}})));
  Components.BoundaryConditions.BoundaryVLE_pTxi OuterSide_out(
    Delta_p(displayUnit="Pa"),
    p_const=p_o,
    variable_p=false) annotation (Placement(transformation(extent={{50,28},{30,48}})));
  Components.BoundaryConditions.BoundaryVLE_Txim_flow InnerSide_in(
    variable_m_flow=false,
    m_flow_const=m_flow_i,
    T_const=T_i_in,
    variable_T=true) annotation (Placement(transformation(extent={{50,-32},{30,-12}})));
  Components.BoundaryConditions.BoundaryVLE_pTxi InnerSide_out(
    Delta_p(displayUnit="Pa"),
    p_const=p_i,
    variable_p=false) annotation (Placement(transformation(extent={{-150,-32},{-130,-12}})));
  ClaRa.Components.Sensors.Temperature           Hot_out_degC
    annotation (Placement(transformation(extent={{-30,38},{-10,58}})));
  ClaRa.Components.Sensors.Temperature           Cold_out_degC
    annotation (Placement(transformation(extent={{-84,-22},{-64,-2}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinWall_L4 thinWall(
    diameter_o=diameter_o,
    diameter_i=diameter_i,
    length=length,
    N_tubes=N_tubes,
    N_ax=N_cv,
    Delta_x=ones(N_cv)*length/N_cv,
    T_start=linspace(
        T_o_in,
        T_i_in,
        N_cv),
    initChoice=ClaRa.Basics.Choices.Init.steadyTemperature) annotation (Placement(transformation(extent={{-60,-2},{-40,18}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.NTU_L3_standalone NTU(
    N_t=N_tubes,
    N_p=N_passes,
    length=length,
    radius_i=radius_i,
    radius_o=radius_o,
    m_flow_i=m_flow_i,
    m_flow_o=m_flow_o,
    alpha_i=ones(3)*alpha_i,
    alpha_o=ones(3)*alpha_o,
    outerPhaseChange=false,
    p_o=p_o,
    p_i=p_i,
    redeclare function HeatCapacityAveraging =
        ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Functions.InputOnly,
    h_i_inlet=actualStream(innerVol.inlet.h_outflow),
    h_o_inlet=actualStream(outerVol.inlet.h_outflow),
    initChoice=ClaRa.Basics.Choices.Init.steadyState) annotation (Placement(transformation(extent={{-82,-118},{-54,-96}})));

  Modelica.Blocks.Sources.Ramp T_i(
    offset=T_i_in,
    height=20,
    startTime=500,
    duration=10)
    annotation (Placement(transformation(extent={{106,-34},{86,-14}})));
  Components.BoundaryConditions.BoundaryVLE_Txim_flow OuterSide_in1(
    m_flow_const=m_flow_o,
    T_const=T_o_in,
    variable_m_flow=false,
    variable_T=false) annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Components.BoundaryConditions.BoundaryVLE_pTxi InnerSide_out1(
    Delta_p(displayUnit="Pa"),
    p_const=p_i,
    variable_p=false) annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Components.BoundaryConditions.BoundaryVLE_Txim_flow InnerSide_in1(
    variable_m_flow=false,
    m_flow_const=m_flow_i,
    T_const=T_i_in,
    variable_T=true) annotation (Placement(transformation(extent={{8,-150},{-12,-130}})));
  Components.BoundaryConditions.BoundaryVLE_pTxi OuterSide_out1(
    Delta_p(displayUnit="Pa"),
    p_const=p_o,
    variable_p=false) annotation (Placement(transformation(extent={{8,-90},{-12,-70}})));
  ClaRa.Components.Sensors.Temperature           Cold_out_degC1
    annotation (Placement(transformation(extent={{-104,-140},{-84,-120}})));
  ClaRa.Components.Sensors.Temperature           Hot_out_degC1
    annotation (Placement(transformation(extent={{-50,-80},{-30,-60}})));
  FluidVolumes.VolumeVLE_2 outerVol(
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        diameter=
          diameter_o,
        length=
          length,
        N_tubes=N_tubes,
        N_passes=N_passes),
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (
         alpha_nom=
                alpha_o, PL_alpha=
                            [0,1; 0.5,1]),
    m_flow_nom=m_flow_o,
    p_nom=p_o,
    h_nom=h_o_in,
    h_start=2000e3,
    p_start=30000000,
    initType=ClaRa.Basics.Choices.Init.steadyEnthalpy,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred (position_Delta_p_geo="inlet"))
    annotation (Placement(transformation(extent={{-85,-70},{-65,-90}})));
  FluidVolumes.VolumeVLE_2 innerVol(
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (
         alpha_nom=
                alpha_i, PL_alpha=
                            [0,1; 0.5,1]),
    m_flow_nom=m_flow_i,
    p_nom=p_i,
    h_nom=h_i_in,
    initType=ClaRa.Basics.Choices.Init.steadyEnthalpy,
    h_start=3000e3,
    p_start=90000,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred (position_Delta_p_geo="inlet"))
    annotation (Placement(transformation(extent={{-51,-150},{-71,-130}})));
  Visualisation.Hexdisplay_3 hexdisplay_3_1(
    Unit="HEX wall",
    y_min=373,
    y_max=573,
    T_o=NTU.summary.T_o,
    T_i=NTU.summary.T_i,
    yps_o=NTU.summary.eCom.z_o,
    yps_i=NTU.summary.eCom.z_i) annotation (Placement(transformation(extent={{58,-160},{170,-56}})));
equation
  for i in 1:pipe_ColdSide.N_cv loop

     connect(pipe_ColdSide.heat[i], thinWall.innerPhase[(pipe_ColdSide.N_cv+1)-i]);
    // x[i]=pipe_ColdSide.fluid[i].h;
   end for;

//   for i in 1:N_cv loop
//      if i>=Cell_hv then
//         cp_o[i]=pipe_HotSide.fluid[i].cp;
//         cp_i[i]=pipe_ColdSide.fluid[i].cp;
//      else
//         cp_o[i]=0;
//         cp_i[i]=0;
//      end if;
//    end for;

  Q_flow_tot=sum(pipe_ColdSide.heat[i].Q_flow for i in 1:N_cv);

//   cp_o_m=sum(cp_o)/(max(1,N_cv-Cell_hv));
//   cp_i_m=sum(cp_i)/(max(1,N_cv-Cell_hv));

 // Cell_hv=integer(ClaRa.Basics.ControlVolumes.SolidVolumes.ValidateThermalElements.findValue_Case2(x,val));

  connect(pipe_HotSide.outlet,Hot_out_degC. port) annotation (Line(
      points={{-40,38},{-20,38}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Cold_out_degC.port,pipe_ColdSide. outlet) annotation (Line(
      points={{-74,-22},{-58,-22}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(OuterSide_in.steam_a,pipe_HotSide. inlet)
                                              annotation (Line(
      points={{-130,38},{-60,38}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pipe_ColdSide.inlet,InnerSide_in. steam_a)
                                                annotation (Line(
      points={{-38,-22},{30,-22}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pipe_HotSide.heat,thinWall. outerPhase)     annotation (Line(
      points={{-50,33.2},{-50,18}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Hot_out_degC.port,OuterSide_out. steam_a) annotation (Line(
      points={{-20,38},{30,38}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Cold_out_degC.port,InnerSide_out. steam_a) annotation (Line(
      points={{-74,-22},{-130,-22}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_i.y, InnerSide_in.T) annotation (Line(
      points={{85,-24},{68,-24},{68,-22},{52,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(innerVol.inlet, InnerSide_in1.steam_a)      annotation (Line(
      points={{-51,-140},{-12,-140}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(innerVol.outlet, Cold_out_degC1.port)      annotation (Line(
      points={{-71,-140},{-94,-140}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Cold_out_degC1.port, InnerSide_out1.steam_a) annotation (Line(
      points={{-94,-140},{-120,-140}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(outerVol.outlet, Hot_out_degC1.port)      annotation (Line(
      points={{-65,-80},{-40,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Hot_out_degC1.port, OuterSide_out1.steam_a) annotation (Line(
      points={{-40,-80},{-12,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(outerVol.inlet, OuterSide_in1.steam_a)      annotation (Line(
      points={{-85,-80},{-120,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(InnerSide_in1.T, T_i.y) annotation (Line(
      points={{10,-140},{68,-140},{68,-24},{85,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(outerVol.heat, NTU.outerPhase[1]) annotation (Line(
      points={{-75,-90},{-75,-94},{-68,-94},{-68,-96.7333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(outerVol.heat, NTU.outerPhase[2]) annotation (Line(
      points={{-75,-90},{-75,-94},{-68,-94},{-68,-96}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(outerVol.heat, NTU.outerPhase[3]) annotation (Line(
      points={{-75,-90},{-75,-92},{-68,-92},{-68,-95.2667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(NTU.innerPhase[1], innerVol.heat) annotation (Line(
      points={{-68,-118.733},{-68,-130},{-61,-130}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(NTU.innerPhase[2], innerVol.heat) annotation (Line(
      points={{-68,-118},{-68,-130},{-61,-130}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(NTU.innerPhase[3], innerVol.heat) annotation (Line(
      points={{-68,-117.267},{-68,-130},{-61,-130}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (                                                        Diagram(
        coordinateSystem(extent={{-160,-160},{160,100}}, preserveAspectRatio=true),
        graphics),
    experiment(
      StopTime=1500,
      NumberOfIntervals=1500,
      Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-160,-160},{160,100}})));
end TestNTU_Case1_Validation_Dynamic;
