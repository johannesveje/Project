within ClaRa.Components.VolumesValvesFittings.Fittings.Check;
model Test_SprayInjector
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
  ClaRa.Components.VolumesValvesFittings.Fittings.SprayInjector_L3 injector(
    p_nom(displayUnit="Pa") = 12e5,
    m_flow_nom_main=150,
    h_nom_Main=3800e3,
    h_nom_Spray=800e3,
    h_start_Main=3800e3,
    h_start_Spray=800e3,
    showExpertSummary=true,
    showData=true,
    initType=ClaRa.Basics.Choices.Init.steadyState,
    p_start(displayUnit="Pa") = 250e5,
    Delta_p_nozzle=1800000) annotation (Placement(transformation(extent={{-30,-60},{-10,-44}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSource_XRG(h_const=800e3, p_const=30.0e5) annotation (Placement(transformation(extent={{60,-94},{40,-74}})));
  inner SimCenter simCenter(useHomotopy=true, redeclare replaceable TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1) annotation (Placement(transformation(extent={{80,80},{100,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG2(
    m_flow_const=43.551,
    variable_m_flow=true,
    h_const=3800e3) annotation (Placement(transformation(extent={{-62,-60},{-42,-40}})));
  Modelica.Blocks.Sources.Ramp ramp(
    startTime=2000,
    offset=1,
    height=-0.5,
    duration=0.100)
    annotation (Placement(transformation(extent={{-100,-94},{-80,-74}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=200,
    startTime=200,
    offset=150,
    duration=2)
    annotation (Placement(transformation(extent={{-100,-54},{-80,-34}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSource_XRG1(
    h_const=3000e3,
    variable_h=true,
    variable_p=true) annotation (Placement(transformation(extent={{60,-60},{40,-40}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    startTime=600,
    height=-1e5,
    duration=0.1,
    offset=25.0e5)
    annotation (Placement(transformation(extent={{98,-54},{78,-34}})));
  Modelica.Blocks.Sources.Ramp ramp3(
    startTime=1000,
    height=-2500e3,
    offset=3000e3,
    duration=0.100)
    annotation (Placement(transformation(extent={{98,-94},{78,-74}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1
                       valve(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticNominalPoint (                   rho_in_nom=20, m_flow_nom=300))
    annotation (Placement(transformation(extent={{2,-56},{22,-44}})));
  Visualisation.Quadruple quadruple
    annotation (Placement(transformation(extent={{-8,-74},{12,-64}})));
  SprayInjector_L3_advanced                                     injector1(
    p_start(displayUnit="Pa") = 12e5,
    showExpertSummary=true,
    showData=true,
    p_nom(displayUnit="Pa") = 250e5,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                      m_flow_nom=10, Delta_p_nom=1.8e5))
    annotation (Placement(transformation(extent={{-30,14},{-10,30}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSource_XRG3(h_const=800e3, p_const=30.0e5) annotation (Placement(transformation(extent={{60,-20},{40,0}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG4(
    m_flow_const=43.551,
    variable_m_flow=true,
    h_const=3800e3) annotation (Placement(transformation(extent={{-62,14},{-42,34}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSource_XRG5(
    h_const=3000e3,
    variable_h=true,
    variable_p=true) annotation (Placement(transformation(extent={{60,14},{40,34}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1
                       valve1(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticNominalPoint (                   rho_in_nom=20, m_flow_nom=300))
    annotation (Placement(transformation(extent={{4,18},{24,30}})));
  Visualisation.Quadruple quadruple1
    annotation (Placement(transformation(extent={{-8,0},{12,10}})));
equation
  connect(ramp1.y, massFlowSource_XRG2.m_flow) annotation (Line(
      points={{-79,-44},{-64,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp3.y, massFlowSource_XRG1.h) annotation (Line(
      points={{77,-84},{69,-84},{69,-50},{60,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, massFlowSource_XRG1.p) annotation (Line(
      points={{77,-44},{60,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, injector.opening)
                                annotation (Line(
      points={{-79,-84},{-28,-84},{-28,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_XRG2.steam_a, injector.MainInlet)
                                                       annotation (Line(
      points={{-42,-50},{-36,-50},{-36,-50.4},{-30,-50.4}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_XRG.steam_a, injector.SprayInlet)
                                                       annotation (Line(
      points={{40,-84},{-22,-84},{-22,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(injector.outlet1, valve.inlet) annotation (Line(
      points={{-10,-50.4},{-4,-50.4},{-4,-50},{2,-50}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve.outlet, massFlowSource_XRG1.steam_a)     annotation (Line(
      points={{22,-50},{40,-50}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(injector.eye, quadruple.eye) annotation (Line(
      points={{-10,-53.6},{-10,-69},{-8,-69}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(ramp1.y, massFlowSource_XRG4.m_flow) annotation (Line(
      points={{-79,-44},{-76,-44},{-76,30},{-64,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp3.y,massFlowSource_XRG5. h) annotation (Line(
      points={{77,-84},{69,-84},{69,24},{60,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y,massFlowSource_XRG5. p) annotation (Line(
      points={{77,-44},{64,-44},{64,30},{60,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, injector1.opening) annotation (Line(
      points={{-79,-84},{-70,-84},{-70,-10},{-28,-10},{-28,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_XRG4.steam_a, injector1.MainInlet)
    annotation (Line(
      points={{-42,24},{-36,24},{-36,23.6},{-30,23.6}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_XRG3.steam_a, injector1.SprayInlet)
    annotation (Line(
      points={{40,-10},{-22,-10},{-22,14}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(injector1.outlet1, valve1.inlet) annotation (Line(
      points={{-10,23.6},{-4,23.6},{-4,24},{4,24}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve1.outlet, massFlowSource_XRG5.steam_a) annotation (Line(
      points={{24,24},{40,24}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(injector1.eye, quadruple1.eye) annotation (Line(
      points={{-10,20.4},{-10,5},{-8,5}},
      color={190,190,190},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                         graphics={
                                Text(
          extent={{-98,86},{102,46}},
          lineColor={0,128,0},
          textString="_______________________________________________________________________
PURPOSE:
Shows the application of aspray injector and applies a number of ramps in the boundary 
conditions.
_______________________________________________________________________
LOOK AT:
Look at the summary variables of the different subcomponents of the system.
_______________________________________________________________________
",        fontSize=10,
          horizontalAlignment=TextAlignment.Left), Text(
          extent={{-98,100},{66,88}},
          lineColor={0,128,0},
          textString="Tested 01. Mar. 2013 //FG ",
          horizontalAlignment=TextAlignment.Left)}),
    experiment(StopTime=3000),
    __Dymola_experimentSetupOutput);
end Test_SprayInjector;
