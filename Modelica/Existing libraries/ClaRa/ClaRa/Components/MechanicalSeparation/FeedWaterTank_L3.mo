within ClaRa.Components.MechanicalSeparation;
model FeedWaterTank_L3 "Feedwater tank : separated volume approach | level-dependent phase separation"
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

extends ClaRa.Components.MechanicalSeparation.FeedWaterTank_base;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");
  parameter Modelica.SIunits.Length radius_flange=0.05 "Flange radius" annotation(Dialog(group="Geometry"));
  parameter SI.Time Tau_cond=10 "|Phase Separation|Mass Transfer Between Phases|Time constant of condensation";
  parameter SI.Time tau_evap=Tau_cond*1000 "|Phase Separation|Mass Transfer Between Phases|Time constant of evaporation";
  parameter Real absorbInflow=1 "|Phase Separation|Mass Transfer Between Phases|absorption of incoming mass flow to the zones 1: perfect in the allocated zone, 0: perfect according to steam quality";
  parameter SI.Area A_phaseBorder=volume.geo.A_hor*100 "|Phase Separation|Heat Transfer Between Phases|Heat transfer area at phase border";
  parameter SI.CoefficientOfHeatTransfer alpha_ph=500 "|Phase Separation|Heat Transfer Between Phases|HTC of the phase border";
//  parameter Real expHT_phases=0 "|Phase Separation|Heat Transfer Between Phases|Exponent for volume dependency on inter phase HT";
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "|Phase Separation|Numerical Robustness|Smoothness of table interpolation for calculation of filling level";

  parameter Modelica.SIunits.Length z_in=1 "Height of inlet ports" annotation(Dialog(group="Geometry"));
  parameter Modelica.SIunits.Length z_out=1 "Height of outlet ports"  annotation(Dialog(group="Geometry"));
  parameter Modelica.SIunits.SpecificEnthalpy h_liq_start= TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_start) "|Initialisation||Initial liquid specific enthalpy";
  parameter Modelica.SIunits.SpecificEnthalpy h_vap_start= TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(medium, p_start) "|Initialisation||Initial vapour specific enthalpy";
  replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L3
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.ShellType_L3 "Pressure loss model"
                          annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);

 record Outline
   extends ClaRa.Basics.Icons.RecordIcon;
   Basics.Units.Length
             level_abs;
   Real level_rel;
 end Outline;

 record Wall
   extends ClaRa.Basics.Icons.RecordIcon;
   Basics.Units.Temperature
                  T_wall[3];
 end Wall;

 record Summary
  extends ClaRa.Basics.Icons.RecordIcon;
  Outline outline;
  Wall wall;
   ClaRa.Basics.Records.FlangeVLE condensate;
   ClaRa.Basics.Records.FlangeVLE tapping;
   ClaRa.Basics.Records.FlangeVLE feedwater;
 end Summary;

  Summary summary(
    outline(level_abs=volume.phaseBorder.level_abs, level_rel=volume.phaseBorder.level_rel),
    wall(T_wall=wall.T),
    tapping(
      showExpertSummary=showExpertSummary,
      m_flow=heatingSteam.m_flow,
      p=heatingSteam.p,
      h=actualStream(heatingSteam.h_outflow),
      T=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
          heatingSteam.p,
          actualStream(heatingSteam.h_outflow),
          actualStream(heatingSteam.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      s=TILMedia.VLEFluidObjectFunctions.specificEntropy_phxi(
          heatingSteam.p,
          actualStream(heatingSteam.h_outflow),
          actualStream(heatingSteam.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      steamQuality=TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
          heatingSteam.p,
          actualStream(heatingSteam.h_outflow),
          actualStream(heatingSteam.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      H_flow=heatingSteam.m_flow*actualStream(heatingSteam.h_outflow),
      rho=TILMedia.VLEFluidObjectFunctions.density_phxi(
          heatingSteam.p,
          actualStream(heatingSteam.h_outflow),
          actualStream(heatingSteam.xi_outflow),
          volume.fluidIn.vleFluidPointer)),
    condensate(
      showExpertSummary=showExpertSummary,
      m_flow=condensate.m_flow,
      p=condensate.p,
      h=actualStream(condensate.h_outflow),
      T=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
          condensate.p,
          actualStream(condensate.h_outflow),
          actualStream(condensate.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      s=TILMedia.VLEFluidObjectFunctions.specificEntropy_phxi(
          condensate.p,
          actualStream(condensate.h_outflow),
          actualStream(condensate.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      steamQuality=TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
          condensate.p,
          actualStream(condensate.h_outflow),
          actualStream(condensate.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      H_flow=condensate.m_flow*actualStream(condensate.h_outflow),
      rho=TILMedia.VLEFluidObjectFunctions.density_phxi(
          condensate.p,
          actualStream(condensate.h_outflow),
          actualStream(condensate.xi_outflow),
          volume.fluidIn.vleFluidPointer)),
    feedwater(
      showExpertSummary=showExpertSummary,
      m_flow=outlet.m_flow,
      p=outlet.p,
      h=actualStream(outlet.h_outflow),
      T=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
          outlet.p,
          actualStream(outlet.h_outflow),
          actualStream(outlet.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      s=TILMedia.VLEFluidObjectFunctions.specificEntropy_phxi(
          outlet.p,
          actualStream(outlet.h_outflow),
          actualStream(outlet.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      steamQuality=TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
          outlet.p,
          actualStream(outlet.h_outflow),
          actualStream(outlet.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      H_flow=outlet.m_flow*actualStream(outlet.h_outflow),
      rho=TILMedia.VLEFluidObjectFunctions.density_phxi(
          outlet.p,
          actualStream(outlet.h_outflow),
          actualStream(outlet.xi_outflow),
          volume.fluidIn.vleFluidPointer))) annotation (Placement(transformation(extent={{-60,-60},{-80,-40}})));
  Basics.ControlVolumes.FluidVolumes.VolumeVLE_3_TwoZones volume(
    medium=medium,
    redeclare model PressureLoss = PressureLoss,
    useHomotopy=useHomotopy,
    m_flow_nom=m_flow_cond_nom + m_flow_heat_nom,
    p_nom=p_nom,
    p_start=p_start,
    initType=initType,
    level_rel_start=level_rel_start,
    Tau_cond=Tau_cond,
    showExpertSummary=showExpertSummary,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (             alpha_nom=
                                                                                              {3000,3000}),
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowCylinder (
        orientation=orientation,
        diameter=diameter,
        length=length,
        z_in={z_in},
        z_out={z_out}),
    h_liq_start=h_liq_start,
    h_vap_start=h_vap_start,
    Tau_evap=tau_evap,
    alpha_ph=alpha_ph,
    A_heat_ph=A_phaseBorder,
    redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealSeparated (
        level_rel_start=level_rel_start,
        smoothness=smoothness,
        radius_flange=
                 radius_flange,
        absorbInflow=absorbInflow)) annotation (Placement(transformation(extent={{12,-30},{-8,-10}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.ThickWall_L4 wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    sizefunc=+1,
    N_tubes=1,
    initChoice=ClaRa.Basics.Choices.Init.steadyState,
    diameter_o=diameter/2*1.01,
    diameter_i=diameter/2,
    length=length,
    N_rad=3) annotation (Placement(transformation(extent={{-40,4},{-20,24}})));

equation
  eye_int.m_flow=-outlet.m_flow;
  eye_int.T=volume.summary.outlet.T-273.15;
  eye_int.s=volume.fluidOut.s/1000;
  eye_int.h=volume.summary.outlet.h/1000;
  eye_int.p=volume.summary.outlet.p/100000;

  connect(volume.inlet, condensate) annotation (Line(
      points={{12,-20},{102,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heatingSteam, volume.inlet) annotation (Line(
      points={{-200,80},{-200,20},{12,20},{12,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.outlet, outlet) annotation (Line(
      points={{-8,-20},{-98,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wall.innerPhase, volume.heat) annotation (Line(
      points={{-30.2,4.4},{-16,4.4},{-16,-10},{2,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-300,
            -100},{300,100}}),
                   graphics),          Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-60},{100,80}}),
                                               graphics));
end FeedWaterTank_L3;
