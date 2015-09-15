within ClaRa.Basics.ControlVolumes.SolidVolumes.Check.DynamicValidation;
model Validation_Dynamic_T_step_behaviour "Temperature behaviour under a T-step"
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
                            T_i_in = 400;
   parameter Units.Temperature
                            T_o_in = 500;
  parameter Units.EnthalpyMassSpecific
                                    h_i_in = TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(), p_i, T_i_in);
  parameter Units.EnthalpyMassSpecific
                                    h_o_in = TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(), p_o, T_o_in);
   parameter Units.MassFlowRate
                             m_flow_i = 20;
   parameter Units.MassFlowRate
                             m_flow_o = 20;
   parameter Units.Pressure
                         p_i = 5e5;
   parameter Units.Pressure
                         p_o = 5e5;

  parameter Units.CoefficientOfHeatTransfer
                                         alpha_i = 100;
  parameter Units.CoefficientOfHeatTransfer
                                         alpha_o = 100;

   parameter Integer N_tubes = 1;
   parameter Integer N_passes = 1;
  parameter Units.Length
                      radius_i = 0.05;
  parameter Units.Length
                      radius_o = (0.05+1e-6);
  parameter Units.Length
                      diameter_i = radius_i*2;
  parameter Units.Length
                      diameter_o = radius_o*2;

   parameter Units.Length
                       length = 3;
   parameter Integer N_cv = 200;

  Units.HeatFlowRate
                  Q_flow_tot;

  Units.HeatFlowRate
                  Q_flow_wall_inner=sum(wall.innerPhase.Q_flow);
  Units.HeatFlowRate
                  Q_flow_wall_outer=sum(wall.outerPhase.Q_flow);

  inner SimCenter simCenter(
    steamCycleAllowFlowReversal=true,
    useHomotopy=false,
    redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1) annotation (Placement(transformation(extent={{100,60},{120,80}})));

  Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple pipe_HotSide(
    length=length,
    N_cv=N_cv,
    Delta_x=ones(N_cv)*length/N_cv,
    m_flow_nom=m_flow_o,
    h_nom=linspace(
        1328.89e3,
        1080.51e3,
        N_cv),
    p_nom=linspace(
        p_o + 100,
        p_o,
        N_cv),
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (PL_kc=[0,1; 0.5,1; 0.7,1; 1,1], alpha_nom=alpha_o),
    h_start=ones(N_cv)*2990.1e3,
    p_start=ones(N_cv)*p_o,
    initType=ClaRa.Basics.Choices.Init.steadyState,
    diameter_i=diameter_o,
    N_tubes=1,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4 (Delta_p_nom(displayUnit="Pa") = 100),
    frictionAtInlet=false,
    frictionAtOutlet=true) annotation (Placement(transformation(extent={{-60,44},{-40,32}})));
  Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple pipe_ColdSide(
    length=length,
    N_tubes=N_tubes,
    N_cv=N_cv,
    diameter_i=diameter_i,
    Delta_x=ones(N_cv)*length/N_cv,
    m_flow_nom=m_flow_i,
    p_nom=linspace(
        p_i + 100,
        p_i,
        N_cv),
    h_nom=linspace(
        419240,
        450e3,
        N_cv),
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (PL_kc=[0,1; 0.5,1; 0.7,1; 1,1], alpha_nom=alpha_i),
    h_start=ones(N_cv)*2527.31e3,
    p_start=ones(N_cv)*p_i,
    initType=ClaRa.Basics.Choices.Init.steadyState,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4 (Delta_p_nom=10000000),
    frictionAtInlet=false,
    frictionAtOutlet=true) annotation (Placement(transformation(extent={{-40,-28},{-60,-16}})));
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
    diameter_i=diameter_i,
    length=length,
    N_tubes=N_tubes,
    T_start=linspace(
        T_o_in,
        T_i_in,
        N_cv),
    initChoice=ClaRa.Basics.Choices.Init.steadyTemperature,
    diameter_o=diameter_i + 1e-6,
    N_ax=N_cv,
    Delta_x=ones(N_cv)*N_cv/length) annotation (Placement(transformation(extent={{-60,-2},{-40,18}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.NTU_L3_standalone wall(
    N_t=N_tubes,
    N_p=N_passes,
    length=length,
    radius_i=radius_i,
    alpha_i=ones(3)*alpha_i,
    alpha_o=ones(3)*alpha_o,
    outerPhaseChange=false,
    p_o=p_o,
    p_i=p_i,
    redeclare function HeatCapacityAveraging =
        ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Functions.InputOnly,
    initChoice=ClaRa.Basics.Choices.Init.noInit,
    h_i_inlet=innerVol.fluidIn.h,
    h_o_inlet=outerVol.fluidIn.h,
    m_flow_i=innerVol.inlet.m_flow,
    m_flow_o=outerVol.inlet.m_flow,
    mass_struc=1,
    redeclare model HeatExchangerType =
        ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CounterFlow_L3,
    radius_o=radius_o) annotation (Placement(transformation(extent={{-58,-134},{-30,-112}})));

  Modelica.Blocks.Sources.Ramp T_i(
    offset=T_i_in,
    duration=10,
    startTime=600,
    height=-20)
    annotation (Placement(transformation(extent={{106,-32},{86,-12}})));
  Components.BoundaryConditions.BoundaryVLE_Txim_flow OuterSide_in1(
    m_flow_const=m_flow_o,
    T_const=T_o_in,
    variable_m_flow=false,
    variable_T=false) annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Components.BoundaryConditions.BoundaryVLE_pTxi InnerSide_out1(
    Delta_p(displayUnit="Pa"),
    p_const=p_i,
    variable_p=false) annotation (Placement(transformation(extent={{-120,-170},{-100,-150}})));
  Components.BoundaryConditions.BoundaryVLE_Txim_flow InnerSide_in1(
    variable_m_flow=false,
    m_flow_const=m_flow_i,
    T_const=T_i_in,
    variable_T=true) annotation (Placement(transformation(extent={{32,-170},{12,-150}})));
  Components.BoundaryConditions.BoundaryVLE_pTxi OuterSide_out1(
    Delta_p(displayUnit="Pa"),
    p_const=p_o,
    variable_p=false) annotation (Placement(transformation(extent={{32,-100},{12,-80}})));
  ClaRa.Components.Sensors.Temperature           Cold_out_degC1
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  ClaRa.Components.Sensors.Temperature           Hot_out_degC1
    annotation (Placement(transformation(extent={{-26,-90},{-6,-70}})));
  FluidVolumes.VolumeVLE_2 outerVol(
    m_flow_nom=m_flow_o,
    p_nom=p_o,
    h_nom=h_o_in,
    p_start=p_o,
    h_start=3250e3,
    initType=ClaRa.Basics.Choices.Init.steadyEnthalpy,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (
                                                                            alpha_nom=
            alpha_o, PL_alpha=
                        [0,1; 1,1]),
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowCylinderWithTubes (
        orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
        diameter=
          diameter_o,
        length=
          length,
        diameter_t=
            diameter_i,
        length_tubes=
                length,
        N_tubes=N_tubes,
        N_passes=N_passes,
        parallelTubes=true),
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred (position_Delta_p_geo="inlet"))
    annotation (Placement(transformation(extent={{-61,-80},{-41,-100}})));

  FluidVolumes.VolumeVLE_2 innerVol(
    m_flow_nom=m_flow_i,
    p_nom=p_i,
    h_nom=h_i_in,
    h_start=2527.31e3,
    p_start=p_i,
    initType=ClaRa.Basics.Choices.Init.steadyEnthalpy,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (
                                                                            alpha_nom=
            alpha_i, PL_alpha=
                        [0,1; 1,1]),
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        diameter=
          diameter_i,
        length=
          length,
        N_tubes=N_tubes,
        N_passes=N_passes),
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred (position_Delta_p_geo="inlet"))
    annotation (Placement(transformation(extent={{-27,-170},{-47,-150}})));

equation
  for i in 1:pipe_ColdSide.N_cv loop

       connect(pipe_ColdSide.heat[i], thinWall.innerPhase[(pipe_ColdSide.N_cv+1)-i]);
    end for;

Q_flow_tot=sum(pipe_ColdSide.heat[i].Q_flow for i in 1:pipe_ColdSide.N_cv);

  connect(pipe_HotSide.outlet,Hot_out_degC. port) annotation (Line(
      points={{-40,38},{-20,38}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Cold_out_degC.port,pipe_ColdSide. outlet) annotation (Line(
      points={{-74,-22},{-60,-22}},
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
      points={{-40,-22},{30,-22}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pipe_HotSide.heat, thinWall.outerPhase)     annotation (Line(
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
      points={{85,-22},{52,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(innerVol.inlet, InnerSide_in1.steam_a)      annotation (Line(
      points={{-27,-160},{12,-160}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(innerVol.outlet, Cold_out_degC1.port)      annotation (Line(
      points={{-47,-160},{-70,-160}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Cold_out_degC1.port, InnerSide_out1.steam_a) annotation (Line(
      points={{-70,-160},{-100,-160}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(outerVol.outlet, Hot_out_degC1.port)      annotation (Line(
      points={{-41,-90},{-16,-90}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Hot_out_degC1.port, OuterSide_out1.steam_a) annotation (Line(
      points={{-16,-90},{12,-90}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(outerVol.inlet, OuterSide_in1.steam_a)      annotation (Line(
      points={{-61,-90},{-100,-90}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(InnerSide_in1.T, T_i.y) annotation (Line(
      points={{34,-160},{68,-160},{68,-22},{85,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wall.innerPhase[1], innerVol.heat) annotation (Line(
      points={{-44,-134.733},{-44,-150},{-37,-150}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wall.innerPhase[2], innerVol.heat) annotation (Line(
      points={{-44,-134},{-44,-150},{-37,-150}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wall.innerPhase[3], innerVol.heat) annotation (Line(
      points={{-44,-133.267},{-44,-150},{-37,-150}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(outerVol.heat, wall.outerPhase[1]) annotation (Line(
      points={{-51,-100},{-51,-106},{-44,-106},{-44,-112.733}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(outerVol.heat, wall.outerPhase[2]) annotation (Line(
      points={{-51,-100},{-51,-106},{-44,-106},{-44,-112}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(outerVol.heat, wall.outerPhase[3]) annotation (Line(
      points={{-51,-100},{-51,-106},{-44,-106},{-44,-111.267}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (                                                        Diagram(
        coordinateSystem(extent={{-180,-180},{140,80}},  preserveAspectRatio=true),
        graphics),
    experiment(
      StopTime=1500,
      NumberOfIntervals=3000,
      Tolerance=1e-006,
      Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equdistant=false),
    Icon(coordinateSystem(extent={{-180,-180},{140,80}})));
end Validation_Dynamic_T_step_behaviour;
