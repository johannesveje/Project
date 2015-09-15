within ClaRa.Visualisation.Check;
model TestDynamicDiagram
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
  Modelica.Blocks.Sources.Sine sine(          amplitude=1, freqHz=0.1)
    annotation (Placement(transformation(extent={{-82,-12},{-62,8}})));
  Scope scope(
    y_min=-1,
    t_simulation=10,
    showInterface=false,
    inputVar=sine.y,
    t_sample=0.01,
    Unit="Sine") annotation (Placement(transformation(extent={{10,-26},{56,20}})));
  annotation (Diagram(graphics));
end TestDynamicDiagram;
