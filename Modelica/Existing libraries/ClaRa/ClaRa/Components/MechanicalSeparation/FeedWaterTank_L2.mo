within ClaRa.Components.MechanicalSeparation;
model FeedWaterTank_L2 "Feedwater tank : mixed volume approach | level-dependent phase separation"
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

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");
  replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.ShellType_L2 "Pressure loss model"
                          annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  parameter Modelica.SIunits.SpecificEnthalpy h_start=xi_start*(TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(medium, p_start) - TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_start)) + TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_start) "Start value of sytsem specific enthalpy"
                                                                                              annotation (Dialog(tab="Initialisation"));
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "|Phase Separation|Numerical Robustness|Smoothness of table interpolation for calculation of filling level";

  parameter Modelica.SIunits.Length z_in=1 "Height of inlet ports" annotation(Dialog(group="Geometry"));
  parameter Modelica.SIunits.Length z_out=1 "Height of outlet ports"  annotation(Dialog(group="Geometry"));

protected
 record Outline
   extends ClaRa.Basics.Icons.RecordIcon;
   Basics.Units.Length level_abs "Absolute filling level";
   Real level_rel "relative filling level";
 end Outline;

 record Summary
   extends ClaRa.Basics.Icons.RecordIcon;
   Outline outline;
   //ClaRa.Basics.Records.FluidVLE_L2 fluid;
   ClaRa.Basics.Records.FlangeVLE condensate;
   ClaRa.Basics.Records.FlangeVLE tapping;
   ClaRa.Basics.Records.FlangeVLE feedwater;
 end Summary;
public
  Summary summary(
    outline(level_abs=volume.phaseBorder.level_abs, level_rel=volume.phaseBorder.level_rel),
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
      s=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
          heatingSteam.p,
          actualStream(heatingSteam.h_outflow),
          actualStream(heatingSteam.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      steamQuality=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
          heatingSteam.p,
          actualStream(heatingSteam.h_outflow),
          actualStream(heatingSteam.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      H_flow=heatingSteam.m_flow*actualStream(heatingSteam.h_outflow),
      rho=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
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
      s=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
          condensate.p,
          actualStream(condensate.h_outflow),
          actualStream(condensate.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      steamQuality=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
          condensate.p,
          actualStream(condensate.h_outflow),
          actualStream(condensate.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      H_flow=condensate.m_flow*actualStream(condensate.h_outflow),
      rho=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
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
      s=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
          outlet.p,
          actualStream(outlet.h_outflow),
          actualStream(outlet.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      steamQuality=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
          outlet.p,
          actualStream(outlet.h_outflow),
          actualStream(outlet.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      H_flow=outlet.m_flow*actualStream(outlet.h_outflow),
      rho=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
          outlet.p,
          actualStream(outlet.h_outflow),
          actualStream(outlet.xi_outflow),
          volume.fluidIn.vleFluidPointer))) annotation (Placement(transformation(extent={{-60,-60},{-80,-40}})));

  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 volume(
    medium=medium,
    redeclare model PressureLoss = PressureLoss,
    useHomotopy=useHomotopy,
    m_flow_nom=m_flow_cond_nom + m_flow_heat_nom,
    p_nom=p_nom,
    h_nom=h_nom,
    p_start=p_start,
    initType=initType,
    h_start=h_start,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2,
    showExpertSummary=showExpertSummary,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowCylinder (
        z_in={z_in},
        z_out={z_out},
        orientation=orientation,
        diameter=diameter,
        length=length),
    final heatSurfaceAlloc=1,
    redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallySeparated (
         level_rel_start=
                 level_rel_start,
                          smoothness=smoothness))
    annotation (Placement(transformation(extent={{0,-30},{-20,-10}})));

equation
//  Vl = max(0.000001,((1-volume.fluidOut.q)*volume.M))/noEvent(max(volume.fluidOut.VLE.d_l,
//                                                                                 volume.fluidOut.d));

  eye_int.m_flow=-outlet.m_flow;
  eye_int.T=volume.fluidOut.T-273.15;
  eye_int.s=volume.fluidOut.s/1000;
  eye_int.h=volume.fluidOut.h/1000;
  eye_int.p=volume.fluidOut.p/100000;

  connect(volume.inlet, condensate) annotation (Line(
      points={{0,-20},{102,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heatingSteam, volume.inlet) annotation (Line(
      points={{-200,80},{-200,30},{0,30},{0,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.outlet, outlet) annotation (Line(
      points={{-20,-20},{-98,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-300,
            -100},{300,100}}),
                   graphics),          Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-60},{100,80}}),
                                               graphics));
end FeedWaterTank_L2;
