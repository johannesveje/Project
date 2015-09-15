within ClaRa.Components.TurboMachines.Turbines.Check;
model TestSTodolaTurbine_XRG
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
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 turbine(
    m_flow_nom=419,
    rho_nom=84,
    showExpertSummary=true,
    showData=true) annotation (Placement(transformation(extent={{2,-30},{22,-10}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSource(
    h_const=3279e3,
    variable_p=true,
    variable_h=true,
    p_const=30000000) annotation (Placement(transformation(extent={{-56,-20},{-36,0}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink(
    p_const(displayUnit="Pa") = 5000,
    variable_p=true,
    variable_h=true) annotation (Placement(transformation(extent={{78,-40},{58,-20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-100e5,
    duration=10,
    offset=300e5,
    startTime=10)
    annotation (Placement(transformation(extent={{-96,20},{-76,40}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=10,
    startTime=10,
    height=0,
    offset=3500e3)
    annotation (Placement(transformation(extent={{-96,-40},{-76,-20}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=10,
    startTime=10,
    height=0,
    offset=5000)
    annotation (Placement(transformation(extent={{0,26},{20,46}})));
  Modelica.Blocks.Sources.Ramp ramp3(
    duration=10,
    startTime=10,
    height=0,
    offset=1e5)
    annotation (Placement(transformation(extent={{62,-78},{82,-58}})));
  inner SimCenter simCenter(steamCycleAllowFlowReversal=false, redeclare replaceable TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1) annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Visualisation.Quadruple quadruple
    annotation (Placement(transformation(extent={{38,-12},{58,-2}})));
equation
  connect(ramp.y, massFlowSource.p) annotation (Line(
      points={{-75,30},{-70,30},{-70,-4},{-56,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, massFlowSource.h) annotation (Line(
      points={{-75,-30},{-75,-10},{-56,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, pressureSink.p) annotation (Line(
      points={{21,36},{88,36},{88,-24},{78,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp3.y, pressureSink.h) annotation (Line(
      points={{83,-68},{90,-68},{90,-30},{78,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource.steam_a, turbine.inlet) annotation (Line(
      points={{-36,-10},{2,-10},{2,-14}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  connect(turbine.outlet, pressureSink.steam_a) annotation (Line(
      points={{22,-30},{58,-30}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  connect(turbine.eye, quadruple.eye) annotation (Line(
      points={{24,-26},{30,-26},{30,-7},{38,-7}},
      color={190,190,190},
      smooth=Smooth.None));
  annotation (Diagram(graphics={  Text(
          extent={{-96,98},{102,58}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:

______________________________________________________________________________________________
"),                    Text(
          extent={{-114,102},{44,84}},
          lineColor={0,128,0},
          fontSize=31,
          textString="TESTED -- XXXX-YY-ZZ //XX"),Text(
          extent={{-96,76},{70,34}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________________________
Remarks: 
______________________________________________________________________________________________________________
",        fontSize=8),Text(
          extent={{-96,74},{104,56}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
Scenario:  

______________________________________________________________________________________________
")}));
end TestSTodolaTurbine_XRG;
