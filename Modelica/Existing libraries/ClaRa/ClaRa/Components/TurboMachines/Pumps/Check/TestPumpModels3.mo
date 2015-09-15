within ClaRa.Components.TurboMachines.Pumps.Check;
model TestPumpModels3
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

  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pump_1(eta_hyd=0.82, showExpertSummary=true) annotation (Placement(transformation(extent={{-16,-62},{4,-82}})));
  BoundaryConditions.BoundaryVLE_pTxi pressureSink_XRG(p_const=1300000, T_const=463.15) annotation (Placement(transformation(extent={{-76,-82},{-56,-62}})));
  inner SimCenter simCenter(redeclare TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1) annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
  Modelica.Blocks.Sources.TimeTable
                               ramp1(
    startTime=0,
    table=[0,-1000/60*2*3.14; 50,-1000/60*2*3.14; 51,0; 100,0; 101,500/60*2*
        3.14; 150,500/60*2*3.14],
    offset=2*Modelica.Constants.pi*4600/60)
    annotation (Placement(transformation(extent={{-156,-126},{-136,-106}})));
  Modelica.Blocks.Sources.TimeTable p_out_n1(
    offset=0,
    startTime=0,
    table=[0,10e5; 5,10e5; 10,200e5; 15,200e5; 20,400e5; 25,400e5; 30,150e5; 40,
        150e5; 50,0.1e5; 51,0.1e5])
    annotation (Placement(transformation(extent={{160,-50},{140,-30}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG1(variable_p=true, p_const=1000000) annotation (Placement(transformation(extent={{64,-82},{44,-62}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=90,
        origin={-6,-97})));
  PumpVLE_L1_affinity pump_3(
    useMechanicalPort=true,
    steadyStateTorque=false,
    V_flow_max=2600/3600,
    Delta_p_max=876*9.81*3680,
    eta_hyd_nom=0.82,
    rpm_nom=4600,
    clearSection=0.01,
    exp_rpm=0.15,
    exp_flow=2.8,
    showExpertSummary=true,
    J=1) annotation (Placement(transformation(extent={{-20,-156},{0,-136}})));
  BoundaryConditions.BoundaryVLE_pTxi pressureSink_XRG4(p_const=1300000, T_const=463.15) annotation (Placement(transformation(extent={{-80,-156},{-60,-136}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG5(variable_p=true, p_const=1000000) annotation (Placement(transformation(extent={{60,-156},{40,-136}})));
  Modelica.Mechanics.Rotational.Sensors.PowerSensor powerSensor1
    annotation (Placement(transformation(extent={{-8,-106},{12,-126}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia1(J=10)
    annotation (Placement(transformation(extent={{-46,-126},{-26,-106}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed1(
                                                    exact=true)
    annotation (Placement(transformation(extent={{-76,-126},{-56,-106}})));
  Modelica.Mechanics.Rotational.Sensors.TorqueSensor torqueSensor
    annotation (Placement(transformation(extent={{14,-106},{34,-126}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor
    annotation (Placement(transformation(extent={{34,-126},{54,-106}})));
  Visualisation.DynDisplay dynDisplay(
    varname="Mechanic Power",
    unit="W",
    x1=-torqueSensor.tau*speedSensor.w)
    annotation (Placement(transformation(extent={{100,-160},{160,-144}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=3)
    annotation (Placement(transformation(extent={{100,-88},{88,-76}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=1, initType=Modelica.Blocks.Types.Init.SteadyState)
    annotation (Placement(transformation(extent={{-116,-126},{-96,-106}})));
  Modelica.Blocks.Sources.TimeTable p_out_n2(
    offset=0,
    startTime=50,
    table=[0,10e5; 5,10e5; 10,200e5; 15,200e5; 20,400e5; 25,400e5; 30,150e5; 40,
        150e5; 50,0.1e5; 51,0.1e5])
    annotation (Placement(transformation(extent={{160,-92},{140,-72}})));
  Modelica.Blocks.Sources.TimeTable p_out_n3(
    offset=0,
    startTime=100,
    table=[0,10e5; 5,10e5; 10,200e5; 15,200e5; 20,410e5; 25,410e5; 30,150e5; 40,
        150e5; 50,0.1e5; 51,0.1e5])
    annotation (Placement(transformation(extent={{160,-132},{140,-112}})));
equation
  connect(pressureSink_XRG.steam_a, pump_1.inlet)        annotation (Line(
      points={{-56,-72},{-16,-72}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pump_1.outlet, pressureSink_XRG1.steam_a) annotation (Line(
      points={{4,-72},{44,-72}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gain.y, pump_1.P_drive) annotation (Line(
      points={{-6,-91.5},{-6,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump_3.outlet,pressureSink_XRG5. steam_a)        annotation (Line(
      points={{0,-146},{40,-146}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_XRG4.steam_a,pump_3. inlet)        annotation (Line(
      points={{-60,-146},{-20,-146}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(inertia1.flange_a, speed1.flange)
                                           annotation (Line(
      points={{-46,-116},{-56,-116}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(inertia1.flange_b, powerSensor1.flange_a) annotation (Line(
      points={{-26,-116},{-8,-116}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(powerSensor1.flange_b, torqueSensor.flange_a) annotation (Line(
      points={{12,-116},{14,-116}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(torqueSensor.flange_b, pump_3.shaft) annotation (Line(
      points={{34,-116},{34,-134},{-10,-134},{-10,-136.1}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(speedSensor.flange, torqueSensor.flange_b) annotation (Line(
      points={{34,-116},{34,-116}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(multiSum.u[1], p_out_n1.y) annotation (Line(
      points={{100,-79.2},{120,-79.2},{120,-40},{139,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.y, pressureSink_XRG5.p) annotation (Line(
      points={{86.98,-82},{82,-82},{82,-140},{60,-140}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.y, pressureSink_XRG1.p) annotation (Line(
      points={{86.98,-82},{86,-82},{86,-66},{64,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, firstOrder.u) annotation (Line(
      points={{-135,-116},{-118,-116}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, speed1.w_ref) annotation (Line(
      points={{-95,-116},{-78,-116}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p_out_n2.y, multiSum.u[2]) annotation (Line(
      points={{139,-82},{100,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p_out_n3.y, multiSum.u[3]) annotation (Line(
      points={{139,-122},{120,-122},{120,-84.8},{100,-84.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(powerSensor1.power, gain.u) annotation (Line(
      points={{-6,-105},{-6,-103}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-160,
            -160},{160,40}}),
                      graphics={Text(
          extent={{-158,29},{134,-65}},
          lineColor={0,128,0},
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="________________________________________________________________________________________________________
PURPOSE:
test and compare two different pump models under various boundary steps and speed steps. The scenario comprises reverse flow 
conditions which is handled in different ways. The idea of the setup is to engage the simple pump with the power consumed by the
advanced pump in order to create comparable loads in both models.
________________________________________________________________________________________________________
LOOK AT:
1. The summary records of both models. While the pressure boundary is exactly the same in both pumps (look at Delta_p) the volume
    flow rate differs significantly when reverse flow occurs in the advanced pump. Please note that in case Delta_p=0 for the simple pump
    calculates a very high (infinite) flow rate as the drive power is a hard input. Due to this fact the simple pump may not be used when 
    back flow or unsufficient drive power scenarios may occur. 
2. The volume flow rate in design operation is quite similar, deviations can be explained when considering the different pump caracteristics:
    The simple pump assumes a linear correlation between pressure difference and flow rate while the advanced pump implys a quardatic
    relationship.
________________________________________________________________________________________________________
    
"),                    Text(
          extent={{-182,42},{18,22}},
          lineColor={0,128,0},
          fontSize=31,
          textString="TESTED -- YYYY-MM-DD //XX")}),
    experiment(StopTime=150),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end TestPumpModels3;
