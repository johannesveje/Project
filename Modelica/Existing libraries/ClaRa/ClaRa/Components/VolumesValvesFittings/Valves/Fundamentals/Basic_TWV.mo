within ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals;
partial model Basic_TWV "Basic pressure loss model for three way valves"
  extends ClaRa.Basics.Icons.Delta_p;
  import SI = ClaRa.Basics.Units;

/////// The following block is be conform to MSL 3.2 and will be removed in the future////////////////
  import ClaRa.Basics.Functions.TableInterpolation.tableInit;
  import ClaRa.Basics.Functions.TableInterpolation.tableIpo;
//////////////////////////////////////////////////////////////////////////////////////////////////////

/////// The following block will be conform to MSL 3.2.1 and will be activated in the future//////////
//   import ClaRa.Basics.Functions.TableInterpolation.getTableValueNoDer;
//   import ClaRa.Basics.Functions.TableInterpolation.getTableValue;
//////////////////////////////////////////////////////////////////////////////////////////////////////

  parameter Real CharLineValve_[:, :]=[0, 0; 1, 1] "|Valve Characteristics|Effective apperture as function of valve position in p.u.";
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "|Expert Settings|Numerical Robustness|Smoothness of table interpolation";

  outer ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.ICom_TWV iCom;
//   outer Boolean checkValve;
//   outer Boolean useHomotopy;

  SI.MassFlowRate m_flow_1 "Mass flow through straight flange";
  SI.MassFlowRate m_flow_2 "Mass flow through shunt flange";
  Real aperture_ "Effective apperture";

/////// The following block will be conform to MSL 3.2.1 and will be activated in the future///////////
//   Modelica.Blocks.Types.ExternalCombiTable1D tableID=
//       Modelica.Blocks.Types.ExternalCombiTable1D("NoName", "NoName", iCom.shape, {2}, smoothness)
//     "External table object";
//////////////////////////////////////////////////////////////////////////////////////////////////////

/////// The following block is be conform to MSL 3.2 and will be removed in the future////////////////
protected
  parameter Integer tableID=tableInit("NoName", "NoName", CharLineValve_, smoothness) "External table object";
//////////////////////////////////////////////////////////////////////////////////////////////////////
equation
/////// The following block will be conform to MSL 3.2.1 and will be activated in the future///////////
//   if smoothness == Modelica.Blocks.Types.Smoothness.ConstantSegments then
//     absLevel=min(iCom.FillHeight, max(ymin, iCom.volume[1]/(iCom.A_hor*getTableValueNoDer(tableID, 1, relLevel, 1))));
//   else
//     absLevel=min(iCom.FillHeight, max(ymin, iCom.volume[1]/(iCom.A_hor*getTableValue(tableID, 1, relLevel, 1))));
//   end if;
//////////////////////////////////////////////////////////////////////////////////////////////////////

/////// The following block is be conform to MSL 3.2 and will be removed in the future////////////////
 aperture_ = min(1, max(0, tableIpo(tableID, 2, iCom.opening_)));
//////////////////////////////////////////////////////////////////////////////////////////////////////

end Basic_TWV;
