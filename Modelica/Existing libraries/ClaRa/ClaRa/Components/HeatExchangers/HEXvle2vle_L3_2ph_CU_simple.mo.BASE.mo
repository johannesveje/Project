within ClaRa.Components.HeatExchangers;
model HEXvle2vle_L3_2ph_CU_simple
  "VLE 2 VLE | L3 | 2 phase at shell side | Cylinder shape | U-type | simple HT"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 0.1 alpha                        //
  //                                                                           //
  // Licensed by the DYNCAP research team under Modelica License 2.            //
  // Copyright © 2013, DYNCAP research team.                                   //
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
  extends ClaRa.Basics.Icons.HeatExchanger_1con;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  outer ClaRa.ModelProperties modelProperties;
  record Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary=false;
    Basics.Units.HeatFlowRate Q_flow "Heat flow rate";
    Basics.Units.TemperatureDifference Delta_T_in
      "Fluid temperature at inlet T_1_in - T_2_in";
    Basics.Units.TemperatureDifference Delta_T_out
      "Fluid temperature at outlet T_1_out - T_2_out";
    Real effectivenes[3] if showExpertSummary "Effectivenes of HEX";
    Real UA[3](unit="W/K") if showExpertSummary "Overall heat resistance";
    Basics.Units.Length absLevel "Absolute filling level";
    Real relLevel "relative filling level";
  end Outline;

  record Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
  end Summary;
  // Parameters and other user definable settings~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Boolean useHomotopy=modelProperties.useHomotopy
    "True, if homotopy method is used during initialisation"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  //*********************************** / SHELL SIDE \ ***********************************//
  //________________________________ Shell fundamentals _______________________________//
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_shell=modelProperties.fluid1
    "Medium to be used for shell side" annotation (choices(
      choice=modelProperties.fluid1
        "First fluid defined in global modelProperties",
      choice=modelProperties.fluid2
        "Second fluid defined in global modelProperties",
      choice=modelProperties.fluid3
        "Third fluid defined in global modelProperties"), Dialog(tab=
          "Shell Side", group="Fundamental Definitions"));
  replaceable model HeatTransfer_Shell =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HTC_const_L3_simpleICom
    constrainedby
    ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HTC_const_L3_simpleICom
    "Heat transfer model at shell side" annotation (Dialog(tab="Shell Side",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLossShell =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.LinearPressureLoss_3
    constrainedby
    ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.GenericPressureLoss_L3
    "Pressure loss model at shell side" annotation (Dialog(tab="Shell Side",
        group="Fundamental Definitions"), choicesAllMatching);

  //________________________________ Shell geometry _______________________________//
  parameter Basics.Units.Length L=10 "Length of the HEX"
    annotation (Dialog(tab="Shell Side", group="Geometry",groupImage="modelica://ClaRa/figures/HollowCylinderWithTubes.png"));
  parameter Basics.Units.Length D=3 "Diameter of HEX"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length z_in_shell=L/2 "Inlet position from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
      parameter SI.Length z_in_aux1=L/2
    "Inlet position of auxilliary1 from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter SI.Length z_in_aux2=L/2 "Inlet position of auxilliary2 from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length z_out_shell=L/2 "Outlet position from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Integer N_baffle=0
    "|Shell Side|Geometry|Number of baffles on shell side";
  parameter Basics.Units.Mass mass_struc=0
    "Mass of inner structure elements, additional to the tubes itself"
    annotation (Dialog(tab="Shell Side", group="Geometry"));

  //________________________________ Shell nominal parameter _____________________________________//
  parameter Basics.Units.MassFlowRate m_flow_nom_shell=10
    "Nominal mass flow on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter Basics.Units.Pressure p_nom_shell=10
    "Nominal pressure on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter Basics.Units.EnthalpyMassSpecific h_nom_shell=100e3
    "Nominal specific enthalpy on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));

  //________________________________ Shell initialisation  _______________________________________//

    parameter SI.EnthalpyMassSpecific h_liq_start=-10 +
      TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium_shell,
      p_start_shell)
    "|Shell Side|Initialisation|Start value of liquid specific enthalpy";
  parameter SI.EnthalpyMassSpecific h_vap_start=+10 +
      TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(medium_shell, p_start_shell)
    "|Shell Side|Initialisation|Start value of vapour specific enthalpy";
  parameter Basics.Units.Pressure p_start_shell=1e5
    "Start value of shell fluid pressure"
    annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter Real y_start=0.5
    "|Shell Side|Initialisation|Start value for relative filling Level";
  parameter Basics.Choices.Init initTypeShell=ClaRa.Basics.Choices.Init.noInit
    "Type of shell fluid initialisation"
    annotation (Dialog(tab="Shell Side", group="Initialisation"));

  //*********************************** / TUBE SIDE \ ***********************************//
  //________________________________ Tubes fundamentals _______________________________//
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_tubes=modelProperties.fluid1
    "Medium to be used for tubes" annotation (choices(
      choice=modelProperties.fluid1
        "First fluid defined in global modelProperties",
      choice=modelProperties.fluid2
        "Second fluid defined in global modelProperties",
      choice=modelProperties.fluid3
        "Third fluid defined in global modelProperties"), Dialog(tab="Tubes",
        group="Fundamental Definitions"));
  replaceable model HeatTransferTubes =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLineHTC
    constrainedby
    ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeType
    "Heat transfer mode at the tubes side" annotation (Dialog(tab="Tubes",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLossTubes =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction
    constrainedby
    ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.TubeType_L2
    "Pressure loss model at the tubes side" annotation (Dialog(tab="Tubes",
        group="Fundamental Definitions"), choicesAllMatching);

  //________________________________ Tubes geometry _______________________________//
  parameter Basics.Units.Length d_i=0.048 "Inner diameter of horizontal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry",groupImage="modelica://ClaRa/figures/HollowBlockWithTubes_2.png"));
  parameter Basics.Units.Length d_a=0.05 "Outer diameter of horizontal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Basics.Units.Length L_tubes=10 "Length of the tubes (one pass)"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_tubes=1000 "Number of horizontal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Boolean staggeredAlignment=true
    "True, if the tubes are aligned staggeredly, false otherwise"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer Np_tubes=1 "Number of passes of the internal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_rows=integer(ceil(sqrt(N_tubes))*Np_tubes)
    "|Tubes|Geometry|Number of pipe rows in flow direction";
  parameter Basics.Units.Length Delta_z_par=2*d_a
    "|Tubes|Geometry|Distance between tubes parallel to flow direction (center to center)";
  parameter Basics.Units.Length Delta_z_ort=2*d_a
    "|Tubes|Geometry|Distance between tubes orthogonal to flow direction (center to center)";
  parameter Basics.Units.Length z_in_tubes=L/2 "Inlet position from bottom"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Basics.Units.Length z_out_tubes=L/2 "Outlet position from bottom"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Real CF_geo=1
    "|Tubes|Geometry|Correction coefficient due to fins etc.";

  //________________________________ Tubes nominal parameter _____________________________________//
  parameter Basics.Units.MassFlowRate m_flow_nom_tubes=10
    "Nominal mass flow on tube side"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter Basics.Units.Pressure p_nom_tubes=10
    "Nominal pressure on tube side"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter Basics.Units.EnthalpyMassSpecific h_nom_tubes=10
    "Nominal specific enthalpy on tube side"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter Basics.Units.HeatFlowRate Q_flow_nom=1e6 "Nominal heat flow rate"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));

  //________________________________ Tubes initialisation _______________________________________//
  parameter Basics.Units.EnthalpyMassSpecific h_start_tubes=1e5
    "|Tubes|Initialisation|Start value of tube fluid specific enthalpy";
  parameter Basics.Units.Pressure p_start_tubes=1e5
    "|Tubes|Initialisation|Start value of tube fluid pressure";
  parameter Basics.Choices.Init initTypeTubes=ClaRa.Basics.Choices.Init.noInit
    "|Tubes|Initialisation|Type of tube fluid initialisation";

  //*********************************** / WALL \ ***********************************//
  //________________________________ Wall fundamentals _______________________________//
  replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Aluminum
    constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder"
    annotation (choicesAllMatching=true, Dialog(tab="Wall", group=
          "Fundamental Definitions"));
  //________________________________ Wall initialisation _______________________________________//
  parameter Basics.Units.Temperature T_w_start[3]=ones(3)*293.15
    "|Wall|Initialisation|Initial temperature at outer phase";
  parameter Basics.Choices.Init initTypeWall=ClaRa.Basics.Choices.Init.noInit
    "|Wall|Initialisation|Init option of Tube wall";

  //*********************************** / EXPERT Settings and Visualisation \ ***********************************//
  parameter Basics.Units.Time tau_cond=0.3
    "|Expert Settings|Inter-Phase Heat and Mass Transfer at Shell Side|Time constant of condensation";
  parameter Basics.Units.Time tau_evap=0.03
    "|Expert Settings|Inter-Phase Heat and Mass Transfer at Shell Side|Time constant of evaporation";
  parameter Basics.Units.CoefficientOfHeatTransfer alpha_ph=50000
    "|Expert Settings|Inter-Phase Heat and Mass Transfer at Shell Side|HTC of the phase border";
  parameter Boolean showExpertSummary=modelProperties.showExpertSummary
    "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true
    "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";

  ClaRa.Basics.Interfaces.FluidPortIn In2(Medium=medium_tubes)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out2(Medium=medium_tubes)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
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
        z_in=z_in_tubes,
        z_out=z_out_tubes,
        D=d_i,
        Nt=N_tubes,
        orientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        Np=Np_tubes,
        L=L_tubes),
    showExpertSummary=showExpertSummary)
    annotation (Placement(transformation(extent={{48,-10},{28,10}})));

  Basics.ControlVolumes.FluidVolumes.VolumeVLE_L3_TwoZonesNPort shell(
    medium=medium_shell,
    p_nom=p_nom_shell,
    redeclare model HeatTransfer = HeatTransfer_Shell,
    redeclare model PressureLoss = PressureLossShell,
    m_flow_nom=m_flow_nom_shell,
    useHomotopy=useHomotopy,
    p_start=p_start_shell,
    initType=initTypeShell,
    y_start=y_start,
    redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealSeparatingLevelDependent_flex
        (y_start=y_start),
    tau_cond=tau_cond,
    tau_evap=tau_evap,
    alpha_ph=alpha_ph,
    h_liq_start=h_liq_start,
    h_vap_start=h_vap_start,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.CU_Nports (
        z_out={z_out_shell},
        L=L,
        Nt=N_tubes,
        z_in={z_in_shell,z_in_aux1,z_in_aux2},
        staggeredAlignment=staggeredAlignment,
        Delta_z_par=Delta_z_par,
        Delta_z_ort=Delta_z_ort,
        D=D,
        final Np=Np_tubes,
        L_tubes=L_tubes,
        d_t=d_a,
        final flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        N_baffle=N_baffle,
        N_rows=N_rows,
        N_inlet=3),
    showExpertSummary=showExpertSummary)
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,60})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.ThickWall_L4 wall(
    redeclare replaceable model Material = WallMaterial,
    d_i=d_i,
    Nt=N_tubes,
    d_a=d_a,
    initChoice=initTypeWall,
    L=L_tubes*Np_tubes,
    n_rad=3,
    sizefunc=1,
    T_start=T_w_start)
    "{shell.heattransfer.kc[2],shell.heattransfer.kc[2],shell.heattransfer.kc[1]}"
    annotation (Placement(transformation(extent={{26,30},{46,50}})));

public
  Summary summary(outline(
      showExpertSummary=showExpertSummary,
      Q_flow=sum(shell.heat.Q_flow),
      Delta_T_in=shell.summary.inlet[1].T - tubes.summary.inlet.T,
      Delta_T_out=shell.summary.outlet[1].T - tubes.summary.outlet.T,
      effectivenes=wall.summary.effectivenes,
      UA=wall.summary.UA,
      absLevel=shell.phaseBorder.absLevel,
      relLevel=shell.phaseBorder.relLevel)) annotation (Placement(
        transformation(
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
        origin={-100,-42})));
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
    annotation (Placement(transformation(extent={{-110,46},{-90,66}})));
equation
  assert(d_a > d_i,
    "Outer diameter of tubes must be greater than inner diameter");

initial equation
  //        wall.T=(tubes.bulk.T+shell.bulk.T)/2;

equation
  connect(tubes.inlet, In2) annotation (Line(
      points={{48,0},{100,0}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tubes.outlet, Out2) annotation (Line(
      points={{28,0},{-100,0}},
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
      points={{0,98},{0,70}},
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
      points={{-100,56},{-54,56},{-54,72},{0,72},{0,70}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wall.innerPhase, tubes.heat) annotation (Line(
      points={{38,36.6},{38,9},{31,9}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wall.outerPhase, shell.heat[1]) annotation (Line(
      points={{28.6,47.6},{28.6,53},{8.5,53}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wall.outerPhase, shell.heat[2]) annotation (Line(
      points={{28.6,47.6},{22,47.6},{22,53},{9.5,53}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={115,150,0},
          lineThickness=0.5,
          fillColor={217,94,0},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end HEXvle2vle_L3_2ph_CU_simple;
