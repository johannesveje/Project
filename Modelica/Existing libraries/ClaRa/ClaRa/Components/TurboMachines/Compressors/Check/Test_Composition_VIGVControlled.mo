within ClaRa.Components.TurboMachines.Compressors.Check;
model Test_Composition_VIGVControlled
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
  inner SimCenter simCenter(redeclare TILMedia.GasTypes.FlueGasTILMedia flueGasModel, T_amb=293.15) annotation (Placement(transformation(extent={{60,40},{80,60}})));
  CompressorGas_L1_stageStacked GasFanAdvanced(
    J=0.1,
    rpm_fixed=3000,
    rpm_nom=3000,
    p_in_nom=1.0e5,
    Tau_aux=0.000001,
    useMechanicalPort=true,
    steadyStateTorque=false,
    T_in_nom=293.15,
    m_flow_nom=20,
    diameter=1.5,
    eta_mech=0.99,
    eta_isen_stage_nom=0.9,
    Delta_alpha_fixed=0,
    xi_nom={0,0,0,0,0.75,0.23,0,0,0},
    useExternalVIGVangle=true,
    useFixedEnthalpyCharacteristic=true,
    N_VIGVstages=1,
    N_stages=1,
    psi_nom_fixed=0.8,
    Pi_nom=1.125) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-84,-50})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT2(
    p_const(displayUnit="Pa") = 1.125e5,
    xi_const={0,0,0.0,0,0.8,0.2,0,0,0.0},
    variable_p=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,-50})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT3(
    variable_p=false,
    p_const=100000,
    xi_const={0,0,0,0,0.75,0.23,0,0,0})
                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-132,-50})));
  Modelica.Mechanics.Rotational.Sources.Speed speed1(
                                                    exact=true, useSupport=
        false)
    annotation (Placement(transformation(extent={{-134,-4},{-114,16}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia1(J=10)
    annotation (Placement(transformation(extent={{-110,-4},{-90,16}})));
  Modelica.Blocks.Sources.Ramp step2(
    offset=2*Modelica.Constants.pi*3000/60,
    height=0.1*2*Modelica.Constants.pi*3000/60,
    duration=5,
    startTime=25)
                 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-152,6})));
  Modelica.Blocks.Sources.TimeTable timeTable1(
    startTime=0,
    offset=1.125e5,
    table=[0,0; 10,0; 15,0.01e5; 16,0.01e5])
    annotation (Placement(transformation(extent={{80,-60},{60,-40}})));
  Utilities.Blocks.LimPID PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    perUnitConversion=true,
    y_ref=1,
    y_max=30,
    y_min=-30,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    y_start=0,
    u_ref=0.8,
    k=100,
    Tau_i=0.0001,
    sign=-1)
    annotation (Placement(transformation(extent={{-162,-34},{-142,-14}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=0.77272727)
    annotation (Placement(transformation(extent={{-192,-34},{-172,-14}})));
  VolumesValvesFittings.Fittings.FlueGasJunction_L2 flueGasJunction_L2_1(
    T_start=simCenter.T_amb,
    p_start=1.125e5,
    mixingRatio_initial={0,0,0,0,0.77272727,0.22727273,0,0,0},
    volume=0.1,
    initType=ClaRa.Basics.Choices.Init.steadyDensity)
    annotation (Placement(transformation(extent={{8,-8},{-8,8}},
        rotation=180,
        origin={-54,-50})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T(xi_const={0,0,0,0,1,0,0,0,0}, m_flow_const=2) annotation (Placement(transformation(extent={{-80,-4},{-60,16}})));
  Sensors.GasComponentSensor gasComponentSensor(compositionDefinedBy=1,
      component=5)
    annotation (Placement(transformation(extent={{-34,-50},{-14,-30}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    T=0.1,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=1.125e5)
    annotation (Placement(transformation(extent={{48,-60},{28,-40}})));
equation
  connect(speed1.flange, inertia1.flange_a) annotation (Line(
      points={{-114,6},{-110,6}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(step2.y, speed1.w_ref) annotation (Line(
      points={{-141,6},{-136,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(inertia1.flange_b, GasFanAdvanced.shaft) annotation (Line(
      points={{-90,6},{-84,6},{-84,-42}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(PID.y, GasFanAdvanced.Delta_alpha_input) annotation (Line(
      points={{-141.1,-24},{-108,-24},{-108,-43.6},{-92.64,-43.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, PID.u_s) annotation (Line(
      points={{-171,-24},{-164,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasComponentSensor.outlet, gasSink_pT2.gas_a) annotation (Line(
      points={{-14,-50},{0,-50}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PID.u_m, gasComponentSensor.fraction) annotation (Line(
      points={{-152,-36},{-152,-64},{-6,-64},{-6,-40},{-13,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(timeTable1.y, firstOrder.u) annotation (Line(
      points={{59,-50},{50,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, gasSink_pT2.p) annotation (Line(
      points={{27,-50},{24,-50},{24,-56},{20,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSink_pT3.gas_a, GasFanAdvanced.inlet) annotation (Line(
      points={{-122,-50},{-92,-50}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(GasFanAdvanced.outlet, flueGasJunction_L2_1.portA) annotation (Line(
      points={{-76,-50},{-62,-50}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasJunction_L2_1.portB, gasComponentSensor.inlet) annotation (Line(
      points={{-46,-50},{-34,-50}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gasFlowSource_T.gas_a, flueGasJunction_L2_1.portC) annotation (Line(
      points={{-60,6},{-54,6},{-54,-42}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(extent={{-200,-80},{80,60}}, preserveAspectRatio=false),
            graphics={          Text(
          extent={{-198,46},{-124,36}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="________________________________________________________________
PURPOSE:
>> Example for a VIGV component mass control of a compressor with changing pressure ratio
LOOK AT:
>> Time plots of composition and pressure ratio as well as the VIGV position

"),                             Text(
          extent={{-200,60},{-84,50}},
          lineColor={0,128,0},
          fontSize=34,
          textString="TESTED -- 2014-10-08 //LN")}),
    experiment(StopTime=40),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}},     preserveAspectRatio=false)));
end Test_Composition_VIGVControlled;
