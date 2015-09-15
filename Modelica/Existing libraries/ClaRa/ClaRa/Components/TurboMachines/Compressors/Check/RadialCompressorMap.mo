within ClaRa.Components.TurboMachines.Compressors.Check;
model RadialCompressorMap
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
  inner SimCenter simCenter(redeclare TILMedia.GasTypes.FlueGasTILMedia flueGasModel, T_amb=293.15) annotation (Placement(transformation(extent={{40,20},{60,40}})));
  CompressorGas_L1_stageStacked rpm3000(
    J=0.1,
    rpm_nom=3000,
    p_in_nom=1.0e5,
    Tau_aux=0.000001,
    T_in_nom=293.15,
    Pi_nom=7,
    m_flow_nom=20,
    diameter=1.5,
    eta_mech=0.99,
    Delta_alpha_fixed=0,
    xi_nom={0,0,0,0,0.75,0.23,0,0,0},
    useFixedEnthalpyCharacteristic=true,
    useExternalVIGVangle=false,
    useMechanicalPort=false,
    steadyStateTorque=true,
    N_VIGVstages=1,
    rpm_fixed=3000,
    N_stages=4,
    eta_isen_stage_nom=0.83,
    psi_nom_fixed=1.05) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-26,-110})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT2(
    variable_p=true,
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01},
    p_const=120000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={14,-110})));
  Modelica.Blocks.Sources.Ramp step1(
    duration=20,
    startTime=0,
    offset=4.2e5,
    height=3.65e5)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={42,-116})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT3(
    variable_p=false,
    p_const=100000,
    xi_const={0,0,0,0,0.75,0.23,0,0,0}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-110})));
  CompressorGas_L1_stageStacked rpm2700(
    J=0.1,
    rpm_nom=3000,
    p_in_nom=1.0e5,
    Tau_aux=0.000001,
    T_in_nom=293.15,
    Pi_nom=7,
    m_flow_nom=20,
    diameter=1.5,
    eta_mech=0.99,
    Delta_alpha_fixed=0,
    xi_nom={0,0,0,0,0.75,0.23,0,0,0},
    useFixedEnthalpyCharacteristic=true,
    useExternalVIGVangle=false,
    useMechanicalPort=false,
    steadyStateTorque=true,
    N_VIGVstages=1,
    rpm_fixed=2700,
    N_stages=4,
    eta_isen_stage_nom=0.83,
    psi_nom_fixed=1.05) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-26,-174})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT1(
    variable_p=true,
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01},
    p_const=120000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={14,-174})));
  Modelica.Blocks.Sources.Ramp step2(
    offset=3.2e5,
    duration=20,
    startTime=0,
    height=2.55e5)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={42,-180})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT4(
    variable_p=false,
    p_const=100000,
    xi_const={0,0,0,0,0.75,0.23,0,0,0}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-174})));
  CompressorGas_L1_stageStacked rpm2400(
    J=0.1,
    rpm_nom=3000,
    p_in_nom=1.0e5,
    Tau_aux=0.000001,
    T_in_nom=293.15,
    Pi_nom=7,
    m_flow_nom=20,
    diameter=1.5,
    eta_mech=0.99,
    Delta_alpha_fixed=0,
    xi_nom={0,0,0,0,0.75,0.23,0,0,0},
    useFixedEnthalpyCharacteristic=true,
    useExternalVIGVangle=false,
    useMechanicalPort=false,
    steadyStateTorque=true,
    N_VIGVstages=1,
    rpm_fixed=2400,
    N_stages=4,
    eta_isen_stage_nom=0.83,
    psi_nom_fixed=1.05) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-26,-238})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT5(
    variable_p=true,
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01},
    p_const=120000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={14,-238})));
  Modelica.Blocks.Sources.Ramp step3(
    duration=20,
    startTime=0,
    height=1.8e5,
    offset=2.4e5)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={42,-244})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT6(
    variable_p=false,
    p_const=100000,
    xi_const={0,0,0,0,0.75,0.23,0,0,0}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-238})));
  CompressorGas_L1_stageStacked rpm3300(
    J=0.1,
    rpm_nom=3000,
    p_in_nom=1.0e5,
    Tau_aux=0.000001,
    T_in_nom=293.15,
    Pi_nom=7,
    m_flow_nom=20,
    diameter=1.5,
    eta_mech=0.99,
    Delta_alpha_fixed=0,
    xi_nom={0,0,0,0,0.75,0.23,0,0,0},
    useFixedEnthalpyCharacteristic=true,
    useExternalVIGVangle=false,
    useMechanicalPort=false,
    steadyStateTorque=true,
    N_VIGVstages=1,
    rpm_fixed=3300,
    N_stages=4,
    eta_isen_stage_nom=0.83,
    psi_nom_fixed=1.05) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-26,-46})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT9(
    variable_p=true,
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01},
    p_const=120000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={14,-46})));
  Modelica.Blocks.Sources.Ramp step5(
    duration=20,
    startTime=0,
    height=4.2e5,
    offset=5.9e5)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={42,-52})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT10(
    variable_p=false,
    p_const=100000,
    xi_const={0,0,0,0,0.75,0.23,0,0,0}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-46})));
  CompressorGas_L1_stageStacked rpm3450(
    J=0.1,
    rpm_nom=3000,
    p_in_nom=1.0e5,
    Tau_aux=0.000001,
    T_in_nom=293.15,
    Pi_nom=7,
    m_flow_nom=20,
    diameter=1.5,
    eta_mech=0.99,
    Delta_alpha_fixed=0,
    xi_nom={0,0,0,0,0.75,0.23,0,0,0},
    useFixedEnthalpyCharacteristic=true,
    useExternalVIGVangle=false,
    useMechanicalPort=false,
    steadyStateTorque=true,
    N_VIGVstages=1,
    rpm_fixed=3450,
    N_stages=4,
    eta_isen_stage_nom=0.83,
    psi_nom_fixed=1.05) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-26,-14})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT13(
    variable_p=true,
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01},
    p_const=120000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={14,-14})));
  Modelica.Blocks.Sources.Ramp step7(
    duration=20,
    startTime=0,
    offset=6.9e5,
    height=4.4e5)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={42,-20})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT14(
    variable_p=false,
    p_const=100000,
    xi_const={0,0,0,0,0.75,0.23,0,0,0}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-14})));
  CompressorGas_L1_stageStacked rpm3150(
    J=0.1,
    rpm_nom=3000,
    p_in_nom=1.0e5,
    Tau_aux=0.000001,
    T_in_nom=293.15,
    Pi_nom=7,
    m_flow_nom=20,
    diameter=1.5,
    eta_mech=0.99,
    Delta_alpha_fixed=0,
    xi_nom={0,0,0,0,0.75,0.23,0,0,0},
    useFixedEnthalpyCharacteristic=true,
    useExternalVIGVangle=false,
    useMechanicalPort=false,
    steadyStateTorque=true,
    N_VIGVstages=1,
    rpm_fixed=3150,
    N_stages=4,
    eta_isen_stage_nom=0.83,
    psi_nom_fixed=1.05) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-26,-78})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT15(
    variable_p=true,
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01},
    p_const=120000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={14,-78})));
  Modelica.Blocks.Sources.Ramp step8(
    duration=20,
    startTime=0,
    height=4e5,
    offset=5e5)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={42,-84})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT16(
    variable_p=false,
    p_const=100000,
    xi_const={0,0,0,0,0.75,0.23,0,0,0}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-78})));
  CompressorGas_L1_stageStacked rpm2850(
    J=0.1,
    rpm_nom=3000,
    p_in_nom=1.0e5,
    Tau_aux=0.000001,
    T_in_nom=293.15,
    Pi_nom=7,
    m_flow_nom=20,
    diameter=1.5,
    eta_mech=0.99,
    Delta_alpha_fixed=0,
    xi_nom={0,0,0,0,0.75,0.23,0,0,0},
    useFixedEnthalpyCharacteristic=true,
    useExternalVIGVangle=false,
    useMechanicalPort=false,
    steadyStateTorque=true,
    N_VIGVstages=1,
    rpm_fixed=2850,
    N_stages=4,
    eta_isen_stage_nom=0.83,
    psi_nom_fixed=1.05) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-26,-142})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT17(
    variable_p=true,
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01},
    p_const=120000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={14,-142})));
  Modelica.Blocks.Sources.Ramp step9(
    duration=20,
    startTime=0,
    offset=3.8e5,
    height=2.95e5)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={42,-148})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT18(
    variable_p=false,
    p_const=100000,
    xi_const={0,0,0,0,0.75,0.23,0,0,0}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-142})));
  CompressorGas_L1_stageStacked rpm2550(
    J=0.1,
    rpm_nom=3000,
    p_in_nom=1.0e5,
    Tau_aux=0.000001,
    T_in_nom=293.15,
    Pi_nom=7,
    m_flow_nom=20,
    diameter=1.5,
    eta_mech=0.99,
    Delta_alpha_fixed=0,
    xi_nom={0,0,0,0,0.75,0.23,0,0,0},
    useFixedEnthalpyCharacteristic=true,
    useExternalVIGVangle=false,
    useMechanicalPort=false,
    steadyStateTorque=true,
    N_VIGVstages=1,
    rpm_fixed=2550,
    N_stages=4,
    eta_isen_stage_nom=0.83,
    psi_nom_fixed=1.05) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-26,-206})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT19(
    variable_p=true,
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01},
    p_const=120000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={14,-206})));
  Modelica.Blocks.Sources.Ramp step10(
    duration=20,
    startTime=0,
    height=2.0e5,
    offset=2.8e5)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={42,-212})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT20(
    variable_p=false,
    p_const=100000,
    xi_const={0,0,0,0,0.75,0.23,0,0,0}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-206})));
equation
  connect(step1.y, gasSink_pT2.p)
                                annotation (Line(
      points={{31,-116},{24,-116}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSink_pT3.gas_a, rpm3000.inlet)        annotation (Line(
      points={{-60,-110},{-34,-110}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(rpm3000.outlet, gasSink_pT2.gas_a)        annotation (Line(
      points={{-18,-110},{4,-110}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(step2.y,gasSink_pT1. p)
                                annotation (Line(
      points={{31,-180},{24,-180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSink_pT4.gas_a, rpm2700.inlet)        annotation (Line(
      points={{-60,-174},{-34,-174}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(rpm2700.outlet, gasSink_pT1.gas_a)        annotation (Line(
      points={{-18,-174},{4,-174}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(step3.y,gasSink_pT5. p)
                                annotation (Line(
      points={{31,-244},{24,-244}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSink_pT6.gas_a, rpm2400.inlet)        annotation (Line(
      points={{-60,-238},{-34,-238}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(rpm2400.outlet, gasSink_pT5.gas_a)        annotation (Line(
      points={{-18,-238},{4,-238}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(step5.y,gasSink_pT9. p)
                                annotation (Line(
      points={{31,-52},{24,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSink_pT10.gas_a, rpm3300.inlet)       annotation (Line(
      points={{-60,-46},{-34,-46}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(rpm3300.outlet, gasSink_pT9.gas_a)        annotation (Line(
      points={{-18,-46},{4,-46}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(step7.y, gasSink_pT13.p)
                                annotation (Line(
      points={{31,-20},{24,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSink_pT14.gas_a, rpm3450.inlet)       annotation (Line(
      points={{-60,-14},{-34,-14}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(rpm3450.outlet, gasSink_pT13.gas_a)       annotation (Line(
      points={{-18,-14},{4,-14}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(step8.y, gasSink_pT15.p)
                                annotation (Line(
      points={{31,-84},{24,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSink_pT16.gas_a, rpm3150.inlet)       annotation (Line(
      points={{-60,-78},{-34,-78}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(rpm3150.outlet, gasSink_pT15.gas_a)       annotation (Line(
      points={{-18,-78},{4,-78}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(step9.y, gasSink_pT17.p)
                                annotation (Line(
      points={{31,-148},{24,-148}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSink_pT18.gas_a, rpm2850.inlet)       annotation (Line(
      points={{-60,-142},{-34,-142}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(rpm2850.outlet, gasSink_pT17.gas_a)       annotation (Line(
      points={{-18,-142},{4,-142}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(step10.y, gasSink_pT19.p)
                                annotation (Line(
      points={{31,-212},{24,-212}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSink_pT20.gas_a, rpm2550.inlet)       annotation (Line(
      points={{-60,-206},{-34,-206}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(rpm2550.outlet, gasSink_pT19.gas_a)       annotation (Line(
      points={{-18,-206},{4,-206}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-280},{60,40}},preserveAspectRatio=false),
            graphics={          Text(
          extent={{-98,36},{2,-6}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=7,
          textString="_______________________________________
PURPOSE:
>> Example of different compressor speed lines
LOOK AT:
>> Time plots of mass flow, pressure ratio and efficiency

"),                             Text(
          extent={{-100,34},{-8,28}},
          lineColor={0,128,0},
          fontSize=14,
          textString="TESTED -- 2014-10-08 //LN")}),
    experiment(StopTime=20),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)));
end RadialCompressorMap;
