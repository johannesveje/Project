within ClaRa.Basics.Records;
record IComGas_L4 "Basic internal communication record for arrays of flue gas cells"
  extends ClaRa.Basics.Icons.IComIcon;
  import SI = ClaRa.Basics.Units;

//____Discretisation scheme______________________________________________________
  parameter Integer N_cv=10 "|Discretisation|Number of finite volumes";
  parameter Units.Length
                      dx[N_cv] "|Discretisation|Discretisation scheme";
  parameter Units.Length
                      dxFM[N_cv+1] "|Discretisation|Length of flow model volume elements";

//____Parameters for Geometry___________________________________________________________
  parameter Units.Length L "|Geometry||Length of tube";
  final parameter Integer Nt=1 "|Geometry||Number Of parallel pipes";

//   parameter Integer N_cv= 2 "|Geometry||Number of Zones";
//   parameter SI.Volume volume_tot "|Geometry||System volume";
//   parameter SI.Length Height "|Geometry||Height of system";
//   SI.Area A_heat[N_cv] "|Geometry||Area for heat transfer";
//   parameter SI.Area A_cross "|Geometry||Cross section for mass flow";
     parameter Units.Area
                       A_crossFM[N_cv+1] "|Geometry||Cross section for mass flow";

    parameter SI.Length d_hyd "|Geometry||Hydraulic diameter";

//   parameter SI.Area A_hor "|Geometry||Horizontal cross section";
//   parameter Real shape[:,2] = [0,1;1,1]
//     "|Geometry||Shape factor, i.e. A_horitontal=A_hor*interp(shape, relLevel)";
//   parameter SI.Length z_in "|Geometry||Position of inlet";
//   parameter SI.Length z_out "|Geometry||Position of outlet";

//____Initialisation______________________________________________________
 parameter Modelica.SIunits.Pressure p_start[N_cv] "|Initialisation||Initial pressure";

//____Variables for system description__________________________________________________
  input Units.Pressure
                    dp "System pressure" annotation(Dialog(tab="System"));
//   input SI.Pressure p "System pressure" annotation(Dialog(tab="System"));
//   input SI.EnthalpyMassSpecific h[N_cv] "System specific enthalpy"      annotation(Dialog(tab="System"));
   input SI.Temperature T[N_cv] "System temperature" annotation(Dialog(tab="System"));
//   input SI.Mass mass[N_cv] "System mass" annotation(Dialog(tab="System"));
//   SI.Enthalpy H[N_cv] = h.*mass "|System||System enthalpy";
   input SI.DensityMassSpecific d[N_cv] "System density"
                                                        annotation(Dialog(tab="System"));
   input SI.HeatCapacityMassSpecific cp[N_cv] "System specific heat capcity"    annotation(Dialog(tab="System"));
   input SI.DynamicViscosity eta[N_cv] "System dynamic viscosity" annotation(Dialog(tab="System"));
   input SI.ThermalConductivity lambda[N_cv] "System thermal conductivity"   annotation(Dialog(tab="System"));
   input SI.MassFlowRate m_flow[N_cv] "Mean massflow inside cells"   annotation(Dialog(tab="System"));
//   input SI.Volume volume[N_cv] "|Geometry||System volume";
//   input SI.HeatFlowRate Q_flow[N_cv] "Heat flow rate"annotation(Dialog(tab="System"));
//
// //____Inlet___________________________________________________________________________
//   input SI.EnthalpyMassSpecific h_in "Inlet specific enthalpy" annotation(Dialog(tab="Inlet"));
//   input SI.Pressure p_in "Inlet pressure" annotation(Dialog(tab="Inlet"));
   input SI.Temperature T_in[N_cv] "Inlet temperature" annotation(Dialog(tab="Inlet"));
//   input SI.MassFlowRate m_flow_in[N_cv] "Inlet massflow" annotation(Dialog(tab="Inlet"));
//   input SI.HeatCapacityMassSpecific cp_in "Inlet specific heat capcity"annotation(Dialog(tab="Inlet"));
//
// //____Outlet___________________________________________________________________________
//   input SI.EnthalpyMassSpecific h_out "Outlet specific enthalpy" annotation(Dialog(tab="Outlet"));
//   input SI.Pressure p_out "Outlet pressure" annotation(Dialog(tab="Outlet"));
   input SI.Temperature T_out[N_cv] "Outlet temperature" annotation(Dialog(tab="Outlet"));
//   input SI.MassFlowRate m_flow_out[N_cv] "Outlet massflow" annotation(Dialog(tab="Outlet"));
//   input SI.HeatCapacityMassSpecific cp_out "Outlet specific heat capcity" annotation(Dialog(tab="Outlet"));
//
// //_____Nominal___________________________________________________________________________
//   parameter SI.EnthalpyMassSpecific h_nom "|Nominal||Outlet specific enthalpy";
//   parameter SI.Pressure p_nom "|Nominal||Outlet pressure";
//     parameter Modelica.SIunits.Temperature T_nom
//     "|Nominal||Nominal temperature";
//   parameter SI.DynamicViscosity eta_nom "|Nominal|| Nominal dynamic viscosity";
//   parameter SI.ThermalConductivity lambda_nom
//     "|Nominal|| Nominal thermal conductivity";
//   parameter SI.HeatCapacityMassSpecific cp_nom
//     "|Nominal|| Nominal specific heat capacity";
   parameter SI.DensityMassSpecific d_nom[N_cv] "|Nominal|| Nominal density";
   parameter Units.MassFlowRate
                             m_flow_nom "|Nominal|| Nominal mass flow";

   parameter Units.Pressure dp_nom "|Nominal|| Nominal pressure loss";
//
// annotation (   defaultComponentName="iCom",
//     defaultComponentPrefixes="inner");
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end IComGas_L4;
