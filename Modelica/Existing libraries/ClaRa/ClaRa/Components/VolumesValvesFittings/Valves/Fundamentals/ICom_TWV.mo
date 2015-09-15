within ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals;
record ICom_TWV
  extends ClaRa.Basics.Icons.RecordIcon;
  import SI = ClaRa.Basics.Units;

  input SI.MassFlowRate m_flow_in "Inlet mass flow rate" annotation(Dialog);
  input SI.Pressure p_in "Inlet pressure" annotation(Dialog);
  input SI.Pressure p_out1 "Outlet pressure at straight flange" annotation(Dialog);
  input SI.Pressure p_out2 "Outlet pressure at shunt flange" annotation(Dialog);
  input SI.DensityMassSpecific rho_in "Outlet density at straight flange" annotation(Dialog);
  input SI.DensityMassSpecific rho_out1 "Outlet density at straight flange" annotation(Dialog);
  input SI.DensityMassSpecific rho_out2 "Outlet density at shunt flange" annotation(Dialog);
  input Real opening_ "Opening of the valve (p.u.)" annotation(Dialog);

end ICom_TWV;
