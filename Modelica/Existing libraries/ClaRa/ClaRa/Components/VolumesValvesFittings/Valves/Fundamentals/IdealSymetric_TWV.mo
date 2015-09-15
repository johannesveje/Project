within ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals;
model IdealSymetric_TWV "| No Pressure Dependency | Opening Characteristics | Symetrical |"
  extends ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Basic_TWV;
  extends ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.TWV_L2;

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
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "|Expert Settings|Shape interpretation|Smoothness of table interpolation";

  SI.MassFlowRate m_flow_1 "Mass flow through straight flange";
  SI.MassFlowRate m_flow_2 "Mass flow through shunt flange";
  SI.Pressure p_out2;

//  SI.PressureDifference Delta_p "Pressure difference p_in - p_out";
//  Real gamma;

equation
  m_flow_1 = iCom.m_flow_in*aperture_;
  m_flow_2 = iCom.m_flow_in*(1-aperture_);
  p_out2 = iCom.p_in;

end IdealSymetric_TWV;
