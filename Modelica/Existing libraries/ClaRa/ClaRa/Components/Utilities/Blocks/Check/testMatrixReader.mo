within ClaRa.Components.Utilities.Blocks.Check;
model testMatrixReader "Two ways how to read a matrix from file"
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

  import DataFiles;
 parameter Real  A[:,:]=readMatrix("abcd_.mat", "Aest", 13,13);
  ClaRa.Components.Utilities.Blocks.ReadMatrixFromFile readMATRIX(fileName=
        "ABCD.dss", matrixName="A")
    annotation (Placement(transformation(extent={{-24,-16},{-4,4}})));
equation

end testMatrixReader;
