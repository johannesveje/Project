within ClaRa.Examples;
model BoilerExample
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExample100;

  inner SimCenter simCenter(
    redeclare ClaRa.Basics.Media.Fuel.Coal_Reference fuelModel1,
    redeclare ClaRa.Basics.Media.Fuel.Slag_v2 slagModel,
    useHomotopy=false,
    redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1,
    redeclare TILMedia.GasTypes.FlueGasTILMedia flueGasModel) annotation (Placement(transformation(extent={{450,368},{470,388}})));

  Components.Adapters.CoalSlagFlueGas_split                      coalSlagFlueGas_split_top
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={42,270})));
  Components.BoundaryConditions.BoundarySlag_Tm_flow
                                               slagFlowSource_top(m_flow_const=0.0, T_const=658.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={42,314})));
  Components.BoundaryConditions.BoundaryCoal_pTxi coalSink_top(T_const=658.15)
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={18,302})));
  Components.BoundaryConditions.BoundaryCoal_Txim_flow
                                               coalFlowSource(
    xi_const={0.661,0.0383,0.066,0.016,0.0057,0.135},
    m_flow_const=15,
    variable_m_flow=true,
    T_const=293.15) annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Components.Adapters.CoalGas_join
                        coalGas_join_burner(coal_inlet(xi_outflow(start={0.661,
            0.0383,0.066,0.016,0.0057,0.135})))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-56,4})));
  Components.Adapters.CoalSlagFlueGas_join
    coalSlagFlueGas_join
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={42,-70})));
  Components.BoundaryConditions.BoundaryGas_Txim_flow
                                                fluelGasFlowSource_bottom(
    m_flow_const=0.0,
    T_const=293.15,
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={62,-108})));
  Components.BoundaryConditions.BoundaryCoal_Txim_flow
                                               coalFlowSource_bottom(
    xi_const={0.86,0.035,0.025,0.014,0.007,0.0505},
    m_flow_const=0,
    T_const=293.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={22,-110})));
  Components.BoundaryConditions.BoundarySlag_pT    slaglSink_bottom(T_const=
        373.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={42,-110})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedTemperatureBottom(Q_flow=0)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={112,-66})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureTop(T=658.15)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={116,274})));
  Components.Furnace.Burner.Burner_L2_Dynamic burner1(
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
                                                                                                annotation (Placement(transformation(extent={{28,-6},{88,14}})));

  Components.Furnace.Hopper.Hopper_L2 hopper(
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
        origin={58,-30})));

  Components.Furnace.Burner.Burner_L2_Dynamic burner2(
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
                                                                                                annotation (Placement(transformation(extent={{28,24},{88,44}})));

  Components.BoundaryConditions.BoundaryCoal_Txim_flow
                                               coalFlowSource1(
    xi_const={0.661,0.0383,0.066,0.016,0.0057,0.135},
    m_flow_const=15,
    variable_m_flow=true,
    T_const=293.15) annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Components.Adapters.CoalGas_join
                        coalGas_join_burner1
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-56,34})));
  Components.Furnace.FlameRoom.FlameRoomAdditionalAir_L2_Dynamic
                                                            flameRoom_1(
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
    annotation (Placement(transformation(extent={{28,52},{88,72}})));

  Components.Furnace.FlameRoom.FlameRoom_L2_Dynamic
                                               flameRoom_2(
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
    annotation (Placement(transformation(extent={{28,82},{88,102}})));

  Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic
                                                             flameRoom_oh_1(
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
    annotation (Placement(transformation(extent={{28,112},{88,132}})));

  Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic
                                                             flameRoom_oh_2(
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
    annotation (Placement(transformation(extent={{28,158},{88,178}})));

  Components.BoundaryConditions.BoundaryCoal_Txim_flow
                                               coalFlowSource2(
    xi_const={0.661,0.0383,0.066,0.016,0.0057,0.135},
    m_flow_const=0,
    T_const=293.15) annotation (Placement(transformation(extent={{-140,58},{-120,78}})));
  Components.BoundaryConditions.BoundaryGas_Txim_flow
                                                fluelGasFlowSource2(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=2*10.396,
    T_const=573.15,
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01}) annotation (Placement(transformation(extent={{-108,46},{-88,66}})));
  Components.Adapters.CoalGas_join
                        coalGas_join_burner2
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-56,62})));
  Components.BoundaryConditions.BoundaryVLE_Txim_flow
                                                 eco_inlet(
    m_flow_const=400,
    variable_m_flow=true,
    T_const=266 + 273)    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={298,-104})));
  Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple evap(
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
        origin={266,54})));
  Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_ph2(
                                                                 variable_p=true, p_const=29100000) annotation (Placement(transformation(extent={{432,248},{412,266}})));
  Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple ct(
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
        origin={330,194})));
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
        origin={234,54})));
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
        origin={298,194})));
  Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple oh_1(
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
        origin={330,112})));
  Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple oh_2(
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
        origin={402,158})));
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
        origin={298,112})));
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
        origin={370,158})));
  Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort2(
    length=oh_1.length,
    N=oh_1.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        oh_1.length,
        oh_1.N_cv)) annotation (Placement(transformation(extent={{220,102},{240,122}})));
  Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort3(
    length=100,
    N=4,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        100,
        4)) annotation (Placement(transformation(extent={{220,148},{240,168}})));
  Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic
                                                             flameRoom_eco(
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
    annotation (Placement(transformation(extent={{28,204},{88,224}})));

  Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple eco(
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
        origin={266,-20})));
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
        origin={232,-20})));
  Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort4(
    length=eco.length,
    N=eco.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco.length,
        eco.N_cv)) annotation (Placement(transformation(extent={{192,-30},{212,-10}})));
  Components.Sensors.Temperature
                      eco_T
    annotation (Placement(transformation(extent={{286,-10},{306,12}})));
  Components.Sensors.Temperature
                      evap_T
    annotation (Placement(transformation(extent={{286,64},{306,86}})));
  Components.Sensors.Temperature
                      oh_T
    annotation (Placement(transformation(extent={{418,168},{438,190}})));
  Components.Utilities.Blocks.LimPID PID_lambda(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ni=0.90,
    y_max=600,
    y_min=100,
    y_start=28*10.396,
    sign=1,
    u_ref=1.12,
    y_ref=28*10.369,
    k=1,
    Tau_i=1,
    y_inactive=28*10.369,
    t_activation=0,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput)
    annotation (Placement(transformation(extent={{-326,68},{-346,48}})));
  Modelica.Blocks.Sources.RealExpression actual_lambda(y=burner1.lambdaComb_primary) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-264,84})));
  Modelica.Blocks.Sources.Ramp lambda(
    offset=1.12,
    height=0.03,
    duration=1000,
    startTime=4000)
    annotation (Placement(transformation(extent={{-256,-40},{-276,-20}})));
  Modelica.Blocks.Sources.Ramp coalMassFlow(
    height=-0.25*15,
    duration=1000,
    startTime=4000,
    offset=15)
    annotation (Placement(transformation(extent={{-194,48},{-174,68}})));
  Modelica.Blocks.Sources.Ramp feedWaterMassFlow(
    duration=1000,
    startTime=4000,
    height=-0.3*375,
    offset=375)
    annotation (Placement(transformation(extent={{364,-120},{344,-100}})));
  Modelica.Blocks.Sources.Ramp lifeSteamPressure(
    offset=260e5,
    height=-0.3*260e5,
    duration=1000,
    startTime=4000)
    annotation (Placement(transformation(extent={{482,252},{462,272}})));
  Components.Mills.HardCoalMills.VerticalMill_L3 mill(initChoice=ClaRa.Basics.Choices.Init.steadyState)
    annotation (Placement(transformation(extent={{-20,-6},{0,14}})));
  Components.Mills.HardCoalMills.VerticalMill_L3 mill1(initChoice=ClaRa.Basics.Choices.Init.steadyState)
    annotation (Placement(transformation(extent={{-22,24},{-2,44}})));
  Modelica.Blocks.Sources.Ramp classifierSpeed(
    duration=10,
    offset=1.50,
    startTime=900,
    height=0)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Components.BoundaryConditions.BoundaryGas_pTxi
    flueGasPressureSink2(p_const=101300)
    annotation (Placement(transformation(extent={{-200,190},{-220,210}})));
  Components.BoundaryConditions.BoundaryGas_Txim_flow
                                                fluelGasFlowSource4(
    variable_T=false,
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01},
    m_flow_const=291,
    variable_m_flow=true,
    T_const=313.15) annotation (Placement(transformation(extent={{-296,190},{
            -276,210}})));
  Components.HeatExchangers.RegenerativeAirPreheater_L4_array regenerativeAirPreheater(
    s_sp=0.6e-3,
    redeclare model Material = TILMedia.SolidTypes.TILMedia_St35_8,
    A_flueGas=0.45*(regenerativeAirPreheater.A_cross - regenerativeAirPreheater.A_hub),
    A_air=0.45*(regenerativeAirPreheater.A_cross - regenerativeAirPreheater.A_hub),
    diameter_reg=10,
    height_reg=3,
    N_sp=1000,
    N_cv=10,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    Delta_p_flueGas_nom=1000,
    Delta_p_freshAir_nom=1000,
    m_flow_freshAir_nom=291,
    m_flow_flueGas_nom=341,
    xi_start_flueGas={0.01,0,0.25,0,0.7,0,0,0.04,0},
    xi_start_freshAir={0,0,0.0005,0,0.7581,0.2314,0,0,0.01},
    T_start_wall={385,675},
    T_start_flueGas={677,398},
    T_start_freshAir={376,673},
    p_start_freshAir={142169,141311},
    p_start_flueGas={100002,99000},
    frictionAtFlueGasInlet=false,
    frictionAtFlueGasOutlet=false,
    frictionAtFreshAirInlet=false,
    frictionAtFreshAirOutlet=true) annotation (Placement(transformation(extent={{-258,154},{-238,174}})));

  Components.VolumesValvesFittings.Fittings.FlueGasJunction_L2
    flueGasJunction1(
    volume=1,
    portA(m_flow(fixed=false)),
    portB(m_flow(fixed=false)),
    mixingRatio_initial={0,0,0.0005,0,0.7581,0.2314,0,0,0.01},
    T_start=273.15 + 40,
    p_start=1.4e5)                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-216,130})));
  Components.VolumesValvesFittings.Valves.ValveGas_L1     flueGasValve_L1_1(
      redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         Delta_p_nom=1000, m_flow_nom=200))
    annotation (Placement(transformation(extent={{-160,124},{-140,138}})));

  Components.VolumesValvesFittings.Valves.ValveGas_L1     flueGasValve_L1_2(
      redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         Delta_p_nom=1000, m_flow_nom=200))
    annotation (Placement(transformation(extent={{-160,94},{-140,108}})));

  Modelica.Blocks.Sources.Ramp lambda1(
    duration=1000,
    height=-0.03,
    offset=1.15,
    startTime=7000)
    annotation (Placement(transformation(extent={{-254,30},{-274,50}})));
  Modelica.Blocks.Logical.Switch switch_OnOff
    annotation (Placement(transformation(extent={{-294,16},{-312,-2}})));
  Modelica.Blocks.Sources.BooleanExpression activation2(y=time < 7000)
                                                                      annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-265,6})));
  Components.Sensors.vlePressureSensor ecoOut_p annotation (Placement(transformation(extent={{286,36},{306,56}})));
  Components.Sensors.vleMassflowSensor vleMassflowSensor annotation (Placement(transformation(extent={{282,212},{302,232}})));
equation
  connect(burner1.heat_bottom, hopper.heat_top) annotation (Line(
      points={{60,-6},{60,-20}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hopper.heat_bottom, fixedTemperatureBottom.port)  annotation (Line(
      points={{60,-40},{60,-66},{102,-66}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner2.heat_top,flameRoom_1. heat_bottom)
    annotation (Line(
      points={{60,44},{60,52}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_1.heat_top,flameRoom_2. heat_bottom)
    annotation (Line(
      points={{60,72},{60,82}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_2.heat_top,flameRoom_oh_1. heat_bottom)      annotation (
      Line(
      points={{60,102},{60,112}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_1.heat_top,flameRoom_oh_2. heat_bottom)
    annotation (Line(
      points={{60,132},{60,158}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner1.heat_top, burner2.heat_bottom)
                                                annotation (Line(
      points={{60,14},{60,24}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(evap_wall.innerPhase,evap. heat) annotation (Line(
      points={{244,54},{261.2,54}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hopper.heat_wall, evap_wall.outerPhase[1])  annotation (Line(
      points={{88,-30},{158,-30},{158,54},{224,54}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner1.heat_wall, evap_wall.outerPhase[2])
                                                     annotation (Line(
      points={{88,4},{158,4},{158,54},{224,54}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner2.heat_wall,evap_wall. outerPhase[3]) annotation (Line(
      points={{88,34},{158,34},{158,54},{224,54}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_1.heat_wall,evap_wall. outerPhase[4])
    annotation (Line(
      points={{88,62},{158,62},{158,54},{224,54}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_2.heat_wall,evap_wall. outerPhase[5]) annotation (Line(
      points={{88,92},{158,92},{158,54},{224,54}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_1.heat_wall,evap_wall. outerPhase[6])      annotation (
      Line(
      points={{88,122},{158,122},{158,54},{224,54}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_2.heat_wall,evap_wall. outerPhase[7])       annotation (
      Line(
      points={{88,168},{158,168},{158,54},{224,54}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ct_wall.innerPhase,ct. heat) annotation (Line(
      points={{308,194},{325.2,194}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort2.heatVector,oh_1_wall. outerPhase) annotation (
      Line(
      points={{240,112},{288,112}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(oh_1_wall.innerPhase,oh_1. heat) annotation (Line(
      points={{308,112},{325.2,112}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_1.heat_TubeBundle,scalar2VectorHeatPort2. heatScalar)
    annotation (Line(
      points={{78,112},{220,112}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_2.heat_TubeBundle,scalar2VectorHeatPort3. heatScalar)
    annotation (Line(
      points={{78,158},{220,158}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort3.heatVector,oh_2_wall. outerPhase)
                                                                  annotation (
      Line(
      points={{240,158},{360,158}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(oh_2_wall.innerPhase,oh_2. heat)
                                         annotation (Line(
      points={{380,158},{397.2,158}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_2.heat_top,flameRoom_eco. heat_bottom)
    annotation (Line(
      points={{60,178},{60,204}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_eco.heat_top,fixedTemperatureTop. port)        annotation (
      Line(
      points={{60,224},{60,274},{106,274}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_eco.heat_TubeBundle,scalar2VectorHeatPort4. heatScalar)
    annotation (Line(
      points={{78,204},{138,204},{138,-20},{192,-20}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort4.heatVector,eco_wall. outerPhase) annotation (
      Line(
      points={{212,-20},{222,-20}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(eco_wall.innerPhase,eco. heat) annotation (Line(
      points={{242,-20},{261.2,-20}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_eco.heat_wall,evap_wall. outerPhase[8])        annotation (
      Line(
      points={{88,214},{158,214},{158,54},{224,54}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PID_lambda.u_m,actual_lambda. y) annotation (Line(
      points={{-336,70},{-336,84},{-275,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalMassFlow.y, coalFlowSource1.m_flow) annotation (Line(
      points={{-173,58},{-156,58},{-156,46},{-140,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalMassFlow.y, coalFlowSource.m_flow) annotation (Line(
      points={{-173,58},{-156,58},{-156,16},{-140,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(feedWaterMassFlow.y, eco_inlet.m_flow) annotation (Line(
      points={{343,-110},{310,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lifeSteamPressure.y, pressureSink_ph2.p) annotation (Line(
      points={{461,262},{446.5,262},{446.5,262.4},{432,262.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(classifierSpeed.y, mill.classifierSpeed) annotation (Line(
      points={{-39,-30},{-24,-30},{-24,14.8},{-10,14.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(classifierSpeed.y, mill1.classifierSpeed) annotation (Line(
      points={{-39,-30},{-24,-30},{-24,44.8},{-12,44.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(flameRoom_eco.heat_CarrierTubes, ct_wall.outerPhase[1]) annotation (
      Line(
      points={{78,224},{176,224},{176,194},{288,194}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_2.heat_CarrierTubes, ct_wall.outerPhase[2]) annotation (
      Line(
      points={{78,178},{184,178},{184,194},{288,194}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_1.heat_CarrierTubes, ct_wall.outerPhase[3]) annotation (
      Line(
      points={{78,132},{176,132},{176,194},{288,194}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(activation2.y, switch_OnOff.u2) annotation (Line(
      points={{-276,6},{-284.1,6},{-284.1,7},{-292.2,7}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(PID_lambda.u_s, switch_OnOff.y) annotation (Line(
      points={{-324,58},{-320,58},{-320,7},{-312.9,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lambda.y, switch_OnOff.u1) annotation (Line(
      points={{-277,-30},{-284,-30},{-284,-0.2},{-292.2,-0.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lambda1.y, switch_OnOff.u3) annotation (Line(
      points={{-275,40},{-286,40},{-286,14.2},{-292.2,14.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eco_inlet.steam_a, eco.inlet) annotation (Line(
      points={{288,-104},{266,-104},{266,-30}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(evap.inlet, eco.outlet) annotation (Line(
      points={{266,44},{266,-10}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(eco_T.port, eco.outlet) annotation (Line(
      points={{296,-10},{266,-10}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(evap_T.port, evap.outlet) annotation (Line(
      points={{296,64},{266,64}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(oh_1.inlet, ct.outlet) annotation (Line(
      points={{330,122},{330,122},{330,184}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(oh_2.inlet, oh_1.outlet) annotation (Line(
      points={{402,148},{402,80},{330,80},{330,102}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_ph2.steam_a, oh_2.outlet) annotation (Line(
      points={{412,257},{408,257},{408,256},{402,256},{402,168}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(oh_T.port, oh_2.outlet) annotation (Line(
      points={{428,168},{402,168}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_split_top.coalSlagFlueGas_outlet, flameRoom_eco.outlet)
    annotation (Line(
      points={{42,260},{42,224}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_eco.inlet, flameRoom_oh_2.outlet) annotation (Line(
      points={{42,204},{42,178}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_2.inlet, flameRoom_oh_1.outlet) annotation (Line(
      points={{42,158},{42,132}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_oh_1.inlet, flameRoom_2.outlet) annotation (Line(
      points={{42,112},{42,102}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_2.inlet, flameRoom_1.outlet) annotation (Line(
      points={{42,82},{42,72}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_1.inlet, burner2.outlet) annotation (Line(
      points={{42,52},{42,44}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hopper.inlet, coalSlagFlueGas_join.coalSlagFlueGas_outlet)
    annotation (Line(
      points={{42,-40},{42,-60}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hopper.outlet, burner1.inlet) annotation (Line(
      points={{42,-20},{42,-6}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner1.outlet, burner2.inlet) annotation (Line(
      points={{42,14},{42,24}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join_burner2.coalDust_outlet, flameRoom_1.coalDust_inlet)
    annotation (Line(
      points={{-46,62},{28,62}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mill1.outlet, burner2.coalDust_inlet) annotation (Line(
      points={{-2,34},{28,34}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mill.outlet, burner1.coalDust_inlet) annotation (Line(
      points={{0,4},{28,4}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join_burner1.coalDust_outlet, mill1.inlet) annotation (Line(
      points={{-46,34},{-22,34}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join_burner.coalDust_outlet, mill.inlet) annotation (Line(
      points={{-46,4},{-20,4}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasValve_L1_1.outlet, coalGas_join_burner1.flueGas_inlet)
    annotation (Line(
      points={{-140,129.833},{-80,129.833},{-80,28},{-66,28}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasValve_L1_2.outlet, coalGas_join_burner.flueGas_inlet)
    annotation (Line(
      points={{-140,99.8333},{-84,99.8333},{-84,-2},{-66,-2}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalFlowSource.coal_a, coalGas_join_burner.coal_inlet) annotation (
      Line(
      points={{-120,10},{-66,10}},
      color={27,36,42},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalFlowSource1.coal_a, coalGas_join_burner1.coal_inlet) annotation (
      Line(
      points={{-120,40},{-66,40}},
      color={27,36,42},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalFlowSource2.coal_a, coalGas_join_burner2.coal_inlet) annotation (
      Line(
      points={{-120,68},{-66,68}},
      color={27,36,42},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasJunction1.portB, flueGasValve_L1_1.inlet) annotation (Line(
      points={{-206,130},{-174,130},{-174,129.833},{-160,129.833}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));

  connect(flueGasJunction1.portC, flueGasValve_L1_2.inlet) annotation (Line(
      points={{-216,120},{-216,100},{-160,100},{-160,99.8333}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fluelGasFlowSource4.gas_a, regenerativeAirPreheater.freshAirInlet)
    annotation (Line(
      points={{-276,200},{-266,200},{-266,170},{-258,170}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasPressureSink2.gas_a, regenerativeAirPreheater.flueGasOutlet)
    annotation (Line(
      points={{-220,200},{-230,200},{-230,170},{-238,170},{-238,170}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(slagFlowSource_top.slag_outlet, coalSlagFlueGas_split_top.slag_outlet)
    annotation (Line(
      points={{42,304},{42,280}},
      color={234,171,0},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSink_top.coal_a, coalSlagFlueGas_split_top.coal_inlet)
    annotation (Line(
      points={{18,292},{18,286},{36,286},{36,280}},
      color={27,36,42},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_join.coal_inlet, coalFlowSource_bottom.coal_a)
    annotation (Line(
      points={{36,-80},{36,-90},{22,-90},{22,-100}},
      color={27,36,42},
      thickness=0.5,
      smooth=Smooth.None));
  connect(slaglSink_bottom.slag_inlet, coalSlagFlueGas_join.slag_outlet)
    annotation (Line(
      points={{42.2,-100},{42.2,-90},{42,-90},{42,-80}},
      color={234,171,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_join.flueGas_inlet, fluelGasFlowSource_bottom.gas_a)
    annotation (Line(
      points={{48,-80},{48,-90},{62,-90},{62,-98}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fluelGasFlowSource2.gas_a, coalGas_join_burner2.flueGas_inlet)
    annotation (Line(
      points={{-88,56},{-66,56}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(regenerativeAirPreheater.flueGasInlet, coalSlagFlueGas_split_top.flueGas_inlet)
    annotation (Line(
      points={{-238,158},{-44,158},{-44,344},{64,344},{64,292},{48,292},{48,280}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(regenerativeAirPreheater.freshAirOutlet, flueGasJunction1.portA)
    annotation (Line(
      points={{-258,158},{-266,158},{-266,130},{-226,130}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PID_lambda.y, fluelGasFlowSource4.m_flow) annotation (Line(
      points={{-346.9,58},{-360,58},{-360,206},{-296,206}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ecoOut_p.port, evap.inlet) annotation (Line(
      points={{296,36},{266,36},{266,44}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(vleMassflowSensor.outlet, ct.inlet) annotation (Line(
      points={{302,212},{330,212},{330,204}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(evap.outlet, vleMassflowSensor.inlet) annotation (Line(
      points={{266,64},{266,212},{282,212}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-400,-160},{500,400}},
          preserveAspectRatio=false),graphics={
                                Text(
          extent={{-396,360},{-70,230}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=11,
          textString="________________________________________________________________
PURPOSE:
>> Basic model of a coal fired boiler with load change
________________________________________________________________
LOOK AT the following time plots:
>> Live steam temperature
>> Flue gas temperature downwards the economiser
>> Coal mass flow into the boiler
>> Air and flue gas temperatures at in and outlets of the air preheater
 ________________________________________________________________
NOTES
>> Excess air control for the burner stages
>> Boiler is designed exemplary
"),                             Text(
          extent={{-400,398},{-40,378}},
          lineColor={0,128,0},
          fontSize=34,
          textString="TESTED -- 2014-10-08 //LN")}),                     Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true)),
    experiment(StopTime=10000, NumberOfIntervals=1001),
    __Dymola_experimentSetupOutput);
end BoilerExample;
