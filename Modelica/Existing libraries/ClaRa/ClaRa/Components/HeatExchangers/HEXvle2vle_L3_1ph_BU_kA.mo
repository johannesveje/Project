within ClaRa.Components.HeatExchangers;
model HEXvle2vle_L3_1ph_BU_kA " VLE 2 VLE | L3 | 1 phase on each side | Block shape | U-type| effective U*S"
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
  extends ClaRa.Basics.Icons.HEX01;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  outer ClaRa.SimCenter simCenter;
  record Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary=false;
    ClaRa.Basics.Units.HeatFlowRate
                    Q_flow "Heat flow rate";
    ClaRa.Basics.Units.TemperatureDifference
                             Delta_T_in "Fluid temperature at inlet T_1_in - T_2_in";
    ClaRa.Basics.Units.TemperatureDifference
                             Delta_T_out "Fluid temperature at outlet T_1_out - T_2_out";
    Real effectiveness if showExpertSummary "Effectivenes of HEX";
    Real kA(unit="W/K") if showExpertSummary "Overall heat resistance";
  end Outline;

  record Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
  end Summary;

  //*********************************** / SHELL SIDE \ ***********************************//
  //________________________________ Shell fundamentals _______________________________//
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_shell=simCenter.fluid1 "Medium to be used  for flow 1"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  replaceable model PressureLossShell =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.ShellType_L2 "Pressure loss model at shell side"
                                        annotation (Dialog(tab="Shell Side",
        group="Fundamental Definitions"), choicesAllMatching);
  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  //________________________________ Shell geometry _______________________________//
  parameter ClaRa.Basics.Units.Volume
                      volume_shell=1 "|Heat Exchanger Definition|Volume of the shell side";
  parameter Basics.Units.Length z_in_shell=1 "Inlet position from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length z_out_shell=1 "Outlet position from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));

  //________________________________ Shell nominal parameter _____________________________________//
  parameter ClaRa.Basics.Units.Mass
                    mass_struc=0 "Mass of inner structure elements, additional to the tubes itself"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.MassFlowRate
                            m_flow_nom_shell=10 "Nominal mass flow on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter ClaRa.Basics.Units.Pressure
                        p_nom_shell=10 "Nominal pressure on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter SI.SpecificEnthalpy h_nom_shell=10 "Nominal specific enthalpy on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));

  //________________________________ Shell initialisation  _______________________________________//
  parameter SI.SpecificEnthalpy h_start_shell=1e5 "Start value of sytsem specific enthalpy"
    annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure
                        p_start_shell=1e5 "Start value of sytsem pressure"
    annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter Basics.Choices.Init initTypeShell=ClaRa.Basics.Choices.Init.noInit "Type of initialisation"
    annotation (Dialog(tab="Shell Side", group="Initialisation"));

  //*********************************** / TUBE SIDE \ ***********************************//
  //________________________________ Tubes fundamentals _______________________________//

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_tubes=simCenter.fluid1 "Medium to be used for flow 2"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  replaceable model PressureLossTubes =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.TubeType_L2 "Pressure loss model at the tubes side"
                                            annotation (Dialog(tab="Tubes",
        group="Geometry"), choicesAllMatching);

  //________________________________ Tubes geometry _______________________________//
  parameter ClaRa.Basics.Units.Volume
                      volume_tubes=1 "|Heat Exchanger Definition|Volume of the tubes";
  parameter Basics.Units.Length z_in_tubes=1 "Inlet position from bottom"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Basics.Units.Length z_out_tubes=1 "Outlet position from bottom"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  //________________________________ Tubes nominal parameter _____________________________________//
  parameter ClaRa.Basics.Units.MassFlowRate
                            m_flow_nom_tubes=10 "Nominal mass flow on tube side"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter ClaRa.Basics.Units.Pressure
                        p_nom_tubes=10 "Nominal pressure on tube side"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter SI.SpecificEnthalpy h_nom_tubes=10 "Nominal specific enthalpy on tube side"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter ClaRa.Basics.Units.HeatFlowRate
                            Q_flow_nom=1e6 "Nominal heat flow rate"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));

  //________________________________ Tubes initialisation _______________________________________//
  parameter SI.SpecificEnthalpy h_start_tubes=1e5 "Start value of sytsem specific enthalpy at tube side"
    annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure
                        p_start_tubes=1e5 "Start value of sytsem pressure at tube side"
    annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter Basics.Choices.Init initTypeTubes=ClaRa.Basics.Choices.Init.noInit "Type of initialisation at tube side"
    annotation (Dialog(tab="Tubes", group="Initialisation"));

  //*********************************** / WALL \ ***********************************//
  //________________________________ Wall fundamentals _______________________________//
  replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Aluminum
    constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder"
    annotation (choicesAllMatching=true, Dialog(tab="Wall", group=
          "Fundamental Definitions"));

  //________________________________ Wall initialisation _______________________________________//
  parameter Basics.Units.Temperature T_w_i_start=293.15 "Initial temperature at inner phase"
    annotation (Dialog(tab="Wall", group="Initialisation"));
  parameter Basics.Units.Temperature T_w_o_start=293.15 "Initial temperature at outer phase"
    annotation (Dialog(tab="Wall", group="Initialisation"));
  parameter Basics.Choices.Init initWall=ClaRa.Basics.Choices.Init.noInit "Initialisation option"
    annotation (Dialog(tab="Wall", group="Initialisation"));

  // General parameters and other user definable settings~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Real kA(unit="W/K")=50000 "|Heat Exchanger Definition|The product U*S - nominal value";
  parameter Real CL_kA_mflow_tubes[:, 2]=[0,0;0.4, 0.5; 0.5, 0.75; 0.75, 0.95;
      1, 1] "|Heat Exchanger Definition|Characteristic line kA = f(m_flow/m_flow_nom)";
  replaceable model HeatExchangerType =
      ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CounterFlow
    constrainedby ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.GeneralHeatExchanger "|Heat Exchanger Definition|Flow regime"
                                             annotation (choicesAllMatching);
//   parameter Real CF_geo=1
//     "|Heat Exchanger Definition|Correction coefficient due to fins etc.";

  //*********************************** / EXPERT Settings and Visualisation \ ***********************************//

  parameter Boolean showExpertSummary=false "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";

  ClaRa.Basics.Interfaces.FluidPortIn In2(Medium=medium_tubes)
    annotation (Placement(transformation(extent={{90,52},{110,72}}),
        iconTransformation(extent={{90,52},{110,72}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out2(Medium=medium_tubes)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
        iconTransformation(extent={{90,-70},{110,-50}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  ClaRa.Basics.Interfaces.FluidPortIn In1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-10,88},{10,108}})));

  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 tubes(
    medium=medium_tubes,
    p_nom=p_nom_tubes,
    h_nom=h_nom_tubes,
    m_flow_nom=m_flow_nom_tubes,
    useHomotopy=useHomotopy,
    h_start=h_start_tubes,
    p_start=p_start_tubes,
    initType=initTypeTubes,
    redeclare model PressureLoss = PressureLossTubes,
    redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2,
    showExpertSummary=showExpertSummary,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry (
        volume=volume_tubes,
        z_in={z_in_tubes},
        z_out={z_out_tubes}))
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={70,0})));

  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 shell(
    medium=medium_shell,
    p_nom=p_nom_shell,
    h_nom=h_nom_shell,
    redeclare model PressureLoss = PressureLossShell,
    m_flow_nom=m_flow_nom_shell,
    useHomotopy=useHomotopy,
    h_start=h_start_shell,
    p_start=p_start_shell,
    initType=initTypeShell,
    redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2,
    showExpertSummary=showExpertSummary,
    heatSurfaceAlloc=1,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry (
        volume=volume_shell,
        z_in={z_in_shell},
        z_out={z_out_shell}))
                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,56})));

  Basics.ControlVolumes.SolidVolumes.NTU_L2_effectiveResistance wall(
    mass_struc=mass_struc,
    T_i_in=tubes.fluidIn.T,
    T_a_in=shell.fluidIn.T,
    m_flow_i=tubes.inlet.m_flow,
    m_flow_a=shell.inlet.m_flow,
    cp_mean_i=(tubes.fluidIn.cp + tubes.fluidOut.cp)/2,
    cp_mean_a=(shell.fluidIn.cp + shell.fluidOut.cp)/2,
    kA=kA,
    redeclare model Material = WallMaterial,
    CL_kA_mflow_tubes=CL_kA_mflow_tubes,
    redeclare model HeatExchangerType = HeatExchangerType,
    T_w_i_start=T_w_i_start,
    T_w_a_start=T_w_o_start,
    initChoice=initWall,
    m_flow_i_nom=m_flow_nom_tubes) annotation (Placement(transformation(extent={{22,22},{42,42}})));

  Summary summary(outline(
      showExpertSummary=showExpertSummary,
      Q_flow=shell.heat.Q_flow,
      Delta_T_in=shell.summary.inlet.T - tubes.summary.inlet.T,
      Delta_T_out=shell.summary.outlet.T - tubes.summary.outlet.T,
      effectiveness=wall.effectiveness,
      kA=wall.kA*wall.partLoad_kA.y[1])) annotation (Placement(transformation(
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
protected
  Basics.Interfaces.EyeIn eye_int1
    annotation (Placement(transformation(extent={{27,-59},{29,-57}})));
public
  Basics.Interfaces.EyeOut eye1 if showData annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={28,-98}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={28,-98})));
initial equation
  //        wall.T=(tubes.bulk.T+shell.bulk.T)/2;

equation
eye_int1.m_flow=-shell.outlet.m_flow;
  eye_int1.T=shell.summary.outlet.T-273.15;
  eye_int1.s=shell.fluidOut.s/1000;
  eye_int1.h=shell.summary.outlet.h/1000;
  eye_int1.p=shell.summary.outlet.p/100000;

eye_int2.m_flow=-tubes.outlet.m_flow;
  eye_int2.T=tubes.summary.outlet.T-273.15;
  eye_int2.s=tubes.fluidOut.s/1000;
  eye_int2.h=tubes.summary.outlet.h/1000;
  eye_int2.p=tubes.summary.outlet.p/100000;
  connect(tubes.inlet, In2) annotation (Line(
      points={{70,10},{70,62},{100,62}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tubes.outlet, Out2) annotation (Line(
      points={{70,-10},{70,-60},{100,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shell.inlet, In1) annotation (Line(
      points={{1.83697e-015,66},{1.83697e-015,74},{0,74},{0,98}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shell.outlet, Out1) annotation (Line(
      points={{-1.83697e-015,46},{0,46},{0,-100}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wall.innerPhase, tubes.heat) annotation (Line(
      points={{32,23},{32,4.44089e-016},{60,4.44089e-016}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wall.outerPhase, shell.heat) annotation (Line(
      points={{32,41},{32,56},{10,56}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(eye2, eye_int2) annotation (Line(
      points={{-100,-42},{-50,-42}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(eye1, eye_int1) annotation (Line(
      points={{28,-98},{28,-58}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={Text(
          extent={{-90,94},{82,54}},
          lineColor={27,36,42},
          textString="NTU")}),Diagram(graphics));
end HEXvle2vle_L3_1ph_BU_kA;
