within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT;
model Ideal_L4 "Medium independent || Ideal HT"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L4;
    Modelica.SIunits.MassFlowRate m_flow[iCom.N_cv] "Mass flow rate";
equation
  T_mean=  iCom.T;
  heat.T = T_mean;

  annotation (Diagram(graphics));
end Ideal_L4;
