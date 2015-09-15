within ClaRa.Components.HeatExchangers;
model HEXvle_L3_2ph_BU "sinhgle side:VLE | L3 | two phase at shell side | Block shape | U-type"
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

  import SI = Modelica.SIunits;
  // Extends from... ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  extends ClaRa.Basics.Icons.HEX04;
  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut=if not heatFlowIsLoss then -heat.Q_flow else 0,
    powerAux=0) if                                                                                                     contributeToCycleSummary;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  outer ClaRa.SimCenter simCenter;

  record Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary=false;
    ClaRa.Basics.Units.HeatFlowRate
                    Q_flow "Heat flow rate";
    ClaRa.Basics.Units.Length
              absLevel "Absolute filling level";
    Real relLevel "relative filling level";
  end Outline;

  record Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
  end Summary;
  // Parameters and other user definable settings~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  //*********************************** / SHELL SIDE \ ***********************************//
  //________________________________ Shell fundamentals _______________________________//
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_shell=simCenter.fluid1 "Medium to be used for shell flow"
                                       annotation (choices(
      choice=simCenter.fluid1 "First fluid defined in global simCenter",
      choice=simCenter.fluid2 "Second fluid defined in global simCenter",
      choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(tab=
          "Shell Side", group="Fundamental Definitions"));

  replaceable model HeatTransfer_Shell =
     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellType_L3 "Heat transfer model at shell side"
                                        annotation (Dialog(tab="Shell Side",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLossShell =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L3 "Pressure loss model at shell side"
                                        annotation (Dialog(tab="Shell Side",
        group="Fundamental Definitions"), choicesAllMatching);

  //________________________________ Shell geometry _______________________________//
  parameter ClaRa.Basics.Units.Length
                      length=10 "Length of the HEX" annotation (Dialog(
      tab="Shell Side",
      group="Geometry",
      groupImage="modelica://ClaRa/figures/ParameterDialog/HollowBlockWithTubes_1.png"));
  parameter ClaRa.Basics.Units.Length
                      height=3 "Height of HEX"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Length
                      width=3 "Width of HEX"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Length
                      z_in_shell=length/2 "Inlet position from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
    parameter ClaRa.Basics.Units.Length
                        z_in_aux1=length/2 "Inlet position of auxilliary1 from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Length
                      z_in_aux2=length/2 "Inlet position of auxilliary2 from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Length
                      z_out_shell=length/2 "Outlet position from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length radius_flange=0.05 "|Shell Side|Geometry|Flange radius of all flanges";
  parameter ClaRa.Basics.Units.Mass
                    mass_struc=0 "Mass of inner structure elements, additional to the tubes itself"
    annotation (Dialog(tab="Shell Side", group="Geometry"));

  //________________________________ Shell nominal parameter _____________________________________//
  parameter ClaRa.Basics.Units.MassFlowRate
                            m_flow_nom_shell=10 "Nominal mass flow on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter ClaRa.Basics.Units.Pressure
                        p_nom_shell=10 "Nominal pressure on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));

  //________________________________ Shell initialisation  _______________________________________//
   parameter Basics.Units.EnthalpyMassSpecific h_liq_start=-10 +
       TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium_shell, p_start_shell) "|Shell Side|Initialisation|Start specific enthalpy of liquid phase";
   parameter Basics.Units.EnthalpyMassSpecific h_vap_start=+10 +
       TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(medium_shell, p_start_shell) "|Shell Side|Initialisation|Start specific enthalpy of steam phase";

  parameter ClaRa.Basics.Units.Pressure
                        p_start_shell=1e5 "Start value of sytsem pressure"
    annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter Real level_rel_start=0.5 "|Shell Side|Initialisation| Start value for relative filling Level";
  parameter Basics.Choices.Init initTypeShell=ClaRa.Basics.Choices.Init.noInit "Type of initialisation"
    annotation (Dialog(tab="Shell Side", group="Initialisation"));

  //________________________________ Tubes geometry _______________________________//
//   parameter SI.Length d_i=0.048 "Inner diameter of horizontal tubes"
//     annotation (Dialog(
//       tab="Tubes",
//       group="Geometry",
//       groupImage="modelica://ClaRa/figures/ParameterDialog/HollowBlockWithTubes_2.png"));
  parameter ClaRa.Basics.Units.Length
                      diameter_o=0.05 "Outer diameter of horizontal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry",
      groupImage="modelica://ClaRa/figures/ParameterDialog/HollowBlockWithTubes_2.png"));
  parameter Integer N_tubes=1000 "Number of horizontal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Boolean staggeredAlignment=true "True, if the tubes are aligned staggeredly, false otherwise"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_passes=1 "Number of passes of the internal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Boolean parallelTubes=false "True, if tubes are parallel to main orientation, else false"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter ClaRa.Basics.Units.Length
                      z_in_tubes=length/2 "Inlet position from bottom"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter ClaRa.Basics.Units.Length
                      z_out_tubes=length/2 "Outlet position from bottom"
    annotation (Dialog(tab="Tubes", group="Geometry"));

  parameter ClaRa.Basics.Units.Length
                      Delta_z_par=2*diameter_o "Distance between tubes parallel to flow direction (center to center)"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter ClaRa.Basics.Units.Length
                      Delta_z_ort=2*diameter_o "Distance between tubes orthogonal to flow direction (center to center)"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Real CF_geo=1 "Correction coefficient due to fins etc."
    annotation (Dialog(tab="Tubes", group="Geometry"));

  //*********************************** / HOTWELL \ ***********************************//
  parameter Basics.Units.Length height_hotwell=1 "Height of the hotwell"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length width_hotwell=1 "Width of the hotwell"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length length_hotwell=1 "Length of the hotwell"
    annotation (Dialog(tab="Shell Side", group="Geometry"));

//*********************************** / EXPERT Settings and Visualisation \ ***********************************//
  parameter Basics.Units.Time Tau_cond=0.3 "|Expert Settings|Zone Interaction at Shell Side|Time constant of condensation";
  parameter Basics.Units.Time Tau_evap=0.03 "|Expert Settings|Zone Interaction at Shell Side|Time constant of evaporation";
  parameter Basics.Units.CoefficientOfHeatTransfer alpha_ph=50000 "|Expert Settings|Zone Interaction at Shell Side|HTC of the phase border";
  parameter Basics.Units.Area A_phaseBorder=shell.geo.A_hor*100 "|Expert Settings|Zone Interaction at Shell Side|Heat transfer area at phase border";
  parameter Real expHT_phases=0 "|Expert Settings|Zone Interaction at Shell Side|Exponent for volume dependency on inter phase HT";
  parameter Real absorbInflow=1 "|Expert Settings|Zone Interaction at Shell Side|Absorption of incoming mass flow to the zones 1: perfect in the allocated zone, 0: perfect according to steam quality";

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation" annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean heatFlowIsLoss = true "True if heat flow is a loss (not a process product)" annotation(Dialog(tab="Summary and Visualisation"));
//   parameter Real gain_eff=1
//     "|Expert Settings|NTU model|Avoid effectiveness > 1, high gain_eff leads to stricter observation but may cause numeric errors";

  ClaRa.Basics.Interfaces.FluidPortOut outlet(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  ClaRa.Basics.Interfaces.FluidPortIn inlet(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-10,90},{10,110}}),
        iconTransformation(extent={{-10,90},{10,110}})));

  Basics.ControlVolumes.FluidVolumes.VolumeVLE_L3_TwoZonesNPort shell(
    medium=medium_shell,
    p_nom=p_nom_shell,
    redeclare model HeatTransfer = HeatTransfer_Shell,
    redeclare model PressureLoss = PressureLossShell,
    m_flow_nom=m_flow_nom_shell,
    useHomotopy=useHomotopy,
    p_start=p_start_shell,
    initType=initTypeShell,
    showExpertSummary=showExpertSummary,
    Tau_cond=Tau_cond,
    Tau_evap=Tau_evap,
    alpha_ph=alpha_ph,
    A_heat_ph=A_phaseBorder,
    h_liq_start=h_liq_start,
    h_vap_start=h_vap_start,
    level_rel_start=level_rel_start,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndHotwell (
        height=height,
        width=width,
        length=length,
        diameter_t=diameter_o,
        staggeredAlignment=staggeredAlignment,
        height_hotwell=height_hotwell,
        width_hotwell=width_hotwell,
        length_hotwell=length_hotwell,
        Delta_z_par=Delta_z_par,
        Delta_z_ort=Delta_z_ort,
        N_inlet=3,
        z_out={z_out_shell},
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        z_in={z_in_shell,z_in_aux1,z_in_aux2},
        N_tubes=N_tubes,
        N_passes=N_passes,
        parallelTubes=parallelTubes),
    redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealSeparated (
        level_rel_start=level_rel_start,
        radius_flange=radius_flange,
        absorbInflow=absorbInflow),
    exp_HT_phases=expHT_phases,
    heatSurfaceAlloc=2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,60})));
  Summary summary(outline(
      showExpertSummary=showExpertSummary,
      Q_flow=sum(shell.heat.Q_flow),
      absLevel=shell.phaseBorder.level_abs,
      relLevel=shell.phaseBorder.level_rel)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-92})));
public
   Basics.Interfaces.EyeOut eye if  showData annotation (Placement(
         transformation(
         extent={{-10,-10},{10,10}},
         rotation=270,
         origin={28,-98})));
protected
   Basics.Interfaces.EyeIn eye_int1
     annotation (Placement(transformation(extent={{27,-59},{29,-57}})));

public
  Basics.Interfaces.FluidPortIn       aux1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-110,70},{-90,90}}),
        iconTransformation(extent={{-110,70},{-90,90}})));
  Basics.Interfaces.FluidPortIn       aux2(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}),
        iconTransformation(extent={{-110,50},{-90,70}})));
  Basics.Interfaces.HeatPort_a heat
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort(N=2, final equalityMode="Equal Temperatures")
    annotation (Placement(transformation(extent={{44,16},{24,36}})));
initial equation
   //        wall.T=(tubes.bulk.T+shell.bulk.T)/2;
//

equation

//   assert(diameter_o > d_i,
//     "Outer diameter of tubes must be greater than inner diameter");

   eye_int1.m_flow = -outlet.m_flow;
   eye_int1.T = shell.summary.outlet[1].T - 273.15;
   eye_int1.s = shell.fluidOut[1].s/1e3;
   eye_int1.p = shell.outlet[1].p/1e5;
   eye_int1.h = shell.summary.outlet[1].h/1e3;
//    eye_int2.m_flow = -Out2.m_flow;
//    eye_int2.T = tubes.summary.outlet.T - 273.15;
//    eye_int2.s = tubes.fluidOut.s/1e3;
//    eye_int2.p = tubes.outlet.p/1e5;
//    eye_int2.h = tubes.summary.outlet.h/1e3;

  connect(eye_int1, eye)   annotation (Line(
       points={{28,-58},{28,-98}},
       color={255,204,51},
       thickness=0.5,
       smooth=Smooth.None));
  connect(inlet, shell.inlet[1])
                               annotation (Line(
      points={{0,100},{0,70}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shell.outlet[1], outlet)
                                 annotation (Line(
      points={{0,50},{0,-100}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(aux1, shell.inlet[2]) annotation (Line(
      points={{-100,80},{0,80},{0,70}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(aux2, shell.inlet[3]) annotation (Line(
      points={{-100,60},{-70,60},{-70,74},{1.77636e-015,74},{1.77636e-015,70}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort.heatVector, shell.heat) annotation (Line(
      points={{24,26},{18,26},{18,60},{10,60}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort.heatScalar, heat) annotation (Line(
      points={{44,26},{74,26},{74,0},{100,0}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics));
end HEXvle_L3_2ph_BU;
