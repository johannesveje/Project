within ClaRa.Basics;
package Constants 
//___________________________________________________________________________//
// Package of the ClaRa library, version: 1.0.0                          //
// Models of the ClaRa library are tested under DYMOLA v2013 FD01.           //
// It is planned to support alternative Simulators like SimulationX in the   //
// future                                                                    //
//___________________________________________________________________________//
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright © 2013-2015, DYNCAP research team.                                   //
//___________________________________________________________________________//
// This Modelica package is free software and the use is completely at your  //
// own risk; it can be redistributed and/or modified under the terms of the  //
// Modelica License 2. For license conditions (including the disclaimer of   //
// warranty) see Modelica.UsersGuide.ModelicaLicense2 or visit               //
// http://www.modelica.org/licenses/ModelicaLicense2                         //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//


  extends ClaRa.Basics.Icons.PackageIcons.Basics80;

import ClaRa.Basics.Units;

//__________________/ chemical Constants \_______________________

// Molar Mass of Carbon
final constant Modelica.SIunits.MolarMass M_C = 12.010701e-3;
// Molar Mass of Hydrogen
final constant Modelica.SIunits.MolarMass M_H = 1.00794e-3;
// Molar Mass of Oxygen
final constant Modelica.SIunits.MolarMass M_O =  15.99940e-3;
// Molar Mass of Oxygen Molecule
final constant Modelica.SIunits.MolarMass M_O2 =  32.0e-3;
// Molar Mass of Nitrogen
final constant Modelica.SIunits.MolarMass M_N = 14.00670e-3;
// Molar Mass of Sulphur
final constant Modelica.SIunits.MolarMass M_S =  32.06500e-3;
// Molar Mass of ASH (first estimation)
final constant Modelica.SIunits.MolarMass M_Ash =  60e-3;
// Molar Mass of Water
final constant Modelica.SIunits.MolarMass M_H2O =  18.01528e-3;

end Constants;
