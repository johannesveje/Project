within ClaRa.Components.MechanicalSeparation;
model FeedWaterTank_L3_advanced "Feedwater tank : separated volume approach | level-dependent phase separation"
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
  parameter Modelica.SIunits.Length radius_flange=0.05 "||Geometry|Flange radius";
  parameter SI.Length z_tapping = 0 "||Geometry|position of tapping flange";
  parameter SI.Length z_condensate= 0.1 "||Geometry|position of condensate flange";
  parameter SI.Length z_aux= 0.1 "||Geometry|position of auxilliary flange";
  parameter SI.Length z_feed = 0 "||Geometry|position of feedwater flange";
  parameter SI.Length z_vent = 0.1 "||Geometry|position of vent flange";

  parameter SI.Time Tau_cond=10 "|Phase Separation|Mass Transfer Between Phases|Time constant of condensation";
  parameter SI.Time Tau_evap=Tau_cond*1000 "|Phase Separation|Mass Transfer Between Phases|Time constant of evaporation";
  parameter Real absorbInflow=1 "|Phase Separation|Mass Transfer Between Phases|absorption of incoming mass flow to the zones 1: perfect in the allocated zone, 0: perfect according to steam quality";
  parameter SI.Area A_phaseBorder=volume.geo.A_hor*100 "|Phase Separation|Heat Transfer Between Phases|Heat transfer area at phase border";
  parameter SI.CoefficientOfHeatTransfer alpha_ph=500 "|Phase Separation|Heat Transfer Between Phases|HTC of the phase border";
  parameter Real expHT_phases=0 "|Phase Separation|Heat Transfer Between Phases|Exponent for volume dependency on inter phase HT";
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "|Phase Separation|Numerical Robustness|Smoothness of table interpolation for calculation of filling level";

  parameter SI.EnthalpyMassSpecific h_liq_start=-10 +
      TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium,
      volume.p_start) "|Initialisation||Start value of liquid specific enthalpy";
  parameter SI.EnthalpyMassSpecific h_vap_start=+10 +
      TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(medium, volume.p_start) "|Initialisation||Start value of vapour specific enthalpy";

  replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 "Pressure loss model"
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
          volume.fluidIn[1].vleFluidPointer),
      s=TILMedia.VLEFluidObjectFunctions.specificEntropy_phxi(
          heatingSteam.p,
          actualStream(heatingSteam.h_outflow),
          actualStream(heatingSteam.xi_outflow),
          volume.fluidIn[1].vleFluidPointer),
      steamQuality=TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
          heatingSteam.p,
          actualStream(heatingSteam.h_outflow),
          actualStream(heatingSteam.xi_outflow),
          volume.fluidIn[1].vleFluidPointer),
      H_flow=heatingSteam.m_flow*actualStream(heatingSteam.h_outflow),
      rho=TILMedia.VLEFluidObjectFunctions.density_phxi(
          heatingSteam.p,
          actualStream(heatingSteam.h_outflow),
          actualStream(heatingSteam.xi_outflow),
          volume.fluidIn[1].vleFluidPointer)),
    condensate(
      showExpertSummary=showExpertSummary,
      m_flow=condensate.m_flow,
      p=condensate.p,
      h=actualStream(condensate.h_outflow),
      T=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
          condensate.p,
          actualStream(condensate.h_outflow),
          actualStream(condensate.xi_outflow),
          volume.fluidIn[2].vleFluidPointer),
      s=TILMedia.VLEFluidObjectFunctions.specificEntropy_phxi(
          condensate.p,
          actualStream(condensate.h_outflow),
          actualStream(condensate.xi_outflow),
          volume.fluidIn[2].vleFluidPointer),
      steamQuality=TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
          condensate.p,
          actualStream(condensate.h_outflow),
          actualStream(condensate.xi_outflow),
          volume.fluidIn[2].vleFluidPointer),
      H_flow=condensate.m_flow*actualStream(condensate.h_outflow),
      rho=TILMedia.VLEFluidObjectFunctions.density_phxi(
          condensate.p,
          actualStream(condensate.h_outflow),
          actualStream(condensate.xi_outflow),
          volume.fluidIn[2].vleFluidPointer)),
    feedwater(
      showExpertSummary=showExpertSummary,
      m_flow=outlet.m_flow,
      p=outlet.p,
      h=actualStream(outlet.h_outflow),
      T=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
          outlet.p,
          actualStream(outlet.h_outflow),
          actualStream(outlet.xi_outflow),
          volume.fluidIn[1].vleFluidPointer),
      s=TILMedia.VLEFluidObjectFunctions.specificEntropy_phxi(
          outlet.p,
          actualStream(outlet.h_outflow),
          actualStream(outlet.xi_outflow),
          volume.fluidIn[1].vleFluidPointer),
      steamQuality=TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
          outlet.p,
          actualStream(outlet.h_outflow),
          actualStream(outlet.xi_outflow),
          volume.fluidIn[1].vleFluidPointer),
      H_flow=outlet.m_flow*actualStream(outlet.h_outflow),
      rho=TILMedia.VLEFluidObjectFunctions.density_phxi(
          outlet.p,
          actualStream(outlet.h_outflow),
          actualStream(outlet.xi_outflow),
          volume.fluidIn[1].vleFluidPointer))) annotation (Placement(transformation(extent={{-60,-60},{-80,-40}})));
  Basics.ControlVolumes.FluidVolumes.VolumeVLE_L3_TwoZonesNPort volume(
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
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (             alpha_nom={3000,3000}),
    Tau_evap=Tau_evap,
    alpha_ph=500,
    h_liq_start=h_liq_start,
    h_vap_start=h_vap_start,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry (
        N_heat=1,
        A_heat={Modelica.Constants.pi*diameter*length},
        final A_hor=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then Modelica.Constants.pi/4*diameter^2 else diameter*length,
        N_outlet=2,
        z_out={z_feed,z_vent},
        shape=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then [0,1; 1,1] else [0.0005,0.02981; 0.0245,0.20716; 0.1245,0.45248; 0.2245,0.58733; 0.3245,0.68065; 0.4245,0.74791; 0.5245,0.7954; 0.6245,0.8261; 0.7245,0.84114; 0.8245,0.84015; 0.9245,0.82031; 1,0.7854],
        height_fill=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then length else diameter,
        volume=Modelica.Constants.pi/4*diameter^2*length,
        A_cross=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then Modelica.Constants.pi/4*diameter^2 else length*diameter,
        final A_front=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then Modelica.Constants.pi/4*diameter^2 else length*diameter,
        N_inlet=3,
        z_in={z_tapping,z_condensate,z_aux}),
    redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealSeparated (
        level_rel_start=level_rel_start,
        radius_flange=radius_flange,
        absorbInflow=absorbInflow,
        smoothness=smoothness),
    A_heat_ph=A_phaseBorder,
    exp_HT_phases=expHT_phases) annotation (Placement(transformation(extent={{32,-30},{12,-10}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.ThickWall_L4 wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    sizefunc=+1,
    N_tubes=1,
    initChoice=ClaRa.Basics.Choices.Init.steadyState,
    diameter_o=diameter/2*1.01,
    diameter_i=diameter/2,
    length=length,
    N_rad=3) annotation (Placement(transformation(extent={{12,24},{32,44}})));

  Basics.Interfaces.FluidPortOut vent(Medium=medium)
    annotation (Placement(transformation(extent={{-10,88},{10,108}}),
        iconTransformation(extent={{-10,88},{10,108}})));
public
  Basics.Interfaces.EyeOut eye_sat if   showData
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-52,80}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,110})));
protected
  Basics.Interfaces.EyeIn       eye_int1
    annotation (Placement(transformation(extent={{-41,73},{-39,75}})));
public
  Basics.Interfaces.FluidPortIn aux(Medium=medium) "Auxilliary inlet"
    annotation (Placement(transformation(extent={{150,50},{170,70}}),
        iconTransformation(extent={{150,50},{170,70}})));
  Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort(N=2)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={22,8})));
equation
  eye_int1.m_flow=-vent.m_flow;
  eye_int1.T=volume.summary.outlet[2].T-273.15;
  eye_int1.s=volume.fluidOut[2].s/1000;
  eye_int1.h=volume.summary.outlet[2].h/1000;
  eye_int1.p=volume.summary.outlet[2].p/100000;

  eye_int.m_flow=-outlet.m_flow;
  eye_int.T=volume.summary.outlet[1].T-273.15;
  eye_int.s=volume.fluidOut[1].s/1000;
  eye_int.h=volume.summary.outlet[1].h/1000;
  eye_int.p=volume.summary.outlet[1].p/100000;
  connect(volume.inlet[1], heatingSteam) annotation (Line(
      points={{32,-20},{40,-20},{40,80},{-200,80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.inlet[2], condensate) annotation (Line(
      points={{32,-20},{102,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.outlet[1], outlet) annotation (Line(
      points={{12,-20},{-98,-20}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.outlet[2], vent) annotation (Line(
      points={{12,-20},{0,-20},{0,98}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(eye_int1,eye_sat)
                        annotation (Line(
      points={{-40,74},{-40,80},{-52,80}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(aux, volume.inlet[3])           annotation (Line(
      points={{160,60},{44,60},{44,-20},{32,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort.heatVector, volume.heat) annotation (Line(
      points={{22,-2},{22,-10}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort.heatScalar, wall.innerPhase) annotation (Line(
      points={{22,18},{22,24.4},{21.8,24.4}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-300,
            -100},{300,100}}),
                   graphics),          Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-300,-100},{300,100}}),
                                               graphics));
end FeedWaterTank_L3_advanced;
