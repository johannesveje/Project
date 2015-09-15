within ClaRa.Components.Furnace.Check;
model Test_boiler
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;
  inner SimCenter simCenter(
    redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1,
    redeclare ClaRa.Basics.Media.Fuel.Coal_Reference fuelModel1,
    redeclare ClaRa.Basics.Media.Fuel.Slag_v2 slagModel,
    useHomotopy=false,
    redeclare TILMedia.GasTypes.FlueGasTILMedia flueGasModel) annotation (Placement(transformation(extent={{-156,272},{-128,296}})));
  BoundaryConditions.BoundaryGas_Txim_flow flueGasFlowSource(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=14*10.396,
    T_const=573.15,
    xi_const={0,0,0.0005,0,0.7681,0.2314,0,0,0})
                    annotation (Placement(transformation(extent={{-102,-48},{-82,-28}})));



  BoundaryConditions.BoundaryGas_Txim_flow flueGasFlowSource1(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=14*10.396,
    T_const=573.15,
    xi_const={0,0,0.0005,0,0.7681,0.2314,0,0,0})
                    annotation (Placement(transformation(extent={{-102,-18},{-82,2}})));










  Adapters.CoalSlagFlueGas_split                                 coalSlagFlueGas_split_top
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={8,234})));
  BoundaryConditions.BoundarySlag_Tm_flow      slagFlowSource_top(m_flow_const=0.0, T_const=658.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={8,278})));
  BoundaryConditions.BoundaryCoal_pTxi            coalSink_top(T_const=658.15)
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,266})));
  BoundaryConditions.BoundaryCoal_Txim_flow    coalFlowSource(
    xi_const={0.661,0.0383,0.066,0.016,0.0057,0.135},
    m_flow_const=15,
    T_const=293.15,
    variable_m_flow=false)
                    annotation (Placement(transformation(extent={{-134,-36},{-114,-16}})));
  Adapters.CoalGas_join coalGas_join_burner(coal_inlet(xi_outflow(start={0.661,
            0.0383,0.066,0.016,0.0057,0.135})))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-32})));
  Adapters.CoalSlagFlueGas_join
    coalSlagFlueGas_join
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={8,-106})));
  BoundaryConditions.BoundaryGas_Txim_flow      fluelGasFlowSource_bottom(
    m_flow_const=0.0,
    T_const=293.15,
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={28,-144})));
  BoundaryConditions.BoundaryCoal_Txim_flow    coalFlowSource_bottom(
    xi_const={0.86,0.035,0.025,0.014,0.007,0.0505},
    m_flow_const=0,
    T_const=293.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-12,-146})));
  BoundaryConditions.BoundarySlag_pT               slaglSink_bottom(T_const=
        373.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={8,-146})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedTemperatureBottom(Q_flow=0)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={78,-102})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureTop(T=658.15)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={82,238})));
  Burner.Burner_L2_Dynamic                    burner1(
    T_slag=873,
    LHV_calculationType="fixed",
    LHV_fixed=25.1e6/0.91,
    redeclare model ParticleMigration =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed (            w_initial=5),
    T_start_flueGas_out=2200,
    redeclare model HeatTransfer_Top =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (
                                                                                                suspension_calculationType="Calculated"),
    xi_start_flueGas_out={0.01,0,0.25,0,0.7,0,0,0.04,0},
    redeclare model ReactionZone =
        ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model RadiationTimeConstant =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ThermalCapacities.ThermalLowPass (
         Tau=0.1),
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (suspension_calculationType="Calculated", CF_fouling=0.95),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        width=10,
        z_in={3},
        z_out={13},
        length=10,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        height=7.5),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=1.1))
                                                                                                annotation (Placement(transformation(extent={{-6,-42},{54,-22}})));
  Hopper.Hopper_L2                    hopper(
    flueGasOutlet(h(start=-22790)),
    SlagTemperature=873,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        width=
          10,
        z_in={0},
        z_out={3},
        height=
          3,
        length=
          10,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal),
    T_start_flueGas_out=780,
    redeclare model HeatTransfer_Top =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (
        emissivity_source_calculationType="Calculate",
        emissivity_sink_calculationType="Calculate",
        absorbance_source_calculationType="Calculate",
        suspension_calculationType="Gas calculated, particles fixed"),
    xi_start_flueGas_out={0.0103,0,0.2270,0.001,0.6999,0.0225,0,0.0393,0},
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (suspension_calculationType="Calculated", CF_fouling=0.95))
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={24,-66})));
  Burner.Burner_L2_Dynamic                    burner2(
    T_slag=873,
    LHV_calculationType="fixed",
    LHV_fixed=25.1e6/0.91,
    xi_coal_in(start={0.661,0.0383,0.066,0.016,0.0057,0.135}),
    redeclare model ParticleMigration =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed (            w_initial=15),
    T_start_flueGas_out=1700,
    redeclare model HeatTransfer_Top =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (
                                                                                                suspension_calculationType="Calculated"),
    xi_start_flueGas_out={0.01,0,0.25,0,0.7,0,0,0.04,0},
    redeclare model ReactionZone =
        ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model RadiationTimeConstant =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ThermalCapacities.ThermalLowPass (
         Tau=0.1),
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (suspension_calculationType="Calculated", CF_fouling=0.95),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        width=10,
        z_in={13},
        z_out={23},
        length=10,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        height=7.5),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=1.1))
                                                                                                annotation (Placement(transformation(extent={{-6,-12},{54,8}})));
  BoundaryConditions.BoundaryCoal_Txim_flow    coalFlowSource1(
    xi_const={0.661,0.0383,0.066,0.016,0.0057,0.135},
    m_flow_const=15,
    T_const=293.15,
    variable_m_flow=false)
                    annotation (Placement(transformation(extent={{-134,-6},{-114,14}})));
  Adapters.CoalGas_join coalGas_join_burner1
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-2})));
  FlameRoom.FlameRoomAdditionalAir_L2_Dynamic               flameRoom_1(
    LHV_fixed=25.1e6/0.91,
    redeclare model ParticleMigration =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed (
         w_initial=16),
    T_start_flueGas_out=1700,
    redeclare model HeatTransfer_Top =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (
         suspension_calculationType="Calculated"),
    xi_start_flueGas_out={0.01,0,0.25,0,0.7,0,0,0.04,0},
    redeclare model ReactionZone =
        ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model RadiationTimeConstant =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ThermalCapacities.ThermalLowPass (
         Tau=0.1),
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (suspension_calculationType="Calculated", CF_fouling=0.95),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        width=10,
        z_in={23},
        z_out={33},
        length=10,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        height=5),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=1.1))
    annotation (Placement(transformation(extent={{-6,16},{54,36}})));
  FlameRoom.FlameRoom_L2_Dynamic               flameRoom_2(
    LHV_fixed=25.1e6/0.91,
    redeclare model ParticleMigration =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed (
         w_initial=16),
    T_start_flueGas_out=1600,
    redeclare model HeatTransfer_Top =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (
         suspension_calculationType="Calculated"),
    xi_start_flueGas_out={0.01,0,0.25,0,0.7,0,0,0.04,0},
    redeclare model ReactionZone =
        ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model RadiationTimeConstant =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ThermalCapacities.ThermalLowPass (
         Tau=0.1),
    m_flow_nom=342,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        width=10,
        z_out={50},
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        z_in={33},
        length=10,
        height=18),
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (suspension_calculationType="Calculated", CF_fouling=0.95),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=1.1))
    annotation (Placement(transformation(extent={{-6,46},{54,66}})));
  FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic               flameRoom_oh_1(
    redeclare model HeatTransfer_Top =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    T_start_flueGas_out=1000,
    LHV_fixed=25.1e6/0.91,
    redeclare model ParticleMigration =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed (
         w_initial=13),
    redeclare model Burning_time =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (
         Tau_burn_const =      1.3),
    xi_start_flueGas_out={0.01,0,0.25,0,0.7,0,0,0.04,0},
    redeclare model ReactionZone =
        ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model RadiationTimeConstant =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ThermalCapacities.ThermalLowPass (
         Tau=0.1),
    m_flow_nom=342,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=80),
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2 (alpha_nom=30),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        width=10,
        length=10,
        diameter_t=0.04,
        Delta_z_par=0.1,
        Delta_z_ort=0.1,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        N_rows=40,
        N_tubes=3000,
        height=6),
    redeclare model HeatTransfer_TubeBundle = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2 (
        epsilon_gas_calculationType="Calculated",
        alpha_gas_calculationType="Calculated",
        CF_fouling=0.95))
    annotation (Placement(transformation(extent={{-6,76},{54,96}})));
  FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic               flameRoom_oh_2(
    redeclare model HeatTransfer_Top =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    LHV_fixed=25.1e6/0.91,
    redeclare model ParticleMigration =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed (
         w_initial=9),
    redeclare model Burning_time =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (
         Tau_burn_const =      1.3),
    T_start_flueGas_out=1300,
    xi_start_flueGas_out={0.01,0,0.25,0,0.7,0,0,0.04,0},
    redeclare model ReactionZone =
        ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model RadiationTimeConstant =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ThermalCapacities.ThermalLowPass (
         Tau=0.1),
    m_flow_nom=342,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=20),
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2 (alpha_nom=30),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        width=10,
        length=10,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        diameter_t=0.04,
        Delta_z_par=0.1,
        Delta_z_ort=0.1,
        N_rows=40,
        N_tubes=4000,
        height=6),
    redeclare model HeatTransfer_TubeBundle = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2 (
        epsilon_gas_calculationType="Calculated",
        alpha_gas_calculationType="Calculated",
        CF_fouling=0.95))
    annotation (Placement(transformation(extent={{-6,122},{54,142}})));
  BoundaryConditions.BoundaryCoal_Txim_flow    coalFlowSource2(
    xi_const={0.661,0.0383,0.066,0.016,0.0057,0.135},
    m_flow_const=0,
    T_const=293.15) annotation (Placement(transformation(extent={{-134,22},{-114,42}})));
  BoundaryConditions.BoundaryGas_Txim_flow      fluelGasFlowSource2(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=2*10.396,
    T_const=573.15,
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01}) annotation (Placement(transformation(extent={{-102,10},{-82,30}})));
  Adapters.CoalGas_join coalGas_join_burner2
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,26})));
  BoundaryConditions.BoundaryVLE_Txim_flow       eco_inlet(
    m_flow_const=400,
    T_const=266 + 273,
    variable_m_flow=false)
                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={264,-140})));
  VolumesValvesFittings.Pipes.PipeFlow_L4_Simple            evap(
    diameter_i=0.03,
    z_in=0,
    N_tubes=300,
    m_flow_nom=400,
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    initType=ClaRa.Basics.Choices.Init.steadyState,
    N_cv=8,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (                      alpha_nom=20000),
    length=80,
    z_out=80,
    h_start=linspace(
        1337e3,
        2333e3,
        evap.N_cv),
    p_start=ones(evap.N_cv)*270e5,
    frictionAtInlet=true,
    frictionAtOutlet=true)         annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={232,18})));
  BoundaryConditions.BoundaryVLE_phxi            pressureSink_ph2(                p_const=29100000, variable_p=false)
                                                                                                    annotation (Placement(transformation(extent={{398,212},{378,230}})));
  VolumesValvesFittings.Pipes.PipeFlow_L4_Simple            ct(
    diameter_i=0.03,
    N_tubes=300,
    m_flow_nom=400,
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    initType=ClaRa.Basics.Choices.Init.steadyState,
    length=30,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (                      alpha_nom=10000),
    z_in=80,
    z_out=50,
    h_start=linspace(
        2333e3,
        2333e3,
        ct.N_cv),
    p_start=ones(ct.N_cv)*270e5,
    N_cv=3,
    frictionAtInlet=true,
    frictionAtOutlet=true)
            annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=-90,
        origin={296,158})));
  Basics.ControlVolumes.SolidVolumes.ThinWall_L4 evap_wall(
    diameter_i=evap.diameter_i,
    length=evap.length,
    N_tubes=evap.N_tubes,
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=evap.N_cv,
    stateLocation=3,
    diameter_o=evap.diameter_i + 0.01,
    initChoice=ClaRa.Basics.Choices.Init.noInit,
    T_start=ones(evap_wall.N_ax)*(273.15 + 300),
    suppressChattering="False") annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={200,18})));
  Basics.ControlVolumes.SolidVolumes.ThinWall_L4 ct_wall(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    stateLocation=3,
    N_ax=ct.N_cv,
    diameter_o=ct.diameter_i + 0.01,
    diameter_i=ct.diameter_i,
    length=ct.length,
    N_tubes=ct.N_tubes,
    initChoice=ClaRa.Basics.Choices.Init.noInit,
    T_start=ones(ct_wall.N_ax)*(273.15 + 395),
    suppressChattering="False") annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={264,158})));
  VolumesValvesFittings.Pipes.PipeFlow_L4_Simple            oh_1(
    diameter_i=0.03,
    m_flow_nom=400,
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    initType=ClaRa.Basics.Choices.Init.steadyState,
    N_cv=4,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (                      alpha_nom=10000),
    N_tubes=100,
    z_in=60,
    z_out=50,
    length=300,
    h_start=linspace(
        2333e3,
        2784e3,
        oh_1.N_cv),
    p_start=ones(oh_1.N_cv)*265e5,
    frictionAtInlet=true,
    frictionAtOutlet=true)         annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=-90,
        origin={296,76})));
  VolumesValvesFittings.Pipes.PipeFlow_L4_Simple            oh_2(
    diameter_i=0.03,
    m_flow_nom=400,
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    initType=ClaRa.Basics.Choices.Init.steadyState,
    N_cv=4,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (                      alpha_nom=10000),
    N_tubes=150,
    z_in=60,
    z_out=70,
    length=300,
    h_start=linspace(
        2784e3,
        2962e3,
        oh_2.N_cv),
    p_start=ones(oh_2.N_cv)*260e5,
    frictionAtInlet=true,
    frictionAtOutlet=true)         annotation (Placement(transformation(
        extent={{10,6},{-10,-6}},
        rotation=-90,
        origin={368,122})));
  Basics.ControlVolumes.SolidVolumes.ThinWall_L4 oh_1_wall(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    stateLocation=3,
    N_ax=oh_1.N_cv,
    diameter_o=oh_1.diameter_i + 0.01,
    diameter_i=oh_1.diameter_i,
    length=oh_1.length,
    N_tubes=oh_1.N_tubes,
    initChoice=ClaRa.Basics.Choices.Init.noInit,
    T_start=ones(oh_1_wall.N_ax)*(273.15 + 330),
    suppressChattering="False") annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={264,76})));
  Basics.ControlVolumes.SolidVolumes.ThinWall_L4 oh_2_wall(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    stateLocation=3,
    N_ax=oh_2.N_cv,
    diameter_o=oh_2.diameter_i + 0.01,
    diameter_i=oh_2.diameter_i,
    length=oh_2.length,
    N_tubes=oh_2.N_tubes,
    initChoice=ClaRa.Basics.Choices.Init.noInit,
    T_start=ones(oh_2_wall.N_ax)*(273.15 + 400),
    suppressChattering="False") annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={336,122})));
  Adapters.Scalar2VectorHeatPort            scalar2VectorHeatPort2(
    length=oh_1.length,
    N=oh_1.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        oh_1.length,
        oh_1.N_cv)) annotation (Placement(transformation(extent={{186,66},{206,86}})));
  Adapters.Scalar2VectorHeatPort            scalar2VectorHeatPort3(
    length=100,
    N=4,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        100,
        4)) annotation (Placement(transformation(extent={{186,112},{206,132}})));
  FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic               flameRoom_eco(
    redeclare model HeatTransfer_Top =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    T_start_flueGas_out=650,
    LHV_fixed=25.1e6/0.91,
    xi_start_flueGas_out={0.01,0,0.25,0,0.7,0,0,0.04,0},
    redeclare model ReactionZone =
        ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model RadiationTimeConstant =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ThermalCapacities.ThermalLowPass (
         Tau=0.1),
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=20),
    m_flow_nom=342,
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2 (alpha_nom=30),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        width=10,
        length=10,
        diameter_t=0.04,
        Delta_z_par=0.13,
        Delta_z_ort=0.11,
        N_rows=40,
        N_tubes=4000,
        height=5),
    redeclare model HeatTransfer_TubeBundle = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.Convection_tubeBank_L2 (CF_fouling=0.95))
    annotation (Placement(transformation(extent={{-6,168},{54,188}})));
  VolumesValvesFittings.Pipes.PipeFlow_L4_Simple            eco(
    N_cv=7,
    diameter_i=0.03,
    m_flow_nom=400,
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    initType=ClaRa.Basics.Choices.Init.steadyState,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (                      alpha_nom=20000),
    N_tubes=150,
    z_in=80,
    z_out=70,
    length=300,
    h_start=linspace(
        1180e3,
        1337e3,
        eco.N_cv),
    p_start=ones(eco.N_cv)*270e5,
    frictionAtInlet=true,
    frictionAtOutlet=true)        annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={232,-56})));
  Basics.ControlVolumes.SolidVolumes.ThinWall_L4 eco_wall(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=eco.N_cv,
    diameter_o=eco.diameter_i + 0.01,
    diameter_i=eco.diameter_i,
    length=eco.length,
    N_tubes=eco.N_tubes,
    initChoice=ClaRa.Basics.Choices.Init.noInit,
    T_start=ones(eco_wall.N_ax)*(273.15 + 280),
    stateLocation=3,
    suppressChattering="False") annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={198,-56})));
  Adapters.Scalar2VectorHeatPort            scalar2VectorHeatPort4(
    length=eco.length,
    N=eco.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco.length,
        eco.N_cv)) annotation (Placement(transformation(extent={{158,-66},{178,-46}})));
  Sensors.Temperature eco_T
    annotation (Placement(transformation(extent={{252,-46},{272,-24}})));
  Sensors.Temperature evap_T
    annotation (Placement(transformation(extent={{252,28},{272,50}})));
  Sensors.Temperature oh_T
    annotation (Placement(transformation(extent={{384,132},{404,154}})));
  BoundaryConditions.BoundaryGas_pTxi
    flueGasPressureSink2(p_const=101300)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={26,264})));
equation
  connect(burner1.heat_bottom,hopper. heat_top) annotation (Line(
      points={{26,-42},{26,-56}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hopper.heat_bottom,fixedTemperatureBottom. port)  annotation (Line(
      points={{26,-76},{26,-102},{68,-102}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner2.heat_top,flameRoom_1. heat_bottom)
    annotation (Line(
      points={{26,8},{26,16}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_1.heat_top,flameRoom_2. heat_bottom)
    annotation (Line(
      points={{26,36},{26,46}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_2.heat_top,flameRoom_oh_1. heat_bottom)      annotation (
      Line(
      points={{26,66},{26,76}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_1.heat_top,flameRoom_oh_2. heat_bottom)
    annotation (Line(
      points={{26,96},{26,122}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner1.heat_top,burner2. heat_bottom)
                                                annotation (Line(
      points={{26,-22},{26,-12}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(evap_wall.innerPhase,evap. heat) annotation (Line(
      points={{210,18},{227.2,18}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hopper.heat_wall,evap_wall. outerPhase[1])  annotation (Line(
      points={{54,-66},{124,-66},{124,18},{190,18}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner1.heat_wall,evap_wall. outerPhase[2])
                                                     annotation (Line(
      points={{54,-32},{124,-32},{124,18},{190,18}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner2.heat_wall,evap_wall. outerPhase[3]) annotation (Line(
      points={{54,-2},{124,-2},{124,18},{190,18}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_1.heat_wall,evap_wall. outerPhase[4])
    annotation (Line(
      points={{54,26},{124,26},{124,18},{190,18}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_2.heat_wall,evap_wall. outerPhase[5]) annotation (Line(
      points={{54,56},{124,56},{124,18},{190,18}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_1.heat_wall,evap_wall. outerPhase[6])      annotation (
      Line(
      points={{54,86},{124,86},{124,18},{190,18}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_2.heat_wall,evap_wall. outerPhase[7])       annotation (
      Line(
      points={{54,132},{124,132},{124,18},{190,18}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ct_wall.innerPhase,ct. heat) annotation (Line(
      points={{274,158},{291.2,158}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort2.heatVector,oh_1_wall. outerPhase) annotation (
      Line(
      points={{206,76},{254,76}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(oh_1_wall.innerPhase,oh_1. heat) annotation (Line(
      points={{274,76},{291.2,76}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_1.heat_TubeBundle,scalar2VectorHeatPort2. heatScalar)
    annotation (Line(
      points={{44,76},{186,76}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_2.heat_TubeBundle,scalar2VectorHeatPort3. heatScalar)
    annotation (Line(
      points={{44,122},{186,122}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort3.heatVector,oh_2_wall. outerPhase)
                                                                  annotation (
      Line(
      points={{206,122},{326,122}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(oh_2_wall.innerPhase,oh_2. heat)
                                         annotation (Line(
      points={{346,122},{363.2,122}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_2.heat_top,flameRoom_eco. heat_bottom)
    annotation (Line(
      points={{26,142},{26,168}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_eco.heat_top,fixedTemperatureTop. port)        annotation (
      Line(
      points={{26,188},{26,238},{72,238}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_eco.heat_TubeBundle,scalar2VectorHeatPort4. heatScalar)
    annotation (Line(
      points={{44,168},{104,168},{104,-56},{158,-56}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort4.heatVector,eco_wall. outerPhase) annotation (
      Line(
      points={{178,-56},{188,-56}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(eco_wall.innerPhase,eco. heat) annotation (Line(
      points={{208,-56},{227.2,-56}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_eco.heat_wall,evap_wall. outerPhase[8])        annotation (
      Line(
      points={{54,178},{124,178},{124,18},{190,18}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_eco.heat_CarrierTubes,ct_wall. outerPhase[1]) annotation (
      Line(
      points={{44,188},{142,188},{142,158},{254,158}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_2.heat_CarrierTubes,ct_wall. outerPhase[2]) annotation (
      Line(
      points={{44,142},{150,142},{150,158},{254,158}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_1.heat_CarrierTubes,ct_wall. outerPhase[3]) annotation (
      Line(
      points={{44,96},{142,96},{142,158},{254,158}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(eco_inlet.steam_a,eco. inlet) annotation (Line(
      points={{254,-140},{232,-140},{232,-66}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(evap.inlet,eco. outlet) annotation (Line(
      points={{232,8},{232,-46}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(eco_T.port,eco. outlet) annotation (Line(
      points={{262,-46},{232,-46}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(evap_T.port,evap. outlet) annotation (Line(
      points={{262,28},{232,28}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ct.inlet,evap. outlet) annotation (Line(
      points={{296,168},{296,190},{232,190},{232,28}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(oh_1.inlet,ct. outlet) annotation (Line(
      points={{296,86},{296,148}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(oh_2.inlet,oh_1. outlet) annotation (Line(
      points={{368,112},{368,44},{296,44},{296,66}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_ph2.steam_a,oh_2. outlet) annotation (Line(
      points={{378,221},{374,221},{374,220},{368,220},{368,132}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(oh_T.port,oh_2. outlet) annotation (Line(
      points={{394,132},{368,132}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_split_top.coalSlagFlueGas_outlet,flameRoom_eco. outlet)
    annotation (Line(
      points={{8,224},{8,188}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_eco.inlet,flameRoom_oh_2. outlet) annotation (Line(
      points={{8,168},{8,142}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_2.inlet,flameRoom_oh_1. outlet) annotation (Line(
      points={{8,122},{8,96}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_1.inlet,flameRoom_2. outlet) annotation (Line(
      points={{8,76},{8,66}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_2.inlet,flameRoom_1. outlet) annotation (Line(
      points={{8,46},{8,36}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_1.inlet,burner2. outlet) annotation (Line(
      points={{8,16},{8,8}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hopper.inlet,coalSlagFlueGas_join. coalSlagFlueGas_outlet)
    annotation (Line(
      points={{8,-76},{8,-96}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hopper.outlet,burner1. inlet) annotation (Line(
      points={{8,-56},{8,-42}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner1.outlet,burner2. inlet) annotation (Line(
      points={{8,-22},{8,-12}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join_burner2.coalDust_outlet,flameRoom_1. coalDust_inlet)
    annotation (Line(
      points={{-40,26},{-6,26}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalFlowSource.coal_a,coalGas_join_burner. coal_inlet) annotation (
      Line(
      points={{-114,-26},{-60,-26}},
      color={27,36,42},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalFlowSource1.coal_a,coalGas_join_burner1. coal_inlet) annotation (
      Line(
      points={{-114,4},{-60,4}},
      color={27,36,42},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalFlowSource2.coal_a,coalGas_join_burner2. coal_inlet) annotation (
      Line(
      points={{-114,32},{-60,32}},
      color={27,36,42},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(slagFlowSource_top.slag_outlet,coalSlagFlueGas_split_top. slag_outlet)
    annotation (Line(
      points={{8,268},{8,244}},
      color={234,171,0},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSink_top.coal_a,coalSlagFlueGas_split_top. coal_inlet)
    annotation (Line(
      points={{-10,256},{-10,250},{2,250},{2,244}},
      color={27,36,42},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_join.coal_inlet,coalFlowSource_bottom. coal_a)
    annotation (Line(
      points={{2,-116},{2,-126},{-12,-126},{-12,-136}},
      color={27,36,42},
      thickness=0.5,
      smooth=Smooth.None));
  connect(slaglSink_bottom.slag_inlet,coalSlagFlueGas_join. slag_outlet)
    annotation (Line(
      points={{8.2,-136},{8.2,-126},{8,-126},{8,-116}},
      color={234,171,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_join.flueGas_inlet,fluelGasFlowSource_bottom. gas_a)
    annotation (Line(
      points={{14,-116},{14,-126},{28,-126},{28,-134}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fluelGasFlowSource2.gas_a,coalGas_join_burner2. flueGas_inlet)
    annotation (Line(
      points={{-82,20},{-60,20}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasFlowSource1.gas_a, coalGas_join_burner1.flueGas_inlet) annotation (Line(
      points={{-82,-8},{-60,-8}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasFlowSource.gas_a, coalGas_join_burner.flueGas_inlet) annotation (Line(
      points={{-82,-38},{-60,-38}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join_burner1.coalDust_outlet, burner2.coalDust_inlet) annotation (Line(
      points={{-40,-2},{-6,-2}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join_burner.coalDust_outlet, burner1.coalDust_inlet) annotation (Line(
      points={{-40,-32},{-6,-32}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_split_top.flueGas_inlet, flueGasPressureSink2.gas_a) annotation (Line(
      points={{14,244},{14,250},{26,250},{26,254}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-160,-160},{420,300}},
          preserveAspectRatio=false),graphics={
                                Text(
          extent={{96,266},{358,258}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="________________________________________________________________
PURPOSE:
>>Tester for different combustion chamber sections

"),                             Text(
          extent={{88,292},{396,282}},
          lineColor={0,128,0},
          fontSize=34,
          textString="TESTED -- 2014-10-08 //LN")}),                     Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            false)),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput);
end Test_boiler;
