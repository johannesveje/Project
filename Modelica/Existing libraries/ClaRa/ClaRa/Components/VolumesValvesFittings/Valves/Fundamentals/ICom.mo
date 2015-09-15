within ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals;
record ICom
  extends ClaRa.Basics.Icons.IComIcon;
  import SI = ClaRa.Basics.Units;

//  input SI.Pressure Delta_p "Pressure difference p_in - p_out" annotation(Dialog);
  input SI.Pressure p_in "Inlet pressure" annotation(Dialog);
  input SI.Pressure p_out "Outlet pressure" annotation(Dialog);
  input Real opening_ "Opening of the valve (p.u.)" annotation(Dialog);
  input SI.DensityMassSpecific rho_in "Inlet density" annotation(Dialog);
  input Real gamma_in "Heat capacity ratio at inlet"   annotation(Dialog);
  input Real gamma_out "Heat capacity ratio at outlet"    annotation(Dialog);
  input Real opening_leak_ annotation(Dialog);
end ICom;
