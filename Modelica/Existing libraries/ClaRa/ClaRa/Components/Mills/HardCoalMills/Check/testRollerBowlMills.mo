within ClaRa.Components.Mills.HardCoalMills.Check;
model testRollerBowlMills
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
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3    Mill(
      applyGrindingDelay=true, Tau_grind=0)
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=10,
    offset=1.50,
    startTime=900,
    height=-0.1)
    annotation (Placement(transformation(extent={{-36,62},{-16,82}})));
  ClaRa.Components.Mills.HardCoalMills.RollerBowlMill_L1 rollerBowlMill_01_XRG(Tau_m=100) annotation (Placement(transformation(extent={{30,80},{50,100}})));
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3    Mill1(millKoeff=
        ClaRa.Components.Mills.HardCoalMills.Fundamentals.STV4())
    annotation (Placement(transformation(extent={{30,-38},{50,-18}})));
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3    Mill2(millKoeff=
        ClaRa.Components.Mills.HardCoalMills.Fundamentals.ASV1())
    annotation (Placement(transformation(extent={{30,-86},{50,-66}})));
  BoundaryConditions.BoundaryCoal_Txim_flow coalFlowSource_XRG(m_flow_const=10, variable_m_flow=true) annotation (Placement(transformation(extent={{-44,30},{-24,50}})));
  BoundaryConditions.BoundaryCoal_Txim_flow coalFlowSource_XRG2(m_flow_const=10, variable_m_flow=true) annotation (Placement(transformation(extent={{-44,-32},{-24,-12}})));
  BoundaryConditions.BoundaryCoal_Txim_flow coalFlowSource_XRG3(m_flow_const=10, variable_m_flow=true) annotation (Placement(transformation(extent={{-48,-80},{-28,-60}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=10,
    offset=10,
    startTime=100,
    height=10)
    annotation (Placement(transformation(extent={{-88,62},{-68,82}})));
  BoundaryConditions.BoundaryCoal_pTxi coaSink_XRG2(xi_const={0.8,0.05,0.05,0.05,0.025,0.025}) annotation (Placement(transformation(extent={{100,-96},{78,-76}})));
  ClaRa.Components.Adapters.CoalGas_join coalGas_join_burner3
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-2,26})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource_burner3(                  m_flow_const=11,
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.8,0.1985,0,0.001,0})                                                                         annotation (Placement(transformation(extent={{-44,10},{-24,30}})));
  ClaRa.Components.Adapters.CoalGas_join coalGas_join_burner1
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={8,-36})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource_burner1(                  m_flow_const=11,
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.8,0.1985,0,0.001,0})                                                                         annotation (Placement(transformation(extent={{-44,-52},{-24,-32}})));
  ClaRa.Components.Adapters.CoalGas_join coalGas_join_burner2
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={4,-84})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource_burner2(                  m_flow_const=11,
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.8,0.1985,0,0.001,0})                                                                         annotation (Placement(transformation(extent={{-48,-100},{-28,-80}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi idealGasPressureSink_XRG2(p_const=100000) annotation (Placement(transformation(extent={{100,-72},{78,-52}})));
  ClaRa.Components.Adapters.CoalGas_join coalGas_join_burner4
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={66,-76})));
  BoundaryConditions.BoundaryCoal_pTxi coaSink_XRG1(xi_const={0.8,0.05,0.05,0.05,0.025,0.025}) annotation (Placement(transformation(extent={{100,-48},{78,-28}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi idealGasPressureSink_XRG1(p_const=100000) annotation (Placement(transformation(extent={{100,-24},{78,-4}})));
  ClaRa.Components.Adapters.CoalGas_join coalGas_join_burner5
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={66,-28})));
  BoundaryConditions.BoundaryCoal_pTxi coaSink_XRG3(xi_const={0.8,0.05,0.05,0.05,0.025,0.025}) annotation (Placement(transformation(extent={{100,0},{78,20}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi idealGasPressureSink_XRG3(p_const=100000) annotation (Placement(transformation(extent={{100,24},{78,44}})));
  ClaRa.Components.Adapters.CoalGas_join coalGas_join_burner6
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={66,20})));
equation
  connect(ramp.y, Mill.classifierSpeed) annotation (Line(
      points={{-15,72},{40,72},{40,30.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, Mill1.classifierSpeed) annotation (Line(
      points={{-15,72},{40,72},{40,-17.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, Mill2.classifierSpeed) annotation (Line(
      points={{-15,72},{40,72},{40,-65.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, rollerBowlMill_01_XRG.rawCoal) annotation (Line(
      points={{-67,72},{-44,72},{-44,91},{29.2,91}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(ramp1.y, coalFlowSource_XRG.m_flow) annotation (Line(
      points={{-67,72},{-60,72},{-60,46},{-44,46}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(ramp1.y, coalFlowSource_XRG2.m_flow) annotation (Line(
      points={{-67,72},{-60,72},{-60,-16},{-44,-16}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(ramp1.y, coalFlowSource_XRG3.m_flow) annotation (Line(
      points={{-67,72},{-60,72},{-60,-64},{-48,-64}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(coalFlowSource_XRG.coal_a, coalGas_join_burner3.coal_inlet)
    annotation (Line(
      points={{-24,40},{-18,40},{-18,32},{-12,32}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(coalGas_join_burner3.coalDust_outlet, Mill.inlet) annotation (Line(
      points={{8,26},{20,26},{20,20},{30,20}},
      color={175,175,175},
      smooth=Smooth.None));
  connect(fluelGasFlowSource_burner3.gas_a, coalGas_join_burner3.flueGas_inlet)
    annotation (Line(
      points={{-24,20},{-12,20}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(fluelGasFlowSource_burner1.gas_a, coalGas_join_burner1.flueGas_inlet)
    annotation (Line(
      points={{-24,-42},{-2,-42}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coalGas_join_burner1.coalDust_outlet, Mill1.inlet) annotation (Line(
      points={{18,-36},{26,-36},{26,-28},{30,-28}},
      color={175,175,175},
      smooth=Smooth.None));
  connect(coalFlowSource_XRG2.coal_a, coalGas_join_burner1.coal_inlet)
    annotation (Line(
      points={{-24,-22},{-8,-22},{-8,-30},{-2,-30}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(fluelGasFlowSource_burner2.gas_a, coalGas_join_burner2.flueGas_inlet)
    annotation (Line(
      points={{-28,-90},{-6,-90}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coalGas_join_burner2.coal_inlet, coalFlowSource_XRG3.coal_a)
    annotation (Line(
      points={{-6,-78},{-18,-78},{-18,-70},{-28,-70}},
      color={127,127,0},
      smooth=Smooth.None));
  connect(coalGas_join_burner2.coalDust_outlet, Mill2.inlet) annotation (Line(
      points={{14,-84},{24,-84},{24,-76},{30,-76}},
      color={175,175,175},
      smooth=Smooth.None));
  connect(Mill2.outlet, coalGas_join_burner4.coalDust_outlet) annotation (Line(
      points={{50,-76},{56,-76}},
      color={175,175,175},
      smooth=Smooth.None));
  connect(idealGasPressureSink_XRG2.gas_a, coalGas_join_burner4.flueGas_inlet)
    annotation (Line(
      points={{78,-62},{76,-62},{76,-70}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coaSink_XRG2.coal_a, coalGas_join_burner4.coal_inlet) annotation (
      Line(
      points={{78,-86},{78,-82},{76,-82}},
      color={127,127,0},
      smooth=Smooth.None));
  connect(idealGasPressureSink_XRG1.gas_a, coalGas_join_burner5.flueGas_inlet)
    annotation (Line(
      points={{78,-14},{76,-14},{76,-22}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coaSink_XRG1.coal_a, coalGas_join_burner5.coal_inlet) annotation (
      Line(
      points={{78,-38},{78,-34},{76,-34}},
      color={127,127,0},
      smooth=Smooth.None));
  connect(idealGasPressureSink_XRG3.gas_a, coalGas_join_burner6.flueGas_inlet)
    annotation (Line(
      points={{78,34},{78,30},{76,30},{76,26}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coaSink_XRG3.coal_a, coalGas_join_burner6.coal_inlet) annotation (
      Line(
      points={{78,10},{76,10},{76,14}},
      color={127,127,0},
      smooth=Smooth.None));
  connect(coalGas_join_burner6.coalDust_outlet, Mill.outlet) annotation (Line(
      points={{56,20},{50,20}},
      color={175,175,175},
      smooth=Smooth.None));
  connect(coalGas_join_burner5.coalDust_outlet, Mill1.outlet) annotation (Line(
      points={{56,-28},{50,-28}},
      color={175,175,175},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,140}},
          preserveAspectRatio=false),
                      graphics={Text(
          extent={{-102,140},{100,112}},
          lineColor={0,128,0},
          lineThickness=0.5,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid,
          textString="IDEA:
1. compares different sets of mill parameter sets
2.  compares RowlerBowlMill_3 with the simple mill model of type RollerBowlMill_1",
          horizontalAlignment=TextAlignment.Left)}), Icon(coordinateSystem(
          extent={{-100,-100},{100,100}}, preserveAspectRatio=false)),
    experiment(StopTime=2000),
    __Dymola_experimentSetupOutput);
end testRollerBowlMills;
