within ClaRa.Components.HeatExchangers;
model HEXvle2vle_L3_1ph_BU_ntu "VLE 2 VLE | L3 | 1 phase on each side | Block shape | U-type| NTU Ansatz"
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
  extends ClaRa.Basics.Icons.HEX01;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  outer ClaRa.SimCenter simCenter;

  record Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary=false;
    Basics.Units.HeatFlowRate Q_flow "Heat flow rate";
    Basics.Units.TemperatureDifference Delta_T_in "Fluid temperature at inlet T_1_in - T_2_in";
    Basics.Units.TemperatureDifference Delta_T_out "Fluid temperature at outlet T_1_out - T_2_out";
    Real effectiveness if showExpertSummary "Effectivenes of HEX";
    Real kA(unit="W/K") if showExpertSummary "Overall heat resistance";
  end Outline;

  record Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
  end Summary;

  // General parameters and other user definable settings~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);
  parameter Basics.Units.Mass mass_struc=25000 "Mass of inner structure elements, additional to the tubes itself"
    annotation (Dialog(tab="General", group="Heat exchanger weight"));

  //*********************************** / SHELL SIDE \ ***********************************//
  //________________________________ Shell fundamentals _______________________________//
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_shell=simCenter.fluid1 "Medium to be used  for flow 1"
                                    annotation (Dialog(tab="Shell Side", group=
          "Fundamental Definitions"), choicesAllMatching);

  replaceable model HeatTransfer_Shell =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellType_L2 "Heat transfer model at shell side"
                                        annotation (Dialog(tab="Shell Side",
        group="Fundamental Definitions"), choicesAllMatching);

  replaceable model PressureLossShell =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2 "Pressure loss model at shell side"
                                        annotation (Dialog(tab="Shell Side",
        group="Fundamental Definitions"), choicesAllMatching);

  //________________________________ Shell geometry _______________________________//
  parameter Basics.Units.Length length=1 "Length of the HEX"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length height=7 "Height of HEX"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length width=1 "Width of HEX"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length z_in_shell=height "Inlet position from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length z_out_shell=0.1 "Outlet position from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  //   parameter Basics.Choices.GeometryOrientation      mainOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical
  //     "Orientation of the component"                                                                                                     annotation(Dialog(tab="Shell Side", group="Geometry"));

  //________________________________ Shell nominal parameter _____________________________________//
  parameter Basics.Units.MassFlowRate m_nom_shell=40 "Nominal mass flow on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter Basics.Units.Pressure p_nom_shell=35e5 "Nominal pressure on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter Basics.Units.EnthalpyMassSpecific h_nom_shell=3500e3 "Nominal specific enthalpy on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));

  //________________________________ Shell initialisation  _______________________________________//
  parameter Basics.Units.EnthalpyMassSpecific h_start_shell=100e3 "Start value of sytsem specific enthalpy"
    annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter Basics.Units.Pressure p_start_shell=1e5 "Start value of sytsem pressure"
    annotation (Dialog(tab="Shell Side", group="Initialisation"));

  //*********************************** / TUBE SIDE \ ***********************************//
  //________________________________ Tubes fundamentals _______________________________//
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_tubes=simCenter.fluid1 "Medium to be used for flow 2"
                                   annotation (Dialog(tab="Tubes",group=
          "Fundamental Definitions"), choicesAllMatching);

  replaceable model HeatTransferTubes =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeType_L2 "Heat transfer mode at the tubes side"
                                           annotation (Dialog(tab="Tubes",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLossTubes =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2 "Pressure loss model at the tubes side"
                                            annotation (Dialog(tab="Tubes",
        group="Fundamental Definitions"), choicesAllMatching);

  //________________________________ Tubes geometry _______________________________//
  parameter Basics.Units.Length diameter_i=0.019 "Inner diameter of horizontal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry",groupImage="modelica://ClaRa/figures/ParameterDialog/HollowBlockWithTubes_2.png"));
  parameter Basics.Units.Length diameter_o=0.027 "Outer diameter of horizontal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Boolean staggeredAlignment=true "True, if the tubes are aligned staggeredly, false otherwise"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_tubes=210 "Number of horizontal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_passes=integer(floor(230/(3.14159*diameter_o*width*N_tubes))) "Number of passes of the internal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_rows(
    min=N_passes,
    max=N_tubes) = N_passes "Number of pipe rows in flow direction"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Boolean parallelTubes=false "True, if tubes are parallel to main orientation, else false"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Basics.Units.Length z_in_tubes=height "Inlet position from bottom"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Basics.Units.Length z_out_tubes=0.1 "Outlet position from bottom"
    annotation (Dialog(tab="Tubes", group="Geometry"));

  //________________________________ Tubes nominal parameter _____________________________________//
  parameter Basics.Units.MassFlowRate m_nom_tubes=400 "Nominal mass flow on side 2"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter Basics.Units.Pressure p_nom_tubes=400e5 "Nominal pressure on side 2"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter Basics.Units.EnthalpyMassSpecific h_nom_tubes=10 "Nominal specific enthalpy on side 2"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter Basics.Units.HeatFlowRate Q_flow_nom=1e6 "Nominal heat flow rate"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));

  //________________________________ Tubes initialisation _______________________________________//
  parameter Basics.Choices.Init initTypeShell=ClaRa.Basics.Choices.Init.noInit "Type of initialisation"
    annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter Basics.Units.EnthalpyMassSpecific h_start_tubes=100e3 "Start value of sytsem specific enthalpy"
    annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter Basics.Units.Pressure p_start_tubes=1e5 "Start value of sytsem pressure"
    annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter Basics.Choices.Init initTypeTubes=ClaRa.Basics.Choices.Init.noInit "Type of initialisation"
    annotation (Dialog(tab="Tubes", group="Initialisation"));

  //*********************************** / WALL \ ***********************************//
  //________________________________ Wall fundamentals _______________________________//
  replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Aluminum
    constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder"
    annotation (choicesAllMatching=true, Dialog(tab="Wall", group=
          "Fundamental Definitions"));
  parameter Basics.Choices.Init initWall=ClaRa.Basics.Choices.Init.noInit "|Wall|Initialisation|Initialisation option for wall";
  parameter Basics.Units.Temperature T_w_i_start=293.15 "|Wall|Initialisation|Initial wall temperature at inner side";
  parameter Basics.Units.Temperature T_w_o_start=293.15 "|Wall|Initialisation|Initial wall temperature at shell side";

  //*********************************** / EXPERT Settings and Visualisation \ ***********************************//
  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";

  ClaRa.Basics.Interfaces.FluidPortIn In2(Medium=medium_tubes)
    annotation (Placement(transformation(extent={{90,50},{110,70}}),
        iconTransformation(extent={{90,50},{110,70}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out2(Medium=medium_tubes)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
        iconTransformation(extent={{90,-70},{110,-50}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  ClaRa.Basics.Interfaces.FluidPortIn In1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-10,88},{10,108}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.NTU_L2 wall(
    length=length,
    redeclare replaceable model Material = WallMaterial,
    N_p=N_passes,
    radius_i=diameter_i/2,
    radius_o=diameter_o/2,
    T_i_in=tubes.fluidIn.T,
    T_a_in=shell.fluidIn.T,
    m_flow_i=tubes.inlet.m_flow,
    m_flow_a=shell.inlet.m_flow,
    alpha_i=tubes.heattransfer.alpha,
    alpha_o=shell.heattransfer.alpha,
    mass_struc=mass_struc,
    N_t=N_tubes,
    redeclare model HeatExchangerType =
        ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CounterFlow,
    cp_mean_i=(tubes.fluidIn.cp + tubes.fluidOut.cp)/2,
    cp_mean_a=(shell.fluidIn.cp + shell.fluidOut.cp)/2,
    T_w_i_start=T_w_i_start,
    T_w_a_start=T_w_o_start,
    initChoice=initWall) annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 tubes(
    medium=medium_tubes,
    useHomotopy=useHomotopy,
    h_start=h_start_tubes,
    p_start=p_start_tubes,
    initType=initTypeTubes,
    redeclare model HeatTransfer = HeatTransferTubes,
    redeclare model PressureLoss = PressureLossTubes,
    redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    m_flow_nom=m_nom_tubes,
    p_nom=p_nom_tubes,
    h_nom=h_nom_tubes,
    showExpertSummary=showExpertSummary,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        z_in={z_in_tubes},
        z_out={z_out_tubes},
        diameter=diameter_i,
        N_tubes=N_tubes,
        N_passes=N_passes,
        length=if parallelTubes == true then height else length))
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={70,0})));

  Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 shell(
    medium=medium_shell,
    redeclare model HeatTransfer = HeatTransfer_Shell,
    redeclare model PressureLoss = PressureLossShell,
    useHomotopy=useHomotopy,
    h_start=h_start_shell,
    p_start=p_start_shell,
    initType=initTypeShell,
    m_flow_nom=m_nom_shell,
    p_nom=p_nom_shell,
    h_nom=h_nom_shell,
    redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    showExpertSummary=showExpertSummary,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubes (
        z_out={z_out_shell},
        height=height,
        width=width,
        length=length,
        diameter_t=
            diameter_o,
        N_tubes=N_tubes,
        N_passes=N_passes,
        parallelTubes=parallelTubes,
        z_in={z_in_shell},
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        N_rows=N_rows),
    heatSurfaceAlloc=2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,56})));

  Summary summary(outline(
      showExpertSummary=showExpertSummary,
      Q_flow=shell.heat.Q_flow,
      Delta_T_in=shell.summary.inlet.T - tubes.summary.inlet.T,
      Delta_T_out=shell.summary.outlet.T - tubes.summary.outlet.T,
      effectiveness=wall.effectiveness,
      kA=wall.kA)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-92})));

  Basics.Interfaces.EyeOut eye2 if showData annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-100,-42}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-100,-42})));
protected
  Basics.Interfaces.EyeIn eye_int2
    annotation (Placement(transformation(extent={{-51,-43},{-49,-41}})));
public
  Basics.Interfaces.EyeOut eye1 if showData annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={28,-98}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={28,-98})));
protected
  Basics.Interfaces.EyeIn eye_int1
    annotation (Placement(transformation(extent={{27,-59},{29,-57}})));

equation
  assert(diameter_o > diameter_i,
    "Outer diameter of tubes must be greater than inner diameter");

  eye_int1.m_flow = -Out1.m_flow;
  eye_int1.T = shell.summary.outlet.T - 273.15;
  eye_int1.s = shell.fluidOut.s/1e3;
  eye_int1.p = shell.outlet.p/1e5;
  eye_int1.h = shell.summary.outlet.h/1e3;
  eye_int2.m_flow = -Out2.m_flow;
  eye_int2.T = tubes.summary.outlet.T - 273.15;
  eye_int2.s = tubes.fluidOut.s/1e3;
  eye_int2.p = tubes.outlet.p/1e5;
  eye_int2.h = tubes.summary.outlet.h/1e3;
initial equation
  //        wall.T=(Tubes.bulk.T+shell.bulk.T)/2;

equation
  connect(tubes.inlet, In2) annotation (Line(
      points={{70,10},{70,60},{100,60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tubes.outlet, Out2) annotation (Line(
      points={{70,-10},{70,-60},{100,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tubes.heat, wall.innerPhase) annotation (Line(
      points={{60,6.66134e-016},{30.5,6.66134e-016},{30.5,21},{30,21}},
      color={127,0,0},
      smooth=Smooth.None));
  connect(shell.inlet, In1) annotation (Line(
      points={{1.83697e-015,66},{1.83697e-015,74},{0,74},{0,98}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shell.heat, wall.outerPhase) annotation (Line(
      points={{10,56},{30,56},{30,39}},
      color={127,0,0},
      smooth=Smooth.None));
  connect(shell.outlet, Out1) annotation (Line(
      points={{-1.83697e-015,46},{0,46},{0,-100}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(eye_int2, eye2) annotation (Line(
      points={{-50,-42},{-100,-42}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(eye_int1, eye1) annotation (Line(
      points={{28,-58},{28,-98}},
      color={190,190,190},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={Text(
          extent={{-86,92},{86,52}},
          lineColor={27,36,42},
          textString="NTU")}),Diagram(graphics));
end HEXvle2vle_L3_1ph_BU_ntu;
