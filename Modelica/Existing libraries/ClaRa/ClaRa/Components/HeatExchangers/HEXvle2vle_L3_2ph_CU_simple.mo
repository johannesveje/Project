within ClaRa.Components.HeatExchangers;
model HEXvle2vle_L3_2ph_CU_simple "VLE 2 VLE | L3 | 2 phase at shell side | Cylinder shape | U-type | simple HT"
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

  //pure parallel current is assumed. however, the geometry is quite complex and the idea of moving boundary cell method with three zones at each side might be extended to get better results

  import SI = ClaRa.Basics.Units;
  // Extends from... ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  extends ClaRa.Basics.Icons.HEX01;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  outer ClaRa.SimCenter simCenter;
  record Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary=false;
    Basics.Units.HeatFlowRate Q_flow "Heat flow rate";
    Basics.Units.TemperatureDifference Delta_T_in "Fluid temperature at inlet T_1_in - T_2_in";
    Basics.Units.TemperatureDifference Delta_T_out "Fluid temperature at outlet T_1_out - T_2_out";
    Real effectivenes[3] if showExpertSummary "Effectivenes of HEX";
    Real kA[3](unit="W/K") if showExpertSummary "Overall heat resistance";
    Basics.Units.Length absLevel "Absolute filling level";
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
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_shell=simCenter.fluid1 "Medium to be used for shell side"
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
  parameter Basics.Units.Length length=10 "Length of the HEX"
    annotation (Dialog(tab="Shell Side", group="Geometry",groupImage="modelica://ClaRa/figures/ParameterDialog/HollowCylinderWithTubes.png"));
  parameter Basics.Units.Length diameter=3 "Diameter of HEX"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length z_in_shell=length/2 "Inlet position from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter SI.Length radius_flange=0.05 "Flange radius"
                                                        annotation (Dialog(tab="Shell Side", group="Geometry"));
      parameter SI.Length z_in_aux1=length/2 "Inlet position of auxilliary1 from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter SI.Length z_in_aux2=length/2 "Inlet position of auxilliary2 from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length z_out_shell=length/2 "Outlet position from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Integer N_baffle=0 "|Shell Side|Geometry|Number of baffles on shell side";
  parameter Basics.Units.Mass mass_struc=0 "Mass of inner structure elements, additional to the tubes itself"
    annotation (Dialog(tab="Shell Side", group="Geometry"));

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
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_tubes=simCenter.fluid1 "Medium to be used for tubes"
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
  parameter Basics.Units.Length diameter_i=0.048 "Inner diameter of horizontal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry",groupImage="modelica://ClaRa/figures/ParameterDialog/HollowBlockWithTubes_2.png"));
  parameter Basics.Units.Length diameter_o=0.05 "Outer diameter of horizontal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Basics.Units.Length length_tubes=10 "Length of the tubes (one pass)"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_tubes=1000 "Number of horizontal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Boolean staggeredAlignment=true "True, if the tubes are aligned staggeredly, false otherwise"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_passes=1 "Number of passes of the internal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_rows=integer(ceil(sqrt(N_tubes))*N_passes) "|Tubes|Geometry|Number of pipe rows in flow direction";
  parameter Basics.Units.Length Delta_z_par=2*diameter_o "|Tubes|Geometry|Distance between tubes parallel to flow direction (center to center)";
  parameter Basics.Units.Length Delta_z_ort=2*diameter_o "|Tubes|Geometry|Distance between tubes orthogonal to flow direction (center to center)";
  parameter Basics.Units.Length z_in_tubes=length/2 "Inlet position from bottom"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Basics.Units.Length z_out_tubes=length/2 "Outlet position from bottom"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Real CF_geo=1 "|Tubes|Geometry|Correction coefficient due to fins etc.";

  //________________________________ Tubes nominal parameter _____________________________________//
  parameter Basics.Units.MassFlowRate m_flow_nom_tubes=10 "Nominal mass flow on tube side"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter Basics.Units.Pressure p_nom_tubes=10 "Nominal pressure on tube side"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter Basics.Units.EnthalpyMassSpecific h_nom_tubes=10 "Nominal specific enthalpy on tube side"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter Basics.Units.HeatFlowRate Q_flow_nom=1e6 "Nominal heat flow rate"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));

  //________________________________ Tubes initialisation _______________________________________//
  parameter Basics.Units.EnthalpyMassSpecific h_start_tubes=1e5 "|Tubes|Initialisation|Start value of tube fluid specific enthalpy";
  parameter Basics.Units.Pressure p_start_tubes=1e5 "|Tubes|Initialisation|Start value of tube fluid pressure";
  parameter Basics.Choices.Init initTypeTubes=ClaRa.Basics.Choices.Init.noInit "|Tubes|Initialisation|Type of tube fluid initialisation";

  //*********************************** / WALL \ ***********************************//
  //________________________________ Wall fundamentals _______________________________//
  replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Aluminum
    constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder"
    annotation (choicesAllMatching=true, Dialog(tab="Wall", group=
          "Fundamental Definitions"));
  //________________________________ Wall initialisation _______________________________________//
  parameter Basics.Units.Temperature T_w_start[3]=ones(3)*293.15 "|Wall|Initialisation|Initial temperature at outer phase";
  parameter Basics.Choices.Init initTypeWall=ClaRa.Basics.Choices.Init.noInit "|Wall|Initialisation|Init option of Tube wall";

  //*********************************** / EXPERT Settings and Visualisation \ ***********************************//
  parameter Basics.Units.Time Tau_cond=0.3 "|Expert Settings|Inter-Phase Heat and Mass Transfer at Shell Side|Time constant of condensation";
  parameter Basics.Units.Time Tau_evap=0.03 "|Expert Settings|Inter-Phase Heat and Mass Transfer at Shell Side|Time constant of evaporation";
  parameter Basics.Units.CoefficientOfHeatTransfer alpha_ph=50000 "|Expert Settings|Zone Interaction at Shell Side|HTC of the phase border";
  parameter Basics.Units.Area A_phaseBorder=shell.geo.A_hor*100 "|Expert Settings|Inter-Phase Heat and Mass Transfer at Shell Side|Heat transfer area at phase border";
  parameter Real expHT_phases=0 "|Expert Settings|Inter-Phase Heat and Mass Transfer at Shell Side|Exponent for volume dependency on inter phase HT";
  parameter Real absorbInflow=1 "|Expert Settings|Inter-Phase Heat and Mass Transfer at Shell Side|Absorption of incoming mass flow to the zones 1: perfect in the allocated zone, 0: perfect according to steam quality";

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";

  ClaRa.Basics.Interfaces.FluidPortIn In2(Medium=medium_tubes)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
        iconTransformation(extent={{90,-70},{110,-50}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out2(Medium=medium_tubes)
    annotation (Placement(transformation(extent={{90,50},{110,70}}),
        iconTransformation(extent={{90,50},{110,70}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  ClaRa.Basics.Interfaces.FluidPortIn In1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-10,90},{10,110}}),
        iconTransformation(extent={{-10,90},{10,110}})));

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
    annotation (Placement(transformation(extent={{46,-12},{26,8}})));

  Basics.ControlVolumes.FluidVolumes.VolumeVLE_L3_TwoZonesNPort shell(
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
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.CU_Nports (
        z_out={z_out_shell},
        length=length,
        N_tubes=N_tubes,
        z_in={z_in_shell,z_in_aux1,z_in_aux2},
        staggeredAlignment=staggeredAlignment,
        Delta_z_par=Delta_z_par,
        Delta_z_ort=Delta_z_ort,
        diameter=diameter,
        final N_passes=N_passes,
        length_tubes=length_tubes,
        diameter_t=diameter_o,
        final flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        N_baffle=N_baffle,
        N_rows=N_rows,
        N_inlet=3),
    showExpertSummary=showExpertSummary,
    redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealSeparated (
        level_rel_start=level_rel_start,
        radius_flange=radius_flange,
        absorbInflow=absorbInflow),
    A_heat_ph=A_phaseBorder,
    exp_HT_phases=expHT_phases) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,60})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.ThickWall_L4 wall(
    redeclare replaceable model Material = WallMaterial,
    diameter_i=diameter_i,
    N_tubes=N_tubes,
    diameter_o=diameter_o,
    initChoice=initTypeWall,
    length=length_tubes*N_passes,
    N_rad=3,
    sizefunc=1,
    T_start=T_w_start) "{shell.heattransfer.alpha[2],shell.heattransfer.alpha[2],shell.heattransfer.alpha[1]}"
                                                                                              annotation (Placement(transformation(extent={{26,30},{46,50}})));

public
  Summary summary(outline(
      showExpertSummary=showExpertSummary,
      Q_flow=sum(shell.heat.Q_flow),
      Delta_T_in=shell.summary.inlet[1].T - tubes.summary.inlet.T,
      Delta_T_out=shell.summary.outlet[1].T - tubes.summary.outlet.T,
      effectivenes=wall.summary.effectivenes,
      kA=wall.summary.kA,
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
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,80})));
public
  Basics.Interfaces.EyeOut eye1 if showData annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={28,-98})));
protected
  Basics.Interfaces.EyeIn eye_int1
    annotation (Placement(transformation(extent={{27,-59},{29,-57}})));

public
  Basics.Interfaces.FluidPortIn       aux1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
  Basics.Interfaces.FluidPortIn       aux2(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}),
        iconTransformation(extent={{-110,50},{-90,70}})));
  Adapters.Scalar2VectorHeatPort reallocateHeatFlows(N=2, final equalityMode="Equal Temperatures")
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={26,60})));

equation
  assert(diameter_o > diameter_i,
    "Outer diameter of tubes must be greater than inner diameter");

initial equation
  //        wall.T=(tubes.bulk.T+shell.bulk.T)/2;

equation
  connect(tubes.inlet, In2) annotation (Line(
      points={{46,-2},{64,-2},{64,-60},{100,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tubes.outlet, Out2) annotation (Line(
      points={{26,-2},{64,-2},{64,60},{100,60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  //Vl = max(0.000001,((1-shell.bulk.q)*shell.M))/noEvent(max(shell.bulk.VLE.d_l,shell.bulk.d));

  connect(eye_int1, eye1) annotation (Line(
      points={{28,-58},{28,-98}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(eye_int2, eye2)
  annotation (Icon(graphics), Diagram(graphics));

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
      points={{0,100},{0,70}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shell.outlet[1], Out1) annotation (Line(
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
      points={{-100,60},{-54,60},{-54,72},{0,72},{0,70}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wall.innerPhase, tubes.heat) annotation (Line(
      points={{35.8,30.4},{35.8,8},{36,8}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(reallocateHeatFlows.heatScalar, wall.outerPhase) annotation (Line(
      points={{36,60},{36,50.1333}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(reallocateHeatFlows.heatVector, shell.heat) annotation (Line(
      points={{16,60},{10,60}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}),
                         graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={115,150,0},
          lineThickness=0.5,
          fillColor={217,94,0},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end HEXvle2vle_L3_2ph_CU_simple;
