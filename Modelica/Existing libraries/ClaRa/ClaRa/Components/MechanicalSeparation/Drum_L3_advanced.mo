within ClaRa.Components.MechanicalSeparation;
model Drum_L3_advanced "Drum : separated volume approach | level-dependent phase separation"
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

extends ClaRa.Basics.Icons.Drum;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid
                                      medium=simCenter.fluid1 "Medium in the component"
                              annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);

  parameter Modelica.SIunits.Length diameter=1 "Diameter of the component"  annotation(Dialog(group="Geometry"));
  parameter Modelica.SIunits.Length length=1 "Length of the component"  annotation(Dialog(group="Geometry"));
  parameter Basics.Choices.GeometryOrientation      orientation=ClaRa.Basics.Choices.GeometryOrientation.vertical "Orientation of the component"
                                    annotation(Dialog(group="Geometry"));

  parameter Modelica.SIunits.Length radius_flange=0.05 "||Geometry|Flange radius";
  parameter SI.Length z_feed = 0 "||Geometry|Position of feedwater flange";
  parameter SI.Length z_riser= 0.1 "||Geometry|position of riser flange";
  parameter SI.Length z_sat = 0 "||Geometry|position of saturated steam outlet";
  parameter SI.Length z_down = 0.1 "||Geometry|position of downcomer flange";
  parameter Basics.Units.Time
                       Tau_cond=0.01 "|Phase Separation|Mass Transfer Between Phases|Time constant of condensation";
  parameter Basics.Units.Time Tau_evap=Tau_cond*1000 "|Phase Separation|Mass Transfer Between Phases|Time constant of evaporation";
  parameter Real absorbInflow=1 "|Phase Separation|Mass Transfer Between Phases|absorption of incoming mass flow to the zones 1: perfect in the allocated zone, 0: perfect according to steam quality";
  parameter SI.Area A_phaseBorder=volume.geo.A_hor*100 "|Phase Separation|Heat Transfer Between Phases|Heat transfer area at phase border";
  parameter SI.CoefficientOfHeatTransfer alpha_ph=500 "|Phase Separation|Heat Transfer Between Phases|HTC of the phase border";
  parameter Real expHT_phases=0 "|Phase Separation|Heat Transfer Between Phases|Exponent for volume dependency on inter phase HT";
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "|Phase Separation|Numerical Robustness|Smoothness of table interpolation for calculation of filling level";

  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));

  parameter SI.EnthalpyMassSpecific h_liq_start=-10 +
      TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium,
      volume.p_start) "|Initialisation||Start value of liquid specific enthalpy";
  parameter SI.EnthalpyMassSpecific h_vap_start=+10 +
      TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(medium, volume.p_start) "|Initialisation||Start value of vapour specific enthalpy";
  parameter Modelica.SIunits.Pressure p_start=1e5 "Start value of sytsem pressure"     annotation(Dialog(tab="Initialisation"));
  parameter Real level_rel_start "Initial filling level" annotation(Dialog(tab="Initialisation"));
  parameter Basics.Choices.Init      initType=ClaRa.Basics.Choices.Init.noInit "Type of initialisation"
                             annotation(Dialog(tab="Initialisation"));
  replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 "Pressure loss model"
                          annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  parameter Modelica.SIunits.Pressure p_nom=1e5 "Nominal pressure"  annotation(Dialog(group="Nominal Values"));

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";

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
   ClaRa.Basics.Records.FlangeVLE riser;
   ClaRa.Basics.Records.FlangeVLE down;
   ClaRa.Basics.Records.FlangeVLE feedwater;
   ClaRa.Basics.Records.FlangeVLE sat;

 end Summary;

  Summary summary(
    outline(level_abs=volume.phaseBorder.level_abs, level_rel =                                                                                                    volume.phaseBorder.level_rel),
    wall(T_wall=wall.T),
    riser(
      showExpertSummary=showExpertSummary,
      m_flow=riser.m_flow,
      p=riser.p,
      h=actualStream(riser.h_outflow),
      T=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
          riser.p,
          actualStream(riser.h_outflow),
          actualStream(riser.xi_outflow),
          volume.fluidIn[1].vleFluidPointer),
      s=TILMedia.VLEFluidObjectFunctions.specificEntropy_phxi(
          riser.p,
          actualStream(riser.h_outflow),
          actualStream(riser.xi_outflow),
          volume.fluidIn[1].vleFluidPointer),
      steamQuality=TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
          riser.p,
          actualStream(riser.h_outflow),
          actualStream(riser.xi_outflow),
          volume.fluidIn[1].vleFluidPointer),
      H_flow=riser.m_flow*actualStream(riser.h_outflow),
      rho=TILMedia.VLEFluidObjectFunctions.density_phxi(
          riser.p,
          actualStream(riser.h_outflow),
          actualStream(riser.xi_outflow),
          volume.fluidIn[1].vleFluidPointer)),
    down(
      showExpertSummary=showExpertSummary,
      m_flow=-down.m_flow,
      p=down.p,
      h=actualStream(down.h_outflow),
      T=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
          down.p,
          actualStream(down.h_outflow),
          actualStream(down.xi_outflow),
          volume.fluidIn[2].vleFluidPointer),
      s=TILMedia.VLEFluidObjectFunctions.specificEntropy_phxi(
          down.p,
          actualStream(down.h_outflow),
          actualStream(down.xi_outflow),
          volume.fluidIn[2].vleFluidPointer),
      steamQuality=TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
          down.p,
          actualStream(down.h_outflow),
          actualStream(down.xi_outflow),
          volume.fluidIn[2].vleFluidPointer),
      H_flow=-down.m_flow*actualStream(down.h_outflow),
      rho=TILMedia.VLEFluidObjectFunctions.density_phxi(
          down.p,
          actualStream(down.h_outflow),
          actualStream(down.xi_outflow),
          volume.fluidIn[2].vleFluidPointer)),
    feedwater(
      showExpertSummary=showExpertSummary,
      m_flow=feed.m_flow,
      p=feed.p,
      h=actualStream(feed.h_outflow),
      T=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
          feed.p,
          actualStream(feed.h_outflow),
          actualStream(feed.xi_outflow),
          volume.fluidIn[1].vleFluidPointer),
      s=TILMedia.VLEFluidObjectFunctions.specificEntropy_phxi(
          feed.p,
          actualStream(feed.h_outflow),
          actualStream(feed.xi_outflow),
          volume.fluidIn[1].vleFluidPointer),
      steamQuality=TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
          feed.p,
          actualStream(feed.h_outflow),
          actualStream(feed.xi_outflow),
          volume.fluidIn[1].vleFluidPointer),
      H_flow=feed.m_flow*actualStream(feed.h_outflow),
      rho=TILMedia.VLEFluidObjectFunctions.density_phxi(
          feed.p,
          actualStream(feed.h_outflow),
          actualStream(feed.xi_outflow),
          volume.fluidIn[1].vleFluidPointer)),
    sat(
      showExpertSummary=showExpertSummary,
      m_flow=-sat.m_flow,
      p=sat.p,
      h=actualStream(sat.h_outflow),
      T=TILMedia.VLEFluidObjectFunctions.temperature_phxi(
          sat.p,
          actualStream(sat.h_outflow),
          actualStream(sat.xi_outflow),
          volume.fluidIn[1].vleFluidPointer),
      s=TILMedia.VLEFluidObjectFunctions.specificEntropy_phxi(
          sat.p,
          actualStream(sat.h_outflow),
          actualStream(sat.xi_outflow),
          volume.fluidIn[1].vleFluidPointer),
      steamQuality=TILMedia.VLEFluidObjectFunctions.steamMassFraction_phxi(
          sat.p,
          actualStream(sat.h_outflow),
          actualStream(sat.xi_outflow),
          volume.fluidIn[1].vleFluidPointer),
      H_flow=-sat.m_flow*actualStream(sat.h_outflow),
      rho=TILMedia.VLEFluidObjectFunctions.density_phxi(
          sat.p,
          actualStream(sat.h_outflow),
          actualStream(sat.xi_outflow),
          volume.fluidIn[1].vleFluidPointer))) annotation (Placement(transformation(extent={{-60,-60},{-80,-40}})));
  Basics.ControlVolumes.FluidVolumes.VolumeVLE_L3_TwoZonesNPort volume(
    medium=medium,
    redeclare model PressureLoss = PressureLoss,
    useHomotopy=useHomotopy,
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
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry (
        volume=Modelica.Constants.pi/4*diameter^2*length,
        N_heat=1,
        A_heat={Modelica.Constants.pi*diameter*length},
        final A_hor=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then Modelica.Constants.pi/4*diameter^2 else diameter*length,
        N_inlet=2,
        N_outlet=2,
        shape=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then [0,1; 1,1] else [0.0005,0.02981; 0.0245,0.20716; 0.1245,0.45248; 0.2245,0.58733; 0.3245,0.68065; 0.4245,0.74791; 0.5245,0.7954; 0.6245,0.8261; 0.7245,0.84114; 0.8245,0.84015; 0.9245,0.82031; 1,0.7854],
        height_fill=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then length else diameter,
        A_cross=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then Modelica.Constants.pi/4*diameter^2 else length*diameter,
        final A_front=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then Modelica.Constants.pi/4*diameter^2 else length*diameter,
        z_in={z_feed,z_riser},
        z_out={z_sat,z_down}),
    h_liq_start=h_liq_start,
    h_vap_start=h_vap_start,
    redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealSeparated (
        level_rel_start=level_rel_start,
        radius_flange=radius_flange,
        absorbInflow=absorbInflow,
        smoothness=smoothness),
    A_heat_ph=A_phaseBorder,
    exp_HT_phases=expHT_phases) annotation (Placement(transformation(extent={{12,-30},{-8,-10}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.ThickWall_L4 wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    sizefunc=+1,
    N_tubes=1,
    initChoice=ClaRa.Basics.Choices.Init.steadyState,
    diameter_o=diameter/2*1.01,
    diameter_i=diameter/2,
    length=length,
    N_rad=3) annotation (Placement(transformation(extent={{-8,28},{12,48}})));

  Basics.Interfaces.FluidPortOut sat(Medium=medium) "Saturated steam outlet"
    annotation (Placement(transformation(extent={{-190,90},{-170,110}}),
        iconTransformation(extent={{-190,90},{-170,110}})));
  Basics.Interfaces.FluidPortOut down(Medium=medium) "Downcomer outlet"
    annotation (Placement(transformation(extent={{-10,-108},{10,-88}}),
        iconTransformation(extent={{-10,-108},{10,-88}})));
  Basics.Interfaces.FluidPortIn feed(Medium=medium) "Feedwater inlet"
    annotation (Placement(transformation(extent={{290,-10},{310,10}}),
        iconTransformation(extent={{290,-10},{310,10}})));
  Basics.Interfaces.FluidPortIn riser(Medium=medium) "Riser inlet"
    annotation (Placement(transformation(extent={{-270,-104},{-250,-84}}),
        iconTransformation(extent={{-270,-104},{-250,-84}})));
protected
  Basics.Interfaces.EyeIn       eye_int
    annotation (Placement(transformation(extent={{59,-51},{61,-49}})));
public
  Basics.Interfaces.EyeOut eye_down if  showData
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-98}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,-106})));
protected
  Basics.Interfaces.EyeIn       eye_int1
    annotation (Placement(transformation(extent={{-9,91},{-7,93}})));
public
  Basics.Interfaces.EyeOut eye_sat if   showData
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,98}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-220,110})));

  Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort(N=2)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={2,10})));
equation
  eye_int.m_flow=-down.m_flow;
  eye_int.T=volume.summary.outlet[2].T-273.15;
  eye_int.s=volume.fluidOut[2].s/1000;
  eye_int.h=volume.summary.outlet[2].h/1000;
  eye_int.p=volume.summary.outlet[2].p/100000;

  eye_int1.m_flow=-sat.m_flow;
  eye_int1.T=volume.summary.outlet[1].T-273.15;
  eye_int1.s=volume.fluidOut[1].s/1000;
  eye_int1.h=volume.summary.outlet[1].h/1000;
  eye_int1.p=volume.summary.outlet[1].p/100000;

  connect(feed, volume.inlet[1]) annotation (Line(
      points={{300,0},{18,0},{18,-20},{12,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(riser, volume.inlet[2]) annotation (Line(
      points={{-260,-94},{-78,-94},{-78,-10},{16,-10},{16,-20},{12,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.outlet[1], sat) annotation (Line(
      points={{-8,-20},{-180,-20},{-180,100}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.outlet[2], down) annotation (Line(
      points={{-8,-20},{-8,-98},{0,-98}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(eye_int, eye_down)
                        annotation (Line(
      points={{60,-50},{60,-98}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(eye_int1, eye_sat)
                        annotation (Line(
      points={{-8,92},{-8,98},{-20,98}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort.heatScalar, wall.innerPhase) annotation (Line(
      points={{2,20},{2,28.4},{1.8,28.4}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.heat, scalar2VectorHeatPort.heatVector) annotation (Line(
      points={{2,-10},{2,0}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-300,
            -100},{300,100}}),
                   graphics),          Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-300,-100},{300,100}}),
                                               graphics));
end Drum_L3_advanced;
