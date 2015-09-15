within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT;
model CharLine_L4 "Medium independet || Characteristic Line"
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
  parameter Real PL_alpha[:,2] = {{0,0.2},{0.5,0.6},{0.7,0.72},{1,1}} "Correction factor for heat transfer in part load"
                                                       annotation(Dialog(group="Heat Transfer"));

  Modelica.SIunits.MassFlowRate m_flow[iCom.N_cv] "Mass flow rate";
  Modelica.SIunits.CoefficientOfHeatTransfer alpha[iCom.N_cv] annotation(HideResult=false);

protected
  Real alpha_corr_u[iCom.N_cv];
  Integer tableID;
  parameter Modelica.Blocks.Types.Smoothness smoothness= Modelica.Blocks.Types.Smoothness.LinearSegments "smoothness of table interpolation"
  annotation(Dialog(group="table data interpretation"));

 function tableInit "Initialize 1-dim. table defined by matrix (for details see: Modelica/Resources/C-Sources/ModelicaTables.h)"
    input String tableName;
    input String fileName;
    input Real table[ :, :];
    input Modelica.Blocks.Types.Smoothness smoothness;
    output Integer tableID;
  external "C" tableID=  ModelicaTables_CombiTable1D_init(
                 tableName, fileName, table, size(table, 1), size(table, 2),
                 smoothness);
    annotation(Library="ModelicaExternalC");
 end tableInit;

 function tableIpo "Interpolate 1-dim. table defined by matrix (for details see: Modelica/Resources/C-Sources/ModelicaTables.h)"
    input Integer tableID;
    input Integer icol;
    input Real u;
    output Real value;
  external "C" value =
                     ModelicaTables_CombiTable1D_interpolate(tableID, icol, u);
    annotation(Library="ModelicaExternalC");
 end tableIpo;

equation
  T_mean = iCom.T;
  heat.Q_flow = alpha.*A_heat.*(heat.T-T_mean);

  for i in 1:iCom.N_cv loop
    alpha_corr_u[i]=noEvent(max(1e-3,abs(m_flow[i]))/iCom.m_flow_nom);
    alpha[i] = tableIpo(tableID, 2, alpha_corr_u[i])*alpha_nom;
  end for;

    when initial() then
       tableID=tableInit("NoName","NoName", PL_alpha, smoothness);
     end when;

  annotation (Diagram(graphics));
end CharLine_L4;
