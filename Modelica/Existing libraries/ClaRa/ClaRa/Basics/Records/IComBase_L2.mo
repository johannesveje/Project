within ClaRa.Basics.Records;
record IComBase_L2 "Basic internal communication record"
  extends ClaRa.Basics.Icons.IComIcon;
  import SI = ClaRa.Basics.Units;

//____Inlet______________________________________________________________________________
  input SI.Pressure p_in "Inlet pressure" annotation(Dialog(tab="Inlet"));
  input SI.Temperature T_in "Inlet Temperature" annotation(Dialog(tab="Inlet"));
  input SI.MassFlowRate  m_flow_in "Inlet mass flow" annotation(Dialog(tab="Inlet"));

//____Outlet_____________________________________________________________________________
  input SI.Pressure p_out "Outlet pressure" annotation(Dialog(tab="Outlet"));
  input SI.Temperature T_out "Outlet Temperature"     annotation(Dialog(tab="Outlet"));
  input SI.MassFlowRate  m_flow_out "Outlet mass flow" annotation(Dialog(tab="Outlet"));

//_____Bulk______________________________________________________________________________
  input SI.Temperature T_bulk "Bulk Temperature" annotation(Dialog(tab="Bulk"));
  input SI.Pressure p_bulk "Outlet pressure" annotation(Dialog(tab="Bulk"));

//_____Nominal___________________________________________________________________________
  parameter input SI.Pressure  p_nom=1e5 "Nominal pressure" annotation(Dialog(tab="Nominal"));
  parameter input SI.MassFlowRate  m_flow_nom=10 "Nominal mass flow" annotation(Dialog(tab="Nominal"));
  parameter input SI.EnthalpyMassSpecific  h_nom=1e4 "Nominal enthalpy" annotation(Dialog(tab="Nominal"));
  parameter input SI.EnthalpyMassSpecific  xi_nom[:]= {1} "Nominal mass fraction" annotation(Dialog(tab="Nominal"));
annotation (   defaultComponentName="iCom",
    defaultComponentPrefixes="inner",
    Icon(graphics));
end IComBase_L2;
