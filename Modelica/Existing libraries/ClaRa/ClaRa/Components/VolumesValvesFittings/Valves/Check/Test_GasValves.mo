within ClaRa.Components.VolumesValvesFittings.Valves.Check;
model Test_GasValves
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
  ValveGas_L1     valve1(
    openingInputIsActive=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         Delta_p_nom=2e5, m_flow_nom=10))
    annotation (Placement(transformation(extent={{-30,42},{-10,54}})));

  inner SimCenter simCenter(redeclare TILMedia.GasTypes.FlueGasTILMedia flueGasModel) annotation (Placement(transformation(extent={{162,232},{182,252}})));

  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0}) annotation (Placement(transformation(extent={{-60,38},{-40,58}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT(p_const=800000) annotation (Placement(transformation(extent={{132,38},{112,58}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=8,
    offset=1,
    startTime=1,
    height=-0.9)
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  ValveGas_L1     valve2(
    openingInputIsActive=true,
    useHomotopy=false,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticKV)
    annotation (Placement(transformation(extent={{-10,14},{10,26}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T1(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0}) annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT1(p_const=800000) annotation (Placement(transformation(extent={{132,10},{112,30}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T2(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0}) annotation (Placement(transformation(extent={{-60,-18},{-40,2}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT2(p_const=800000) annotation (Placement(transformation(extent={{132,-18},{112,2}})));
  BoundaryConditions.BoundaryCoal_Txim_flow coalFlowSource(m_flow_const=5, T_const=293.15) annotation (Placement(transformation(extent={{-92,-244},{-72,-224}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T3(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0}) annotation (Placement(transformation(extent={{-92,-266},{-72,-246}})));
  Adapters.CoalGas_join coalGas_join
    annotation (Placement(transformation(extent={{-60,-256},{-40,-236}})));
  Adapters.CoalGas_split coalGas_split
    annotation (Placement(transformation(extent={{116,-256},{136,-236}})));
  BoundaryConditions.BoundaryCoal_pTxi coalSink(p_const=800000) annotation (Placement(transformation(extent={{170,-244},{150,-224}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT3(p_const=800000) annotation (Placement(transformation(extent={{170,-268},{150,-248}})));
  BoundaryConditions.BoundaryCoal_Txim_flow coalFlowSource1(m_flow_const=5, T_const=293.15) annotation (Placement(transformation(extent={{-92,-192},{-72,-172}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T4(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0}) annotation (Placement(transformation(extent={{-92,-214},{-72,-194}})));
  Adapters.CoalGas_join coalGas_join1
    annotation (Placement(transformation(extent={{-60,-204},{-40,-184}})));
  Adapters.CoalGas_split coalGas_split1
    annotation (Placement(transformation(extent={{116,-204},{136,-184}})));
  BoundaryConditions.BoundaryCoal_pTxi coalSink1(p_const=800000) annotation (Placement(transformation(extent={{172,-192},{152,-172}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT4(p_const=800000) annotation (Placement(transformation(extent={{172,-216},{152,-196}})));
  ValveCoalDust_L1 coalDustValve2(openingInputIsActive=true, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticKV)
    annotation (Placement(transformation(extent={{-10,-200},{10,-188}})));
  BoundaryConditions.BoundaryCoal_Txim_flow coalFlowSource2(m_flow_const=5, T_const=293.15) annotation (Placement(transformation(extent={{-92,-144},{-72,-124}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T5(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0}) annotation (Placement(transformation(extent={{-92,-166},{-72,-146}})));
  Adapters.CoalGas_join coalGas_join2
    annotation (Placement(transformation(extent={{-60,-156},{-40,-136}})));
  Adapters.CoalGas_split coalGas_split2
    annotation (Placement(transformation(extent={{118,-156},{138,-136}})));
  BoundaryConditions.BoundaryCoal_pTxi coalSink2(p_const=800000) annotation (Placement(transformation(extent={{172,-144},{152,-124}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT5(p_const=800000) annotation (Placement(transformation(extent={{172,-168},{152,-148}})));
  ValveCoalDust_L1 coalDustValve1(
    openingInputIsActive=true, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         m_flow_nom=10, Delta_p_nom=2e5))
    annotation (Placement(transformation(extent={{-30,-152},{-10,-140}})));

  ValveGas_L1     valve3(
    openingInputIsActive=true,
    useHomotopy=false,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticNominalPoint (
        Delta_p_nom=2e5,
        rho_in_nom=1,
        m_flow_nom=10))
    annotation (Placement(transformation(extent={{10,-14},{30,-2}})));
  ValveGas_L1     valve4(
    openingInputIsActive=true,
    useHomotopy=false,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticZeta (
         A_cross=
           0.2, zeta=0.5))
    annotation (Placement(transformation(extent={{30,-42},{50,-30}})));
  ValveGas_L1     valve5(
    openingInputIsActive=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534,
    useHomotopy=true)
    annotation (Placement(transformation(extent={{50,-70},{70,-58}})));

  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T6(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0}) annotation (Placement(transformation(extent={{-60,-46},{-40,-26}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT6(p_const=800000) annotation (Placement(transformation(extent={{132,-46},{112,-26}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T7(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0}) annotation (Placement(transformation(extent={{-60,-74},{-40,-54}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT7(p_const=800000) annotation (Placement(transformation(extent={{132,-74},{112,-54}})));
  ValveGas_L1     valve6(
    openingInputIsActive=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_FlowFunction,
    useHomotopy=true)
    annotation (Placement(transformation(extent={{70,-98},{90,-86}})));

  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T8(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0}) annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT8(p_const=800000) annotation (Placement(transformation(extent={{132,-102},{112,-82}})));
  ValveCoalDust_L1 coalDustValve3(
                               redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticNominalPoint (
        Delta_p_nom=2e5,
        rho_in_nom=1,
        m_flow_nom=10),
    openingInputIsActive=false,
    checkValve=true)
    annotation (Placement(transformation(extent={{10,-252},{30,-240}})));
  BoundaryConditions.BoundaryCoal_Txim_flow coalFlowSource3(m_flow_const=5, T_const=293.15) annotation (Placement(transformation(extent={{-92,-348},{-72,-328}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T9(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0}) annotation (Placement(transformation(extent={{-92,-370},{-72,-350}})));
  Adapters.CoalGas_join coalGas_join3
    annotation (Placement(transformation(extent={{-60,-360},{-40,-340}})));
  Adapters.CoalGas_split coalGas_split3
    annotation (Placement(transformation(extent={{114,-360},{134,-340}})));
  BoundaryConditions.BoundaryCoal_pTxi coalSink3(p_const=800000) annotation (Placement(transformation(extent={{168,-348},{148,-328}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT9(p_const=800000) annotation (Placement(transformation(extent={{168,-372},{148,-352}})));
  BoundaryConditions.BoundaryCoal_Txim_flow coalFlowSource4(m_flow_const=5, T_const=293.15) annotation (Placement(transformation(extent={{-92,-296},{-72,-276}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T10(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0}) annotation (Placement(transformation(extent={{-92,-318},{-72,-298}})));
  Adapters.CoalGas_join coalGas_join4
    annotation (Placement(transformation(extent={{-60,-308},{-40,-288}})));
  Adapters.CoalGas_split coalGas_split4
    annotation (Placement(transformation(extent={{114,-308},{134,-288}})));
  BoundaryConditions.BoundaryCoal_pTxi coalSink4(p_const=800000) annotation (Placement(transformation(extent={{170,-296},{150,-276}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT10(p_const=800000) annotation (Placement(transformation(extent={{170,-320},{150,-300}})));
  ValveCoalDust_L1 coalDustValve4(
    openingInputIsActive=true, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticZeta (
         zeta=0.5, A_cross=
                     0.2))
    annotation (Placement(transformation(extent={{30,-304},{50,-292}})));
  ValveCoalDust_L1 coalDustValve5(
    openingInputIsActive=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534,
    useHomotopy=true)
    annotation (Placement(transformation(extent={{50,-356},{70,-344}})));

  BoundaryConditions.BoundaryCoal_Txim_flow coalFlowSource5(m_flow_const=5, T_const=293.15) annotation (Placement(transformation(extent={{-92,-398},{-72,-378}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T11(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0}) annotation (Placement(transformation(extent={{-92,-420},{-72,-400}})));
  Adapters.CoalGas_join coalGas_join5
    annotation (Placement(transformation(extent={{-60,-410},{-40,-390}})));
  Adapters.CoalGas_split coalGas_split5
    annotation (Placement(transformation(extent={{114,-410},{134,-390}})));
  BoundaryConditions.BoundaryCoal_pTxi coalSink5(p_const=800000) annotation (Placement(transformation(extent={{168,-398},{148,-378}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT11(p_const=800000) annotation (Placement(transformation(extent={{168,-422},{148,-402}})));
  ValveCoalDust_L1 coalDustValve6(
    openingInputIsActive=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_FlowFunction,
    useHomotopy=true)
    annotation (Placement(transformation(extent={{70,-406},{90,-394}})));

equation
  connect(ramp.y, valve1.opening_in) annotation (Line(
      points={{-39,80},{-20,80},{-20,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, valve2.opening_in) annotation (Line(
      points={{-39,80},{0,80},{0,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalFlowSource.coal_a, coalGas_join.coal_inlet) annotation (Line(
      points={{-72,-234},{-66,-234},{-66,-240},{-60,-240}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(gasFlowSource_T3.gas_a, coalGas_join.flueGas_inlet) annotation (Line(
      points={{-72,-256},{-66,-256},{-66,-252},{-60,-252}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coalGas_split.coal_inlet, coalSink.coal_a) annotation (Line(
      points={{136,-240},{142,-240},{142,-234},{150,-234}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(coalGas_split.flueGas_inlet, gasSink_pT3.gas_a) annotation (Line(
      points={{136,-252},{142,-252},{142,-258},{150,-258}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coalFlowSource1.coal_a, coalGas_join1.coal_inlet) annotation (Line(
      points={{-72,-182},{-66,-182},{-66,-188},{-60,-188}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(gasFlowSource_T4.gas_a, coalGas_join1.flueGas_inlet) annotation (Line(
      points={{-72,-204},{-66,-204},{-66,-200},{-60,-200}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coalGas_split1.coal_inlet, coalSink1.coal_a) annotation (Line(
      points={{136,-188},{144,-188},{144,-182},{152,-182}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(coalGas_split1.flueGas_inlet, gasSink_pT4.gas_a) annotation (Line(
      points={{136,-200},{144,-200},{144,-206},{152,-206}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(ramp.y, coalDustValve2.opening_in)
                                            annotation (Line(
      points={{-39,80},{0,80},{0,-186}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalFlowSource2.coal_a, coalGas_join2.coal_inlet) annotation (Line(
      points={{-72,-134},{-66,-134},{-66,-140},{-60,-140}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(gasFlowSource_T5.gas_a, coalGas_join2.flueGas_inlet) annotation (Line(
      points={{-72,-156},{-66,-156},{-66,-152},{-60,-152}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coalGas_split2.coal_inlet, coalSink2.coal_a) annotation (Line(
      points={{138,-140},{144,-140},{144,-134},{152,-134}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(coalGas_split2.flueGas_inlet, gasSink_pT5.gas_a) annotation (Line(
      points={{138,-152},{144,-152},{144,-158},{152,-158}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(ramp.y, coalDustValve1.opening_in) annotation (Line(
      points={{-39,80},{-20,80},{-20,-138}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasFlowSource_T2.gas_a, valve3.inlet) annotation (Line(
      points={{-40,-8},{-16,-8},{-16,-9},{10,-9}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve3.outlet, gasSink_pT2.gas_a) annotation (Line(
      points={{30,-9},{72,-9},{72,-8},{112,-8}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gasFlowSource_T6.gas_a, valve4.inlet) annotation (Line(
      points={{-40,-36},{-6,-36},{-6,-37},{30,-37}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve4.outlet, gasSink_pT6.gas_a) annotation (Line(
      points={{50,-37},{82,-37},{82,-36},{112,-36}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gasFlowSource_T.gas_a, valve1.inlet) annotation (Line(
      points={{-40,48},{-36,48},{-36,47},{-30,47}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve1.outlet, gasSink_pT.gas_a) annotation (Line(
      points={{-10,47},{52,47},{52,48},{112,48}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gasSink_pT1.gas_a, valve2.outlet) annotation (Line(
      points={{112,20},{62,20},{62,19},{10,19}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve2.inlet, gasFlowSource_T1.gas_a) annotation (Line(
      points={{-10,19},{-26,19},{-26,20},{-40,20}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, valve3.opening_in) annotation (Line(
      points={{-39,80},{20,80},{20,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, valve4.opening_in) annotation (Line(
      points={{-39,80},{40,80},{40,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, valve5.opening_in) annotation (Line(
      points={{-39,80},{60,80},{60,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasFlowSource_T7.gas_a, valve5.inlet) annotation (Line(
      points={{-40,-64},{6,-64},{6,-65},{50,-65}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve5.outlet, gasSink_pT7.gas_a) annotation (Line(
      points={{70,-65},{92,-65},{92,-64},{112,-64}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gasFlowSource_T8.gas_a, valve6.inlet) annotation (Line(
      points={{-40,-92},{16,-92},{16,-93},{70,-93}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve6.outlet, gasSink_pT8.gas_a) annotation (Line(
      points={{90,-93},{102,-93},{102,-92},{112,-92}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, valve6.opening_in) annotation (Line(
      points={{-39,80},{80,80},{80,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalGas_join.coalDust_outlet,coalDustValve3.inlet)
    annotation (Line(
      points={{-40,-246},{-16,-246},{-16,-247},{10,-247}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalDustValve3.outlet,          coalGas_split.coalDust_inlet)
    annotation (Line(
      points={{30,-247},{74,-247},{74,-246},{116,-246}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join2.coalDust_outlet,coalDustValve1.inlet)
    annotation (Line(
      points={{-40,-146},{-36,-146},{-36,-147},{-30,-147}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalDustValve1.outlet,          coalGas_split2.coalDust_inlet)
    annotation (Line(
      points={{-10,-147},{54,-147},{54,-146},{118,-146}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_split1.coalDust_inlet,coalDustValve2.outlet)
    annotation (Line(
      points={{116,-194},{64,-194},{64,-195},{10,-195}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalDustValve2.inlet,          coalGas_join1.coalDust_outlet)
    annotation (Line(
      points={{-10,-195},{-26,-195},{-26,-194},{-40,-194}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, coalDustValve3.opening_in) annotation (Line(
      points={{-39,80},{20,80},{20,-238}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalFlowSource3.coal_a, coalGas_join3.coal_inlet)
                                                          annotation (Line(
      points={{-72,-338},{-66,-338},{-66,-344},{-60,-344}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(gasFlowSource_T9.gas_a, coalGas_join3.flueGas_inlet)
                                                              annotation (Line(
      points={{-72,-360},{-66,-360},{-66,-356},{-60,-356}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coalGas_split3.coal_inlet, coalSink3.coal_a)
                                                     annotation (Line(
      points={{134,-344},{140,-344},{140,-338},{148,-338}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(coalGas_split3.flueGas_inlet, gasSink_pT9.gas_a)
                                                          annotation (Line(
      points={{134,-356},{140,-356},{140,-362},{148,-362}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coalFlowSource4.coal_a,coalGas_join4. coal_inlet) annotation (Line(
      points={{-72,-286},{-66,-286},{-66,-292},{-60,-292}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(gasFlowSource_T10.gas_a, coalGas_join4.flueGas_inlet)
                                                               annotation (Line(
      points={{-72,-308},{-66,-308},{-66,-304},{-60,-304}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coalGas_split4.coal_inlet,coalSink4. coal_a) annotation (Line(
      points={{134,-292},{142,-292},{142,-286},{150,-286}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(coalGas_split4.flueGas_inlet, gasSink_pT10.gas_a)
                                                           annotation (Line(
      points={{134,-304},{142,-304},{142,-310},{150,-310}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(ramp.y, coalDustValve4.opening_in)
                                            annotation (Line(
      points={{-39,80},{40,80},{40,-290}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalGas_join3.coalDust_outlet,coalDustValve5.inlet)
    annotation (Line(
      points={{-40,-350},{6,-350},{6,-351},{50,-351}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalDustValve5.outlet,          coalGas_split3.coalDust_inlet)
    annotation (Line(
      points={{70,-351},{92,-351},{92,-350},{114,-350}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_split4.coalDust_inlet,coalDustValve4.outlet)
    annotation (Line(
      points={{114,-298},{82,-298},{82,-299},{50,-299}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalDustValve4.inlet,          coalGas_join4.coalDust_outlet)
    annotation (Line(
      points={{30,-299},{-6,-299},{-6,-298},{-40,-298}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, coalDustValve5.opening_in) annotation (Line(
      points={{-39,80},{60,80},{60,-342}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalFlowSource5.coal_a, coalGas_join5.coal_inlet)
                                                          annotation (Line(
      points={{-72,-388},{-66,-388},{-66,-394},{-60,-394}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(gasFlowSource_T11.gas_a, coalGas_join5.flueGas_inlet)
                                                              annotation (Line(
      points={{-72,-410},{-66,-410},{-66,-406},{-60,-406}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coalGas_split5.coal_inlet, coalSink5.coal_a)
                                                     annotation (Line(
      points={{134,-394},{140,-394},{140,-388},{148,-388}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(coalGas_split5.flueGas_inlet, gasSink_pT11.gas_a)
                                                          annotation (Line(
      points={{134,-406},{140,-406},{140,-412},{148,-412}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coalGas_join5.coalDust_outlet,coalDustValve6.inlet)
    annotation (Line(
      points={{-40,-400},{16,-400},{16,-401},{70,-401}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalDustValve6.outlet,          coalGas_split5.coalDust_inlet)
    annotation (Line(
      points={{90,-401},{102,-401},{102,-400},{114,-400}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, coalDustValve6.opening_in) annotation (Line(
      points={{-39,80},{80,80},{80,-392}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-420},{200,260}}),
                        graphics={Text(
          extent={{-206,214},{-54,190}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=8,
          textString="_______________________________________
PURPOSE:
>> Tester for gas valves
_______________________________________
"),                    Text(
          extent={{-218,260},{94,228}},
          lineColor={0,128,0},
          fontSize=20,
          textString="TESTED -- 2015-01-22 //LN")}),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)),
    experiment(StopTime=10));
end Test_GasValves;
