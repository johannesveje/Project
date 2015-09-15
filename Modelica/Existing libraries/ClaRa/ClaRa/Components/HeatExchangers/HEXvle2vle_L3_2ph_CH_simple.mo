within ClaRa.Components.HeatExchangers;
model HEXvle2vle_L3_2ph_CH_simple "VLE 2 VLE | L3 | 2 phase at shell side | Cylinder shape | Header type | simple HT"
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

  import SI = ClaRa.Basics.Units;
  // Extends from... ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  extends ClaRa.Basics.Icons.HEX05;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  outer ClaRa.SimCenter simCenter;

  record Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary=false;
    Basics.Units.HeatFlowRate Q_flow "Heat flow rate";
    Basics.Units.TemperatureDifference Delta_T_in "Fluid temperature at inlet T_1_in - T_2_in";
    Basics.Units.TemperatureDifference Delta_T_out "Fluid temperature at outlet T_1_out - T_2_out";
    Real effectivenes if showExpertSummary "Effectivenes of HEX";
    Real kA(unit="W/K") if showExpertSummary "Overall heat resistance";
    Basics.Units.Length absLevel "Absolute filling level";
    Real relLevel "relative filling level";
  end Outline;

  record Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
  end Summary;

  // Parameters and other user definable settings~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
   annotation (Dialog(group="Fundamental Definitions",groupImage="modelica://ClaRa/figures/ParameterDialog/CH_general.png"), choicesAllMatching);

  //________________________________ Shell geometry _______________________________//
  parameter Basics.Units.Length length=10 "Length of the HEX"
    annotation (Dialog(tab="Shell Side", group="Geometry",groupImage="modelica://ClaRa/figures/ParameterDialog/CH_shell.png"));
  parameter Basics.Units.Length diameter=3 "Diameter of HEX"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length z_in_shell=length/2 "Inlet position from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
    parameter SI.Length z_in_aux1=length/2 "Inlet position of auxilliary1 from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter SI.Length z_in_aux2=length/2 "Inlet position of auxilliary2 from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length z_out_shell=length/2 "Outlet position from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length radius_flange=0.05 "|Shell Side|Geometry|Flange radius of all flanges";
  parameter Basics.Units.Mass mass_struc=0 "Mass of inner structure elements, additional to the tubes itself"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Choices.GeometryOrientation orientation=ClaRa.Basics.Choices.GeometryOrientation.vertical "|Shell Side|Geometry|Orientation of the component";
  //________________________________ Shell nominal parameter _____________________________________//
  parameter Basics.Units.MassFlowRate m_flow_nom_shell=10 "Nominal mass flow on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter Basics.Units.Pressure p_nom_shell=10 "Nominal pressure on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter Basics.Units.EnthalpyMassSpecific h_nom_shell=100e3 "Nominal specific enthalpy on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));

  //________________________________ Shell initialisation  _______________________________________//
    parameter SI.EnthalpyMassSpecific h_liq_start=-10 +
      TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium_shell,
      p_start_shell) "|Shell Side|Initialisation|Start value of liquid specific enthalpy";
  parameter SI.EnthalpyMassSpecific h_vap_start=+10 +
      TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(medium_shell, p_start_shell) "|Shell Side|Initialisation|Start value of vapour specific enthalpy";

  parameter Basics.Units.Pressure p_start_shell=1e5 "Start value of shell fluid pressure"
    annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter Real level_rel_start=0.5 "|Shell Side|Initialisation|Start value for relative filling Level";
  parameter Basics.Choices.Init initTypeShell=ClaRa.Basics.Choices.Init.noInit "Type of shell fluid initialisation"
    annotation (Dialog(tab="Shell Side", group="Initialisation"));

  //*********************************** / TUBE SIDE \ ***********************************//
  //________________________________ Tubes fundamentals _______________________________//

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_tubes=simCenter.fluid1 "Medium to be used for tubes flow"
                                       annotation (choices(
      choice=simCenter.fluid1 "First fluid defined in global simCenter",
      choice=simCenter.fluid2 "Second fluid defined in global simCenter",
      choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(tab="Tubes",
        group="Fundamental Definitions"));
  replaceable model HeatTransferTubes =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeType_L2 "Heat transfer mode at the tubes side"
                                           annotation (Dialog(tab="Tubes",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLossTubes =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.TubeType_L2 "Pressure loss model at the tubes side"
                                            annotation (Dialog(tab="Tubes",
        group="Fundamental Definitions"), choicesAllMatching);

  //________________________________ Tubes geometry _______________________________//
  parameter Basics.Units.Length diameter_i=0.048 "Inner diameter of internal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry",groupImage="modelica://ClaRa/figures/ParameterDialog/CH_tubes.png"));
  parameter Basics.Units.Length diameter_o=0.05 "Outer diameter of internal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Basics.Units.Length length_tubes=10 "Length of the tubes (one pass)"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_tubes=1000 "Number of horizontal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Boolean staggeredAlignment=true "True, if the tubes are aligned staggeredly, false otherwise"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_passes=1 "Number of passes of the internal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Basics.Units.Length Delta_z_par=2*diameter_o "|Tubes|Geometry|Distance between tubes parallel to flow direction (center to center)";
  parameter Basics.Units.Length Delta_z_ort=2*diameter_o "|Tubes|Geometry|Distance between tubes orthogonal to flow direction (center to center)";
  parameter Basics.Units.Length z_in_tubes=length/2 "Inlet position from bottom"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Basics.Units.Length z_out_tubes=length/2 "Outlet position from bottom"
    annotation (Dialog(tab="Tubes", group="Geometry"));

  //________________________________ Tubes nominal parameter _____________________________________//
  parameter Basics.Units.MassFlowRate m_flow_nom_tubes=10 "Nominal mass flow on tubes side"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter Basics.Units.Pressure p_nom_tubes=10 "Nominal pressure on side tubes"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter Basics.Units.EnthalpyMassSpecific h_nom_tubes=10 "Nominal specific enthalpy on tubes side"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter Basics.Units.HeatFlowRate Q_flow_nom=1e6 "Nominal heat flow rate"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));

  //___________________________Initialisation tubes _______________________________________//
  parameter Basics.Units.EnthalpyMassSpecific h_start_tubes=1e5 "|Tubes|Initialisation|Start value of tube fluid specific enthalpy";
  parameter Basics.Units.Pressure p_start_tubes=1e5 "|Tubes|Initialisation|Start value of tube fluid pressure";
  parameter Basics.Choices.Init initTypeTubes=ClaRa.Basics.Choices.Init.noInit "|Tubes|Initialisation|Type of tube fluid initialisation";

  //***********************************/ WALL \ *****************************************//
  replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Aluminum
    constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder"
    annotation (choicesAllMatching=true, Dialog(tab="Wall", group=
          "Fundamental Definitions"));

  parameter Basics.Units.Temperature T_w_start[3]=ones(3)*293.15 "|Wall|Initialisation|Initial temperature at outer phase";
  parameter Basics.Choices.Init initTypeWall=ClaRa.Basics.Choices.Init.noInit "|Wall|Initialisation|Init option of Tube wall";
  parameter Real CF_geo=1 "|Tubes|Correction Factors|Correction coefficient due to fins etc.";

  //*********************************** / EXPERT Settings and Visualisation \ ***********************************//
  parameter Basics.Units.Time Tau_cond=0.3 "|Expert Settings|Zone Interaction at Shell Side|Time constant of condensation";
  parameter Basics.Units.Time Tau_evap=0.03 "|Expert Settings|Zone Interaction at Shell Side|Time constant of evaporation";
  parameter Basics.Units.CoefficientOfHeatTransfer alpha_ph=50000 "|Expert Settings|Zone Interaction at Shell Side|HTC of the phase border";
  parameter Basics.Units.Area A_phaseBorder=shell.geo.A_hor*100 "|Expert Settings|Zone Interaction at Shell Side|Heat transfer area at phase border";
  parameter Real expHT_phases=0 "|Expert Settings|Zone Interaction at Shell Side|Exponent for volume dependency on inter phase HT";
  parameter Real absorbInflow=1 "|Expert Settings|Zone Interaction at Shell Side|Absorption of incoming mass flow to the zones 1: perfect in the allocated zone, 0: perfect according to steam quality";

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";

  ClaRa.Basics.Interfaces.FluidPortIn In2(Medium=medium_tubes)
    annotation (Placement(transformation(extent={{90,12},{110,32}}),
        iconTransformation(extent={{90,12},{110,32}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out2(Medium=medium_tubes)
    annotation (Placement(transformation(extent={{-110,10},{-90,30}}),
        iconTransformation(extent={{-110,10},{-90,30}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  ClaRa.Basics.Interfaces.FluidPortIn In1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-10,88},{10,108}})));

  Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 tubes(
    medium=medium_tubes,
    p_nom=p_nom_tubes,
    h_nom=h_nom_tubes,
    m_flow_nom=m_flow_nom_tubes,
    useHomotopy=useHomotopy,
    h_start=h_start_tubes,
    p_start=p_start_tubes,
    initType=initTypeTubes,
    redeclare model HeatTransfer = HeatTransferTubes,
    redeclare model PressureLoss = PressureLossTubes,
    redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        z_in={z_in_tubes},
        z_out={z_out_tubes},
        diameter=diameter_i,
        N_tubes=N_tubes,
        orientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        N_passes=N_passes,
        length=length_tubes),
    showExpertSummary=showExpertSummary)
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));

  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L3_TwoZonesNPort shell(
    medium=medium_shell,
    p_nom=p_nom_shell,
    redeclare model HeatTransfer = HeatTransfer_Shell,
    redeclare model PressureLoss = PressureLossShell,
    m_flow_nom=m_flow_nom_shell,
    useHomotopy=useHomotopy,
    p_start=p_start_shell,
    initType=initTypeShell,
    level_rel_start=level_rel_start,
    Tau_cond=Tau_cond,
    Tau_evap=Tau_evap,
    alpha_ph=alpha_ph,
    h_liq_start=h_liq_start,
    h_vap_start=h_vap_start,
    showExpertSummary=showExpertSummary,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.CH_Nports (
        z_out={z_out_shell},
        length=length,
        N_tubes=N_tubes,
        staggeredAlignment=staggeredAlignment,
        Delta_z_par=Delta_z_par,
        Delta_z_ort=Delta_z_ort,
        diameter=diameter,
        final Np=N_passes,
        length_tubes=length_tubes,
        diameter_t=diameter_o,
        N_inlet=3,
        z_in={z_in_shell,z_in_aux1,z_in_aux2},
        orientation=orientation),
    redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealSeparated (
        level_rel_start=level_rel_start,
        radius_flange=radius_flange,
        absorbInflow=absorbInflow),
    exp_HT_phases=expHT_phases,
    A_heat_ph=A_phaseBorder,
    heatSurfaceAlloc=2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,60})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.ThickWall_L4 wall(
    redeclare replaceable model Material = WallMaterial,
    initChoice=initTypeWall,
    N_rad=3,
    sizefunc=1,
    diameter_o=diameter_o,
    diameter_i=diameter_i,
    N_tubes=N_tubes,
    T_start=T_w_start,
    length=length*N_passes) annotation (Placement(transformation(extent={{20,23},{40,43}})));

public
  Summary summary(outline(
      showExpertSummary=showExpertSummary,
      Q_flow=sum(shell.heat.Q_flow),
      Delta_T_in=shell.summary.inlet[1].T - tubes.summary.inlet.T,
      Delta_T_out=shell.summary.outlet[1].T - tubes.summary.outlet.T,
      effectivenes=1,
      kA=1,
      absLevel=shell.phaseBorder.level_abs,
      relLevel=shell.phaseBorder.level_rel)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-92})));
protected
   Basics.Interfaces.EyeIn eye_int2
     annotation (Placement(transformation(extent={{-51,-43},{-49,-41}})));
public
   Basics.Interfaces.EyeOut eye2 if showData annotation (Placement(
         transformation(
         extent={{-10,-10},{10,10}},
         rotation=180,
         origin={-100,-42}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-110,0})));
protected
   Basics.Interfaces.EyeIn eye_int1
     annotation (Placement(transformation(extent={{27,-59},{29,-57}})));
public
   Basics.Interfaces.EyeOut eye1 if showData annotation (Placement(
         transformation(
         extent={{-10,-10},{10,10}},
         rotation=270,
         origin={28,-98})));
  Basics.Interfaces.FluidPortIn       aux1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
  Basics.Interfaces.FluidPortIn       aux2(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}),
        iconTransformation(extent={{-110,50},{-90,70}})));

equation
   assert(diameter_o > diameter_i,
     "Outer diameter of tubes must be greater than inner diameter");

initial equation
  //        wall.T=(tubes.bulk.T+shell.bulk.T)/2;

equation
  connect(tubes.inlet, In2) annotation (Line(
      points={{40,0},{74,0},{74,22},{100,22}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tubes.outlet, Out2) annotation (Line(
      points={{20,0},{-36,0},{-36,20},{-100,20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(wall.innerPhase, tubes.heat) annotation (Line(
      points={{29.8,23.4},{29.8,10},{30,10}},
      color={191,0,0},
      smooth=Smooth.None));
   connect(eye_int2, eye2) annotation (Line(
       points={{-50,-42},{-100,-42}},
       color={255,204,51},
       thickness=0.5,
       smooth=Smooth.None));
   connect(eye_int1, eye1) annotation (Line(
       points={{28,-58},{28,-98}},
       color={255,204,51},
       thickness=0.5,
       smooth=Smooth.None));

   eye_int1.m_flow=-shell.outlet[1].m_flow;
   eye_int1.T=shell.summary.outlet[1].T-273.15;
   eye_int1.s=shell.fluidOut[1].s/1000;
   eye_int1.h=shell.summary.outlet[1].h/1000;
   eye_int1.p=shell.summary.outlet[1].p/100000;

   eye_int2.m_flow=-tubes.outlet.m_flow;
   eye_int2.T=tubes.summary.outlet.T-273.15;
   eye_int2.s=tubes.fluidOut.s/1000;
   eye_int2.h=tubes.summary.outlet.h/1000;
   eye_int2.p=tubes.summary.outlet.p/100000;

  connect(In1, shell.inlet[1]) annotation (Line(
      points={{0,98},{0,70},{1.77636e-015,70}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shell.outlet[1], Out1) annotation (Line(
      points={{-1.77636e-015,50},{-1.77636e-015,-26},{0,-26},{0,-100}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(aux1, shell.inlet[2]) annotation (Line(
      points={{-100,80},{1.77636e-015,80},{1.77636e-015,70}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(aux2, shell.inlet[3]) annotation (Line(
      points={{-100,60},{-56,60},{-56,74},{1.77636e-015,74},{1.77636e-015,70}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(shell.heat[1], wall.outerPhase) annotation (Line(
      points={{9.5,60},{30,60},{30,43.1333}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shell.heat[2], wall.outerPhase) annotation (Line(
      points={{10.5,60},{18,60},{18,43.1333},{30,43.1333}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                      graphics));
end HEXvle2vle_L3_2ph_CH_simple;
