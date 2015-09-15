within ClaRa.Components.TurboMachines.Pumps.Check;
model TestPumpModel_SwitchOff_L1Pump "SwitchOff of L1 pump"
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

  inner SimCenter simCenter(redeclare TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1, showExpertSummary=true) annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
  PumpVLE_L1_affinity pump(
    steadyStateTorque=false,
    V_flow_max=2600/3600,
    eta_hyd_nom=0.82,
    rpm_nom=4600,
    clearSection=0.01,
    exp_rpm=0.15,
    exp_flow=2.8,
    showExpertSummary=true,
    J=1,
    rpm_fixed=4600,
    Delta_p_max=2e5,
    Tau_stab=1e-2,
    useMechanicalPort=true) annotation (Placement(transformation(extent={{-28,-152},{-8,-132}})));
  BoundaryConditions.BoundaryVLE_pTxi source(T_const=463.15, p_const=12e5) annotation (Placement(transformation(extent={{-78,-152},{-58,-132}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi sink(
    p_const=12e5,
    h_const=9e4,
    variable_p=true) annotation (Placement(transformation(extent={{60,-152},{40,-132}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia1(J=1000)
    annotation (Placement(transformation(extent={{-48,-112},{-28,-92}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed1(exact=false)
    annotation (Placement(transformation(extent={{-78,-112},{-58,-92}})));
  Visualisation.DynDisplay dynDisplay(
    varname="Mechanic Power",
    unit="W",
    x1=pump.P_shaft)
    annotation (Placement(transformation(extent={{100,-160},{160,-144}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(     initType=Modelica.Blocks.Types.Init.SteadyState,
    k=2*Modelica.Constants.pi/60,
    T=0.0001)
    annotation (Placement(transformation(extent={{-118,-112},{-98,-92}})));

  Modelica.Blocks.Sources.TimeTable
                               rpmRamp(
    offset=0,
    table=[0,5500;
           100,5500;
           120,5200;
           130,5200;
           150,4800;
           180,4800;
           200,5500;
           330,5500;
           350,0;
           360,0;
           380,3000;
           400,5000;
           420,5000],
    startTime=0)
    annotation (Placement(transformation(extent={{-150,-112},{-130,-92}})));
  Modelica.Blocks.Sources.TimeTable Delta_pRamp(
    startTime=0,
    table=[0,-5e5;
           30,0;
           60,0;
           90,40e5;
           250,40e5;
           280,75e5;
           300,75e5;
           310,0;
           330,0;
           360,-5e5;
           390,-5e5],
    offset=sink.p_const)
    annotation (Placement(transformation(extent={{148,-110},{128,-90}})));
equation
  connect(source.steam_a, pump.inlet)                     annotation (Line(
      points={{-58,-142},{-28,-142}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(inertia1.flange_a, speed1.flange)
                                           annotation (Line(
      points={{-48,-102},{-58,-102}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(firstOrder.y, speed1.w_ref) annotation (Line(
      points={{-97,-102},{-80,-102}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Delta_pRamp.y, sink.p) annotation (Line(
      points={{127,-100},{94,-100},{94,-136},{60,-136}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(inertia1.flange_b, pump.shaft) annotation (Line(
      points={{-28,-102},{-18,-102},{-18,-132.1}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(rpmRamp.y, firstOrder.u) annotation (Line(
      points={{-129,-102},{-120,-102}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump.outlet, sink.steam_a) annotation (Line(
      points={{-8,-142},{40,-142}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -160},{160,40}}),
                      graphics={Text(
          extent={{-158,13},{134,-46}},
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
          extent={{-184,42},{16,22}},
          lineColor={0,128,0},
          fontSize=31,
          textString="TESTED -- YYYY-MM-DD //XX")}),
    experiment(StopTime=500, __Dymola_NumberOfIntervals=50000),
    __Dymola_experimentSetupOutput(equdistant=false, events=false),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end TestPumpModel_SwitchOff_L1Pump;
