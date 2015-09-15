within ClaRa.Visualisation.Check;
model TestStatePoint
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG(
    variable_h=true,
    m_flow_const=0,
    variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-76,-22})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG(p_const=5100000) annotation (Placement(transformation(extent={{14,-42},{-6,-22}})));
  Modelica.Blocks.Sources.Step MassFlowRate(
    height=-0.02,
    startTime=50,
    offset=300)     annotation (Placement(transformation(extent={{-90,12},{-70,
            32}},     rotation=0)));
  Modelica.Blocks.Sources.Step InSpecEnthalpy(
    startTime=1,
    height=300e3,
    offset=3000e3)
                 annotation (Placement(transformation(extent={{-90,50},{-70,70}},
                  rotation=0)));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{70,76},{90,96}})));
  StatePoint_ph statePoint_ph
    annotation (Placement(transformation(extent={{-44,-12},{-36,-4}})));
  StatePoint_phTs statePoint_phTs
    annotation (Placement(transformation(extent={{-24,-12},{-12,2}})));
equation
  connect(InSpecEnthalpy.y,massFlowSource_XRG. h) annotation (Line(
      points={{-69,60},{-66,60},{-66,0},{-76,0},{-76,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(MassFlowRate.y, massFlowSource_XRG.m_flow) annotation (Line(
      points={{-69,22},{-58,22},{-58,-6},{-70,-6},{-70,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_XRG.steam_a, pressureSink_XRG.steam_a) annotation (
      Line(
      points={{-76,-32},{-6,-32}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  connect(statePoint_ph.port, pressureSink_XRG.steam_a) annotation (Line(
      points={{-44,-12},{-44,-32},{-6,-32}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  connect(statePoint_phTs.port, pressureSink_XRG.steam_a) annotation (Line(
      points={{-24,-12},{-24,-32},{-6,-32}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end TestStatePoint;
