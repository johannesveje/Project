within ClaRa.Components.TurboMachines.Pumps.Check;
model TestPumpModel_NonDesignOperation_L2Pump "Non Design Operation: zero mass flow through valve"
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

  inner SimCenter simCenter(redeclare TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1) annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
  Modelica.Blocks.Sources.TimeTable
                               ramp1(
    startTime=0,
    table=[0,-1000/60*2*3.14; 50,-1000/60*2*3.14; 51,0; 100,0; 101,500/60*2*
        3.14; 150,500/60*2*3.14],
    offset=2*Modelica.Constants.pi*4600/60)
    annotation (Placement(transformation(extent={{-158,-112},{-138,-92}})));
  Modelica.Blocks.Sources.TimeTable p_out_n1(
    offset=0,
    startTime=0,
    table=[0,10e5; 5,10e5; 10,200e5; 15,200e5; 20,400e5; 25,400e5; 30,150e5; 40,
        150e5; 50,0.1e5; 51,0.1e5])
    annotation (Placement(transformation(extent={{160,-50},{140,-30}})));
  PumpVLE_L2_affinity pump_3(
    steadyStateTorque=false,
    V_flow_max=2600/3600,
    rpm_nom=4600,
    clearSection=0.01,
    exp_rpm=0.15,
    exp_flow=2.8,
    showExpertSummary=true,
    J=1,
    rpm_fixed=4600,
    Delta_p_max=2e5,
    Tau_stab=1e-2,
    m_flow_nom=1,
    volume_fluid=0.02,
    h_start=27.8944e5,
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (             Delta_p_nom=1000),
    useMechanicalPort=true,
    initType=ClaRa.Basics.Choices.Init.noInit,
    p_start=1400000,
    eta_hyd_nom=0.82) annotation (Placement(transformation(extent={{-42,-152},{-22,-132}})));
  BoundaryConditions.BoundaryVLE_pTxi pressureSink_XRG4(p_const=1200000, T_const=463.15) annotation (Placement(transformation(extent={{-78,-152},{-58,-132}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG5(
    variable_p=false,
    p_const=12e5,
    h_const=9e4) annotation (Placement(transformation(extent={{60,-152},{40,-132}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia1(J=1000)
    annotation (Placement(transformation(extent={{-48,-112},{-28,-92}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed1(exact=false)
    annotation (Placement(transformation(extent={{-78,-112},{-58,-92}})));
  Visualisation.DynDisplay dynDisplay(
    varname="Mechanic Power",
    unit="W",
    x1=pump_3.P_shaft)
    annotation (Placement(transformation(extent={{100,-160},{160,-144}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=3)
    annotation (Placement(transformation(extent={{100,-88},{88,-76}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=1, initType=Modelica.Blocks.Types.Init.SteadyState)
    annotation (Placement(transformation(extent={{-118,-112},{-98,-92}})));
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
  VolumesValvesFittings.Valves.ValveVLE_L1 valveVLE_L1_1(checkValve=false,
      redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticNominalPoint (
         Delta_p_nom=1000, Delta_p_eps=1000),
    openingInputIsActive=true)
    annotation (Placement(transformation(extent={{8,-148},{28,-136}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-1,
    offset=1,
    startTime=100,
    duration=20)
    annotation (Placement(transformation(extent={{-18,-98},{2,-78}})));

initial equation
//  pump_3.inlet.m_flow = -pump_3.outlet.m_flow;

equation
  connect(pressureSink_XRG4.steam_a,pump_3. inlet)        annotation (Line(
      points={{-58,-142},{-42,-142}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(inertia1.flange_a, speed1.flange)
                                           annotation (Line(
      points={{-48,-102},{-58,-102}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(multiSum.u[1], p_out_n1.y) annotation (Line(
      points={{100,-79.2},{120,-79.2},{120,-40},{139,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, firstOrder.u) annotation (Line(
      points={{-137,-102},{-120,-102}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, speed1.w_ref) annotation (Line(
      points={{-97,-102},{-80,-102}},
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
  connect(valveVLE_L1_1.outlet, pressureSink_XRG5.steam_a) annotation (Line(
      points={{28,-142},{40,-142}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, valveVLE_L1_1.opening_in) annotation (Line(
      points={{3,-88},{14,-88},{14,-90},{18,-90},{18,-133}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump_3.outlet, valveVLE_L1_1.inlet) annotation (Line(
      points={{-22,-142},{8,-142}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(inertia1.flange_b, pump_3.shaft) annotation (Line(
      points={{-28,-102},{-30,-102},{-30,-132.1},{-32,-132.1}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -160},{160,40}}),
                      graphics={Text(
          extent={{-156,23},{136,-71}},
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
    
"),                             Text(
          extent={{-156,-175},{136,-269}},
          lineColor={255,0,0},
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="________________________________________________________________________________________________________
LOOK AT:
1. The pressure difference generated by the pump is decreased by the pressure loss due to fluid flow inside the pump
2. at initialisation inlet a nd outlet mass flows do not have start values so far
3. further more we need to specify start avlues for         pump_3.pump.h_iso
        valveVLE_L1_1.iCom.rho_in


________________________________________________________________________________________________________
    
"),                    Text(
          extent={{-182,40},{18,20}},
          lineColor={0,128,0},
          fontSize=31,
          textString="TESTED -- YYYY-MM-DD //XX")}),
    experiment(StopTime=150),
    __Dymola_experimentSetupOutput(equdistant=false, events=false),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end TestPumpModel_NonDesignOperation_L2Pump;
