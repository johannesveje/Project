within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT;
model NominalPoint_L4 "Medium independet || Nominal HTC with simple m_flow dependency"
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

  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha_nom = 10 "Constant heat transfer coefficient"
                                          annotation(Dialog(group="Heat Transfer"));

  Modelica.SIunits.MassFlowRate m_flow[iCom.N_cv] "Mass flow rate";
  Modelica.SIunits.CoefficientOfHeatTransfer alpha[iCom.N_cv];
equation
  T_mean = iCom.T;
  heat.Q_flow = alpha.*A_heat.*(heat.T-T_mean);
  alpha=if useHomotopy then homotopy(noEvent(alpha_nom*(abs(m_flow)/iCom.m_flow_nom).^0.8), alpha_nom*ones(iCom.N_cv)) else noEvent(alpha_nom*(abs(m_flow)/iCom.m_flow_nom).^0.8);
end NominalPoint_L4;
