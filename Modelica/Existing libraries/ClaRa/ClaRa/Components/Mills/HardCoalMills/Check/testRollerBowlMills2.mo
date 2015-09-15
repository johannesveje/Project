within ClaRa.Components.Mills.HardCoalMills.Check;
model testRollerBowlMills2
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
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3    Mill2(millKoeff=
        ClaRa.Components.Mills.HardCoalMills.Fundamentals.ASV1(),
                                     initChoice=ClaRa.Basics.Choices.Init.steadyState)
    annotation (Placement(transformation(extent={{32,-32},{52,-12}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=10,
    offset=10,
    startTime=100,
    height=2)
    annotation (Placement(transformation(extent={{-90,44},{-70,64}})));
  Modelica.Blocks.Sources.Ramp ramp(
    offset=1.50,
    startTime=1000,
    height=0.1,
    duration=10)
    annotation (Placement(transformation(extent={{-28,42},{-8,62}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=10,
    startTime=100,
    height=0.05,
    offset=0.05)
    annotation (Placement(transformation(extent={{-88,-88},{-68,-68}})));
  Visualisation.Scope scope(
    Unit="Pressure Difference over Mill in Pa",
    t_simulation=3000,
    color={255,255,0},
    y_min=400,
    y_max=600) annotation (Placement(transformation(extent={{6,16},{56,62}})));
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3    Mill1(
    millKoeff=ClaRa.Components.Mills.HardCoalMills.Fundamentals.ASV1(),
    N_mills=2,
    initChoice=ClaRa.Basics.Choices.Init.steadyState)
    annotation (Placement(transformation(extent={{26,-90},{46,-70}})));
  BoundaryConditions.BoundaryCoal_Txim_flow coalFlowSource_XRG(m_flow_const=10, variable_m_flow=true) annotation (Placement(transformation(extent={{-50,-18},{-30,2}})));
  ClaRa.Components.Adapters.CoalGas_join coalGas_join_burner3
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-8,-22})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource_burner3(m_flow_const=11,
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.8,0.1985,0,0.001,0})                                                                         annotation (Placement(transformation(extent={{-50,-38},{-30,-18}})));
  BoundaryConditions.BoundaryCoal_Txim_flow coalFlowSource_XRG1(m_flow_const=10, variable_m_flow=true) annotation (Placement(transformation(extent={{-48,-78},{-28,-58}})));
  ClaRa.Components.Adapters.CoalGas_join coalGas_join_burner1
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-6,-80})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource_burner1(m_flow_const=11,
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.8,0.1985,0,0.001,0})                                                                         annotation (Placement(transformation(extent={{-48,-98},{-28,-78}})));
  BoundaryConditions.BoundaryCoal_pTxi coaSink_XRG2(xi_const={0.8,0.05,0.05,0.05,0.025,0.025}) annotation (Placement(transformation(extent={{100,-100},{78,-80}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi idealGasPressureSink_XRG2(p_const=100000) annotation (Placement(transformation(extent={{100,-76},{78,-56}})));
  ClaRa.Components.Adapters.CoalGas_join coalGas_join_burner4
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={66,-80})));
  BoundaryConditions.BoundaryCoal_pTxi coaSink_XRG1(xi_const={0.8,0.05,0.05,0.05,0.025,0.025}) annotation (Placement(transformation(extent={{100,-42},{78,-22}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi idealGasPressureSink_XRG1(p_const=100000) annotation (Placement(transformation(extent={{100,-18},{78,2}})));
  ClaRa.Components.Adapters.CoalGas_join coalGas_join_burner2
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={66,-22})));
equation
  connect(ramp.y, Mill2.classifierSpeed) annotation (Line(
      points={{-7,52},{42,52},{42,-11.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(scope.u, Mill2.Delta_p_mill) annotation (Line(
      points={{3.85714,49.2615},{3.85714,15.2},{54,15.2},{54,-15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y,Mill1. classifierSpeed) annotation (Line(
      points={{-7,52},{36,52},{36,-69.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalFlowSource_XRG.coal_a,coalGas_join_burner3. coal_inlet)
    annotation (Line(
      points={{-30,-8},{-24,-8},{-24,-16},{-18,-16}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(fluelGasFlowSource_burner3.gas_a,coalGas_join_burner3. flueGas_inlet)
    annotation (Line(
      points={{-30,-28},{-18,-28}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coalGas_join_burner3.coalDust_outlet, Mill2.inlet) annotation (Line(
      points={{2,-22},{32,-22}},
      color={175,175,175},
      smooth=Smooth.None));
  connect(ramp1.y, coalFlowSource_XRG.m_flow) annotation (Line(
      points={{-69,54},{-68,54},{-68,-2},{-50,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalFlowSource_XRG1.coal_a, coalGas_join_burner1.coal_inlet)
    annotation (Line(
      points={{-28,-68},{-22,-68},{-22,-74},{-16,-74}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(fluelGasFlowSource_burner1.gas_a,coalGas_join_burner1. flueGas_inlet)
    annotation (Line(
      points={{-28,-88},{-22,-88},{-22,-86},{-16,-86}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coalGas_join_burner1.coalDust_outlet, Mill1.inlet) annotation (Line(
      points={{4,-80},{26,-80}},
      color={175,175,175},
      smooth=Smooth.None));
  connect(idealGasPressureSink_XRG2.gas_a,coalGas_join_burner4. flueGas_inlet)
    annotation (Line(
      points={{78,-66},{76,-66},{76,-74}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coaSink_XRG2.coal_a,coalGas_join_burner4. coal_inlet) annotation (
      Line(
      points={{78,-90},{78,-86},{76,-86}},
      color={127,127,0},
      smooth=Smooth.None));
  connect(coalGas_join_burner4.coalDust_outlet, Mill1.outlet) annotation (Line(
      points={{56,-80},{46,-80}},
      color={175,175,175},
      smooth=Smooth.None));
  connect(idealGasPressureSink_XRG1.gas_a,coalGas_join_burner2. flueGas_inlet)
    annotation (Line(
      points={{78,-8},{76,-8},{76,-16}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coaSink_XRG1.coal_a,coalGas_join_burner2. coal_inlet) annotation (
      Line(
      points={{78,-32},{78,-28},{76,-28}},
      color={127,127,0},
      smooth=Smooth.None));
  connect(Mill2.outlet, coalGas_join_burner2.coalDust_outlet) annotation (Line(
      points={{52,-22},{56,-22}},
      color={175,175,175},
      smooth=Smooth.None));
  connect(coalFlowSource_XRG1.m_flow, ramp1.y) annotation (Line(
      points={{-48,-62},{-56,-62},{-56,-60},{-64,-60},{-64,54},{-69,54}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics={Text(
          extent={{-100,90},{100,80}},
          lineColor={0,128,0},
          lineThickness=0.5,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="IDEA:
compares two parallel mills with one mill
NOTE:
the number of parallel mills N_mills differs in both mills - check parameters!")}), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Rectangle(
          extent={{-100,100},{0,0}},
          lineColor={0,0,255},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}));
end testRollerBowlMills2;
