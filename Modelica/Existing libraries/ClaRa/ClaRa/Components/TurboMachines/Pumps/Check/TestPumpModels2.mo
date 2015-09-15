within ClaRa.Components.TurboMachines.Pumps.Check;
model TestPumpModels2
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

  import Modelica.Constants.pi;
  parameter Modelica.SIunits.Voltage Va=10.0 "Actual armature voltage";
  parameter Modelica.SIunits.Time tStart=75 "Start of armature voltage ramp";
  parameter Modelica.SIunits.Time tRamp=0.8 "Armature voltage ramp";

 //  parameter Modelica.SIunits.Torque TLoad2=13e3 "Nominal load torque";
  parameter Modelica.SIunits.AngularVelocity wLoad2=4600*2*pi/60 "Nominal load speed";
   parameter Modelica.SIunits.Inertia JLoad=10 "Load's moment of inertia";

  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pump_1(eta_hyd=0.82, showExpertSummary=true) annotation (Placement(transformation(extent={{24,-56},{44,-76}})));
  BoundaryConditions.BoundaryVLE_pTxi pressureSink_XRG(p_const=1300000, T_const=463.15) annotation (Placement(transformation(extent={{-16,-76},{4,-56}})));
  inner SimCenter simCenter(redeclare TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1) annotation (Placement(transformation(extent={{120,-160},{140,-140}})));
  Modelica.Blocks.Sources.TimeTable p_out_n1(
    offset=0,
    startTime=0,
    table=[0,15e5; 5,15e5; 10,200e5; 15,200e5; 20,400e5; 25,400e5; 30,150e5; 40,
        150e5; 50,15e5; 51,15e5])
    annotation (Placement(transformation(extent={{160,-40},{140,-20}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG1(variable_p=true, p_const=1000000) annotation (Placement(transformation(extent={{84,-76},{64,-56}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={34,-92})));
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
    J=1) annotation (Placement(transformation(extent={{10,-154},{30,-134}})));
  BoundaryConditions.BoundaryVLE_pTxi pressureSink_XRG4(p_const=1300000, T_const=463.15) annotation (Placement(transformation(extent={{-30,-154},{-10,-134}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG5(variable_p=true, p_const=1000000) annotation (Placement(transformation(extent={{70,-154},{50,-134}})));
  Modelica.Mechanics.Rotational.Sensors.PowerSensor powerSensor1
    annotation (Placement(transformation(extent={{-62,-112},{-42,-132}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=3)
    annotation (Placement(transformation(extent={{122,-76},{110,-64}})));
  Modelica.Blocks.Sources.TimeTable p_out_n2(
    offset=0,
    startTime=50,
    table=[0,15e5; 5,15e5; 10,200e5; 15,200e5; 20,400e5; 25,400e5; 30,150e5; 40,
        150e5; 50,15e5; 51,15e5])
    annotation (Placement(transformation(extent={{160,-80},{140,-60}})));
  Modelica.Blocks.Sources.TimeTable p_out_n3(
    offset=0,
    startTime=100,
    table=[0,15e5; 5,15e5; 10,200e5; 15,200e5; 20,410e5; 25,410e5; 30,150e5; 40,
        150e5; 50,15e5; 51,15e5])
    annotation (Placement(transformation(extent={{160,-120},{140,-100}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=tRamp,
    height=Va,
    startTime=tStart,
    offset=Va)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=0,
        origin={-186,-102})));
  Modelica.Electrical.Analog.Sources.SignalVoltage signalVoltage
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
                                                                   rotation=90,
        origin={-160,-102})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(
        origin={-160,-142},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet
                                                       dcpm2(
    frictionParameters(PRef=100),
    alpha20a(displayUnit="1/K") = Modelica.Electrical.Machines.Thermal.Constants.alpha20Copper,
    coreParameters(PRef=200),
    strayLoadParameters(PRef=50),
    brushParameters(V=0.5),
    La=1,
    IaNominal=2,
    Ra=0.08,
    TaOperational=368.15,
    VaNominal=1/4*Va,
    wNominal=481.71087355043,
    TaNominal=368.15,
    TaRef=293.15)
    annotation (Placement(transformation(extent={{-132,-132},{-112,-112}},
          rotation=0)));
  Modelica.Mechanics.Rotational.Components.Inertia loadInertia2(J=JLoad,
    stateSelect=StateSelect.always,
    w(start=4600/60*2*pi),
    phi(start=0.017453292519943))
    annotation (Placement(transformation(extent={{-92,-132},{-72,-112}},
          rotation=0)));
equation
  connect(pressureSink_XRG.steam_a, pump_1.inlet)        annotation (Line(
      points={{4,-66},{24,-66}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pump_1.outlet, pressureSink_XRG1.steam_a) annotation (Line(
      points={{44,-66},{64,-66}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gain.y, pump_1.P_drive) annotation (Line(
      points={{34,-81},{34,-78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump_3.outlet,pressureSink_XRG5. steam_a)        annotation (Line(
      points={{30,-144},{50,-144}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_XRG4.steam_a,pump_3. inlet)        annotation (Line(
      points={{-10,-144},{10,-144}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(multiSum.u[1], p_out_n1.y) annotation (Line(
      points={{122,-67.2},{126,-67.2},{126,-30},{139,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.y, pressureSink_XRG5.p) annotation (Line(
      points={{108.98,-70},{96,-70},{96,-138},{70,-138}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.y, pressureSink_XRG1.p) annotation (Line(
      points={{108.98,-70},{94,-70},{94,-60},{84,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p_out_n2.y, multiSum.u[2]) annotation (Line(
      points={{139,-70},{122,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p_out_n3.y, multiSum.u[3]) annotation (Line(
      points={{139,-110},{126,-110},{126,-72.8},{122,-72.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(powerSensor1.power, gain.u) annotation (Line(
      points={{-60,-111},{-60,-110},{34,-110},{34,-104}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y,signalVoltage. v)   annotation (Line(points={{-175,-102},{-175,-102},{-167,-102}},
                         color={0,0,255}));
  connect(signalVoltage.n,ground. p)   annotation (Line(points={{-160,-112},{-160,-122},{-160,-132}},
                    color={0,0,255}));
  connect(dcpm2.flange,loadInertia2. flange_a)
                                             annotation (Line(
      points={{-112,-122},{-92,-122}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(signalVoltage.p,dcpm2. pin_ap) annotation (Line(
      points={{-160,-92},{-116,-92},{-116,-112}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(signalVoltage.n,dcpm2. pin_an) annotation (Line(
      points={{-160,-112},{-128,-112}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(loadInertia2.flange_b, powerSensor1.flange_a) annotation (Line(
      points={{-72,-122},{-62,-122}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(powerSensor1.flange_b, pump_3.shaft) annotation (Line(
      points={{-42,-122},{20,-122},{20,-134.1}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-220,
            -160},{160,-20}}),
                      graphics={Text(
          extent={{-218,-34},{-20,-58}},
          lineColor={0,128,0},
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="_____________________________________________
PURPOSE:
Show how to couple the pump with shaft with an e-motor
_____________________________________________
"),                             Text(
          extent={{-218,-60},{-22,-74}},
          lineColor={255,179,0},
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="ISSUES:
The parameters of the e-motor are not configured to match the design data of the pump model
___________________________________________________________________________
"),                    Text(
          extent={{-228,-18},{-28,-38}},
          lineColor={0,128,0},
          fontSize=31,
          textString="TESTED -- YYYY-MM-DD //XX")}),
    experiment(StopTime=150),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end TestPumpModels2;
