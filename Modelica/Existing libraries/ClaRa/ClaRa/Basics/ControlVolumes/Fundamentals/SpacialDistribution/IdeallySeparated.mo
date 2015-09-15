within ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution;
model IdeallySeparated "Separation | Ideal | outlet states depending on filling Level | All geometries"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdealPhases;
  extends ClaRa.Basics.Icons.IdealSeparation;

  import ClaRa.Basics.Functions.Stepsmoother;
/////// The following block is be conform to MSL 3.2 and will be removed in the future////////////////
  import ClaRa.Basics.Functions.TableInterpolation.tableInit;
  import ClaRa.Basics.Functions.TableInterpolation.tableIpo;
//////////////////////////////////////////////////////////////////////////////////////////////////////

/////// The following block will be conform to MSL 3.2.1 and will be activated in the future//////////
//   import ClaRa.Basics.Functions.TableInterpolation.getTableValueNoDer;
//   import ClaRa.Basics.Functions.TableInterpolation.getTableValue;
//////////////////////////////////////////////////////////////////////////////////////////////////////

  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;

  outer ClaRa.Basics.Choices.Init initType;
//  outer SI.Pressure p;
  outer parameter Boolean useHomotopy;

  parameter SI.Length radius_flange= 0.05 "Flange radius";
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "|Expert Settings|Shape interpretation|Smoothness of table interpolation";

    constant SI.Length level_abs_min=1e-6;
  final parameter SI.Length z_max_in = min(geo.z_in[1]+radius_flange,  geo.height_fill) "Upper edge of inlet flange";
  final parameter SI.Length z_min_in = max(1e-3,geo.z_in[1] -radius_flange) "Lower edge of inlet flange";
  final parameter SI.Length z_max_out = min(geo.z_out[1]+radius_flange, geo.height_fill) "Upper edge of outlet flange";
  final parameter SI.Length z_min_out = max(1e-3,geo.z_out[1]-radius_flange) "Lower edge of outlet flange";

/////// The following block will be conform to MSL 3.2.1 and will be activated in the future///////////
//  final parameter Modelica.Blocks.Types.ExternalCombiTable1D tableID=
//       Modelica.Blocks.Types.ExternalCombiTable1D("NoName", "NoName", iCom.shape, {2}, smoothness)
//     "External table object";
//////////////////////////////////////////////////////////////////////////////////////////////////////

/////// The following block is be conform to MSL 3.2 and will be removed in the future////////////////
  final parameter Integer tableID=tableInit("NoName", "NoName", geo.shape, smoothness) "External table object";
//////////////////////////////////////////////////////////////////////////////////////////////////////

  SI.Volume volume_liq "Liquid volume";
  SI.Area A_hor_act "Actual horizontal surface size";
protected
  SI.EnthalpyMassSpecific h_dew;
  SI.EnthalpyMassSpecific h_bubble;
  SI.DensityMassSpecific rho_dew;
  SI.DensityMassSpecific rho_bubble;
  SI.DensityMassSpecific rho_bulk;
  SI.MassFraction steamQuality_bulk;
equation

//_________________________Required Media Data__________________________________
  h_dew = TILMedia.VLEFluidObjectFunctions.dewSpecificEnthalpy_pxi(iCom.p_bulk, iCom.xi_bulk, iCom.fluidPointer_bulk);
  h_bubble = TILMedia.VLEFluidObjectFunctions.bubbleSpecificEnthalpy_pxi(iCom.p_bulk, iCom.xi_bulk, iCom.fluidPointer_bulk);
  rho_dew = TILMedia.VLEFluidObjectFunctions.dewDensity_pxi(iCom.p_bulk, iCom.xi_bulk, iCom.fluidPointer_bulk);
  rho_bubble = TILMedia.VLEFluidObjectFunctions.bubbleDensity_pxi(iCom.p_bulk, iCom.xi_bulk, iCom.fluidPointer_bulk);
  rho_bulk = TILMedia.VLEFluidObjectFunctions.density_phxi(iCom.p_bulk, iCom.h_bulk, iCom.xi_bulk, iCom.fluidPointer_bulk);
  steamQuality_bulk = TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(iCom.p_bulk, iCom.h_bulk, iCom.xi_bulk, iCom.fluidPointer_bulk);
//_________________________Calculation of the Level______________________________
/////// The following block will be conform to MSL 3.2.1 and will be activated in the future///////////
//   if smoothness == Modelica.Blocks.Types.Smoothness.ConstantSegments then
//     level_abs=min(iCom.FillHeight, max(level_abs_min, volume_liq/(iCom.A_hor*getTableValueNoDer(tableID, 1, level_rel, 1))));
//   else
//     level_abs=min(iCom.FillHeight, max(level_abs_min, volume_liq/(iCom.A_hor*getTableValue(tableID, 1, level_rel, 1))));
//   end if;
//////////////////////////////////////////////////////////////////////////////////////////////////////

/////// The following block is be conform to MSL 3.2 and will be removed in the future////////////////
    level_abs=min(geo.height_fill, max(level_abs_min, volume_liq/(A_hor_act)));
//////////////////////////////////////////////////////////////////////////////////////////////////////

  volume_liq =   max(1e-6, ((1 - steamQuality_bulk)*iCom.mass))/noEvent(max(rho_bubble, rho_bulk));
  A_hor_act = geo.A_hor*tableIpo(tableID, 2, level_rel);
//   level_abs=min(geo.height_fill, max(level_abs_min, volume_liq/(geo.A_hor*noEvent(Modelica.Math.tempInterpol1(level_rel, geo.shape, 2)))));
  level_rel = level_abs/geo.height_fill;

//_________________________Calculation of the outflowing enthalpy _________________
  h_outflow=if useHomotopy then homotopy(Stepsmoother(z_min_out, z_max_out, level_abs)*noEvent(max(iCom.h_bulk, h_dew))+ (1-Stepsmoother(z_min_out, z_max_out, level_abs))*noEvent(min(h_bubble, iCom.h_bulk)), iCom.h_bulk)
 else
     Stepsmoother(z_min_out, z_max_out, level_abs)*noEvent(max(iCom.h_bulk, h_dew))+ (1-Stepsmoother(z_min_out, z_max_out, level_abs))*noEvent(min(h_bubble, iCom.h_bulk));

  h_inflow=if useHomotopy then homotopy(Stepsmoother(z_min_in, z_max_in, level_abs)*noEvent(max(iCom.h_bulk, h_dew))+ (1-Stepsmoother(z_min_in, z_max_in, level_abs))*noEvent(min(h_bubble, iCom.h_bulk)),iCom.h_bulk)
 else Stepsmoother(z_min_in, z_max_in, level_abs)*noEvent(max(iCom.h_bulk, h_dew))+ (1-Stepsmoother(z_min_in, z_max_in, level_abs))*noEvent(min(h_bubble, iCom.h_bulk));

//__________________Calculation of the geostatic pressure differences_______________
  Delta_p_geo_in =(level_abs - geo.z_in[1])*Modelica.Constants.g_n*noEvent(if level_abs > geo.z_in[1] then rho_bubble else rho_dew);
  Delta_p_geo_out =(level_abs - geo.z_out[1])*Modelica.Constants.g_n*noEvent(if level_abs > geo.z_out[1] then rho_bubble else rho_dew);

initial equation
  //more initialisation options may be used in the applying class
  if initType == ClaRa.Basics.Choices.Init.steadyDensity then
//    der(y)=0;
    level_rel=level_rel_start;
  elseif initType == ClaRa.Basics.Choices.Init.steadyDensityPressure then
    //der(y)=0;
    level_rel=level_rel_start;
    der(iCom.p_bulk)=0;
  end if;

  annotation (Icon(graphics));
end IdeallySeparated;
