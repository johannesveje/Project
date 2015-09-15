within ClaRa.Components.Furnace.Check;
model Test_burner_adiabatic
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
  Adapters.CoalSlagFlueGas_split                                 coalSlagFlueGas_split_top
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-4,30})));
  BoundaryConditions.BoundarySlag_Tm_flow slagFlowSource_top(m_flow_const=0.0, T_const=658.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-4,74})));
  BoundaryConditions.BoundaryCoal_pTxi coalSink_top(T_const=658.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,62})));
  BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink_top(p_const=100000, T_const=658.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={22,62})));
  inner SimCenter simCenter(
    redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1,
    redeclare ClaRa.Basics.Media.Fuel.Coal_Reference fuelModel1,
    redeclare ClaRa.Basics.Media.Fuel.Slag_v2 slagModel,
    redeclare TILMedia.GasTypes.FlueGasTILMedia flueGasModel) annotation (Placement(transformation(extent={{98,62},{118,82}})));
  BoundaryConditions.BoundaryCoal_Txim_flow coalFlowSource(
    xi_const={0.661,0.0383,0.066,0.016,0.0057,0.135},
    m_flow_const=15,
    T_const=293.15) annotation (Placement(transformation(extent={{-138,-30},{-118,-10}})));
  BoundaryConditions.BoundaryGas_Txim_flow flueGasFlowSource(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=15*10.396,
    T_const=573.15,
    xi_const={0,0,0.0005,0,0.7681,0.2314,0,0,0})
                    annotation (Placement(transformation(extent={{-106,-42},{-86,-22}})));
  Adapters.CoalGas_join coalGas_join_burner
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-54,-26})));
  Adapters.CoalSlagFlueGas_join
    coalSlagFlueGas_join
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-4,-54})));
  BoundaryConditions.BoundaryGas_Txim_flow flueGasFlowSourcee_bottom(m_flow_const=0, T_const=283.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={16,-94})));
  BoundaryConditions.BoundaryCoal_Txim_flow coalFlowSource_bottom(
    xi_const={0.86,0.035,0.025,0.014,0.007,0.0505},
    m_flow_const=0,
    T_const=293.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-24,-94})));
  BoundaryConditions.BoundarySlag_pT slagSink_bottom(T_const=373.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-4,-94})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedTemperatureBottom(Q_flow=0)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={66,-50})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedTemperatureWall(Q_flow=0)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={66,-26})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureTop(T=658.15)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={56,8})));
  Burner.Burner_L2_Static burner(
    T_slag=873,
    LHV_calculationType="fixed",
    redeclare model HeatTransfer_Top =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model Burning_time =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model ParticleMigration =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        z_in={0},
        z_out={5},
        height=10,
        width=10,
        length=burner.geo.z_out[1] - burner.geo.z_in[1]),
    LHV_fixed=25.1e6,
    redeclare model ReactionZone =
        ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone (                           xi_NOx =     0, xi_CO =     0)) annotation (Placement(transformation(extent={{-18,-36},{42,-16}})));

equation
  connect(coalFlowSource.coal_a, coalGas_join_burner.coal_inlet) annotation (
      Line(
      points={{-118,-20},{-64,-20}},
      color={27,36,42},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasFlowSource.gas_a, coalGas_join_burner.flueGas_inlet)
    annotation (Line(
      points={{-86,-32},{-64,-32}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join_burner.coalDust_outlet, burner.coalDust_inlet)
    annotation (Line(
      points={{-44,-26},{-18,-26}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_split_top.coalSlagFlueGas_outlet, burner.outlet)
    annotation (Line(
      points={{-4,20},{-4,-16}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_join.coalSlagFlueGas_outlet, burner.inlet)
    annotation (Line(
      points={{-4,-44},{-4,-36}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_join.flueGas_inlet, flueGasFlowSourcee_bottom.gas_a)
    annotation (Line(
      points={{2,-64},{2,-74},{16,-74},{16,-84}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(slagSink_bottom.slag_inlet, coalSlagFlueGas_join.slag_outlet)
    annotation (Line(
      points={{-3.8,-84},{-3.8,-74},{-4,-74},{-4,-64}},
      color={234,171,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_join.coal_inlet, coalFlowSource_bottom.coal_a)
    annotation (Line(
      points={{-10,-64},{-10,-74},{-24,-74},{-24,-84}},
      color={27,36,42},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner.heat_bottom, fixedTemperatureBottom.port) annotation (Line(
      points={{14,-36},{14,-50},{56,-50}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner.heat_wall, fixedTemperatureWall.port) annotation (Line(
      points={{42,-26},{56,-26}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner.heat_top, fixedTemperatureTop.port) annotation (Line(
      points={{14,-16},{14,8},{46,8}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSink_top.coal_a, coalSlagFlueGas_split_top.coal_inlet)
    annotation (Line(
      points={{-30,52},{-30,48},{-10,48},{-10,40}},
      color={27,36,42},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasPressureSink_top.gas_a, coalSlagFlueGas_split_top.flueGas_inlet)
    annotation (Line(
      points={{22,52},{22,48},{2,48},{2,40}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_split_top.slag_outlet, slagFlowSource_top.slag_outlet)
    annotation (Line(
      points={{-4,40},{-4,64}},
      color={234,171,0},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-140,-120},{120,100}},
          preserveAspectRatio=false), graphics={
                                Text(
          extent={{-138,86},{-64,76}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="________________________________________________________________
PURPOSE:
>>Tester for calculation of the adiabatic outlet temperature of a burner level

"),                             Text(
          extent={{-142,100},{4,90}},
          lineColor={0,128,0},
          fontSize=34,
          textString="TESTED -- 2014-10-08 //LN")}),                     Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            false)));
end Test_burner_adiabatic;
