within ClaRa.Components.Mills.HardCoalMills.Check;
model combineMillandFurnace
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
  Modelica.Blocks.Sources.Ramp PTarget1(
    startTime=10000,
    duration=1000,
    height=0,
    offset=INIT.P_target_)
    annotation (Placement(transformation(extent={{-94,-12},{-74,8}})));
  BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource1(
    m_flow_const=2.2*6.7362,
    variable_m_flow=true,
    T_const=393.15,
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.8,0.1985,0,0.001,0})
                    annotation (Placement(transformation(extent={{-50,-53},{-30,-33}})));
  BoundaryConditions.BoundaryCoal_Txim_flow coalFlowSource(m_flow_const=2, variable_m_flow=true) annotation (Placement(transformation(extent={{-48,-17},{-28,3}})));
  Modelica.Blocks.Math.Gain gain2(k=INIT.boiler.Q_flow_nom/30e6) "INIT.boiler.Q_nom/combustionChamber.LHV_fixed" annotation (Placement(transformation(extent={{-68,-7},{-58,3}})));
  Modelica.Blocks.Sources.RealExpression m_Primary2(y=-1.1*coalFlowSource.coal_a.m_flow
        *15) "combustionChamber.m_flow_air_req*1.1"
    annotation (Placement(transformation(extent={{16,-14},{-16,14}},
        rotation=180,
        origin={-84,-32})));
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3
                     mills1(
    millKoeff=ClaRa.Components.Mills.HardCoalMills.Fundamentals.STV1(),
    N_mills=1,
    initChoice=ClaRa.Basics.Choices.Init.noInit,
    T_0=363.15)
    annotation (Placement(transformation(extent={{-2,-33},{18,-13}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    offset=1.50,
    startTime=1000,
    duration=10,
    height=0)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  ClaRa.Components.Adapters.CoalGas_join coalGas_join_burner4
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-16,-23})));
  DYNCAP.CycleINIT.InitSteamCycle_Rostock_2
                                     INIT(
    p_LS_out_nom=249.7e5,
    p_RS_out_nom=50.51e5,
    dp_LS_nom=39e5,
    dp_RS_nom=4.86e5,
    p_FWT_nom=4.629e5,
    P_target_=1)
    annotation (Placement(transformation(extent={{-8,70},{12,90}})));
  inner SimCenter simCenter(redeclare replaceable TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1, redeclare ClaRa.Basics.Media.Fuel.Coal_v2 fuelModel1) annotation (Placement(transformation(extent={{12,70},{32,90}})));
  Furnace.SimpleCombustionChamber combustionChamber(xi_NOx=0) annotation (Placement(transformation(extent={{64,-34},{84,-14}})));
  BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink(xi_const={0,0,0,0,0.79,0.21,0,0}, p_const=100000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,18})));
  BoundaryConditions.BoundarySlag_pT coalSink annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,-58})));
equation
  connect(PTarget1.y, gain2.u)
                              annotation (Line(
      points={{-73,-2},{-69,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain2.y, coalFlowSource.m_flow) annotation (Line(
      points={{-57.5,-2},{-57.5,-1.5},{-48,-1.5},{-48,-1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, mills1.classifierSpeed) annotation (Line(
      points={{1,30},{8,30},{8,-12.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalGas_join_burner4.coalDust_outlet, mills1.inlet) annotation (Line(
      points={{-6,-23},{-2,-23}},
      color={175,175,175},
      smooth=Smooth.None));
  connect(coalFlowSource.coal_a, coalGas_join_burner4.coal_inlet)  annotation (
      Line(
      points={{-28,-7},{-28,-17},{-26,-17}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(fluelGasFlowSource1.gas_a, coalGas_join_burner4.flueGas_inlet)
    annotation (Line(
      points={{-30,-43},{-28,-43},{-28,-29},{-26,-29}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(flueGasPressureSink.gas_a, combustionChamber.flueGas_outlet)
    annotation (Line(
      points={{70,8},{70,-14},{74,-14}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coalSink.slag_inlet, combustionChamber.slag_outlet) annotation (Line(
      points={{70.2,-48},{70.2,-33.8},{74,-33.8}},
      color={127,127,0},
      smooth=Smooth.None));
  connect(mills1.outlet, combustionChamber.inlet) annotation (Line(
      points={{18,-23},{41,-23},{41,-24},{64,-24}},
      color={175,175,175},
      smooth=Smooth.None));
  connect(m_Primary2.y, fluelGasFlowSource1.m_flow) annotation (Line(
      points={{-66.4,-32},{-72,-32},{-72,-37},{-50,-37}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics={Text(
          extent={{-100,-84},{100,-100}},
          lineColor={0,128,0},
          lineThickness=0.5,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid,
          textString="IDEA:
shows how to combine a mill model to a simple furnace model",
          horizontalAlignment=TextAlignment.Left)}));
end combineMillandFurnace;
