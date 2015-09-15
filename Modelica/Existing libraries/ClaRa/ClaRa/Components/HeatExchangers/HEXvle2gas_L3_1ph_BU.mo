within ClaRa.Components.HeatExchangers;
model HEXvle2gas_L3_1ph_BU "VLE 2 gas | L3 | 1 phase on each side | Block shape | U-type | NTU ansatz"
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

  // Parameters and other user definable settings~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium2=simCenter.fluid1 "Medium to be used  for flow 1"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  parameter TILMedia.GasTypes.BaseGas medium1=simCenter.flueGasModel "Medium to be used for flow 2"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Aluminum
    constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder"
    annotation (choicesAllMatching=true, Dialog(group="Fundamental Definitions"));

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
  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  parameter ClaRa.Basics.Units.Length
                      length=10 "Length of the HEX"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
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
                      z_out_shell=length/2 "Outlet position from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Choices.GeometryOrientation mainOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical "Orientation of the component"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Mass
                    mass_struc=0 "Mass of inner structure elements, additional to the tubes itself"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.MassFlowRate
                            m_nom1=10 "Nominal mass flow on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter ClaRa.Basics.Units.Pressure
                        p_nom1=10 "Nominal pressure on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter SI.SpecificEnthalpy h_nom1=10 "Nominal specific enthalpy on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter ClaRa.Basics.Units.Temperature
                           T_start_shell=273.15 + 100 "Start value of system Temperature"
    annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure
                        p_start_shell=1e5 "Start value of sytsem pressure"
    annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter Basics.Choices.Init initTypeShell=ClaRa.Basics.Choices.Init.noInit "Type of initialisation"
    annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction
                            xi_shell_start[medium1.nc - 1]=zeros(medium1.nc - 1) "|Shell Side|Initialisation|Start value of shell mass fraction";
  replaceable model HeatTransferTubes =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeType_L2 "Heat transfer mode at the tubes side"
                                           annotation (Dialog(tab="Tubes",
        group="Geometry"), choicesAllMatching);
  replaceable model PressureLossTubes =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2 "Pressure loss model at the tubes side"
                                            annotation (Dialog(tab="Tubes",
        group="Geometry"), choicesAllMatching);

  replaceable model HeatExchangerType =
      Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CounterFlow
      constrainedby ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.GeneralHeatExchanger "Type of Heat Exchanger"
    annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.Length
                      diameter_i=0.048 "Inner diameter of horizontal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter ClaRa.Basics.Units.Length
                      diameter_o=0.05 "Outer diameter of horizontal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_tubes=1000 "Number of horizontal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Boolean staggeredAlignment=true "True, if the tubes are aligned staggeredly, false otherwise"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_passes=1 "Number of passes of the internal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));

  parameter Boolean parallelTubes=false "True, if tubes are parallel to main orientation, else false"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Boolean verticalTubes=true "True, if lateral tubes are oriented vertically else false"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter ClaRa.Basics.Units.Length
                      z_in_tubes=length/2 "Inlet position from bottom"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter ClaRa.Basics.Units.Length
                      z_out_tubes=length/2 "Outlet position from bottom"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Real CF_geo=1 "|Tubes|Geometry|Correction coefficient due to fins etc.";
  parameter ClaRa.Basics.Units.MassFlowRate
                            m_nom2=10 "Nominal mass flow on side 2"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter ClaRa.Basics.Units.Pressure
                        p_nom2=10 "Nominal pressure on side 2"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter SI.SpecificEnthalpy h_nom2=10 "Nominal specific enthalpy on side 2"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter ClaRa.Basics.Units.HeatFlowRate
                            Q_flow_nom=1e6 "Nominal heat flow rate"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter SI.SpecificEnthalpy h_start_tubes=1e5 "Start value of sytsem specific enthalpy"
    annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure
                        p_start_tubes=1e5 "Start value of sytsem pressure"
    annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter Basics.Choices.Init initTypeTubes=ClaRa.Basics.Choices.Init.noInit "Type of initialisation"
    annotation (Dialog(tab="Tubes", group="Initialisation"));

  parameter Basics.Choices.Init initWall=ClaRa.Basics.Choices.Init.noInit "|Tubes|Initialisation|Initialisation option for the walls";
  parameter Basics.Units.Temperature T_w_i_start=293.15 "|Tubes|Initialisation|Initial wall temperature at inner phase";
  parameter Basics.Units.Temperature T_w_a_start=293.15 "|Tubes|Initialisation|Initial wall temperature at outer phase";
  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";

  ClaRa.Basics.Interfaces.FluidPortIn In2(Medium=medium2)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
        iconTransformation(extent={{90,-70},{110,-50}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out2(Medium=medium2)
    annotation (Placement(transformation(extent={{90,50},{110,70}}),
        iconTransformation(extent={{90,50},{110,70}})));
  ClaRa.Basics.Interfaces.GasPortIn In1(Medium=medium1)
    annotation (Placement(transformation(extent={{-10,88},{10,108}})));
  ClaRa.Basics.Interfaces.GasPortOut Out1(Medium=medium1) "Outlet port"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.NTU_L2 wall(
    length=length,
    redeclare replaceable model Material = WallMaterial,
    N_p=N_passes,
    radius_i=diameter_i/2,
    radius_o=diameter_o/2,
    T_i_in=tubes.fluidIn.T,
    m_flow_i=tubes.inlet.m_flow,
    m_flow_a=shell.inlet.m_flow,
    alpha_i=tubes.heattransfer.alpha,
    alpha_o=shell.heattransfer.alpha,
    cp_mean_i=(tubes.fluidIn.cp + tubes.fluidOut.cp)/2,
    mass_struc=mass_struc,
    N_t=N_tubes,
    T_a_in=shell.flueGasInlet.T,
    cp_mean_a=(shell.flueGasInlet.cp + shell.flueGasOutlet.cp)/2,
    T_w_i_start=T_w_i_start,
    T_w_a_start=T_w_a_start,
    initChoice=initWall,
    showExpertSummary=showExpertSummary,
    CF_geo=CF_geo,
    redeclare model HeatExchangerType = HeatExchangerType) annotation (Placement(transformation(extent={{20,20},{40,40}})));

  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 tubes(
    medium=medium2,
    p_nom=p_nom2,
    h_nom=h_nom2,
    m_flow_nom=m_nom2,
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
        length=height),
    showExpertSummary=showExpertSummary)
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=270,
        origin={38,0})));

  Basics.ControlVolumes.GasVolumes.FlueGasCell shell(
    medium=medium1,
    p_nom=p_nom1,
    h_nom=h_nom1,
    redeclare model HeatTransfer = HeatTransfer_Shell,
    redeclare model PressureLoss = PressureLossShell,
    m_flow_nom=m_nom1,
    useHomotopy=useHomotopy,
    T_start=T_start_shell,
    p_start=p_start_shell,
    initType=initTypeShell,
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
        orientation=mainOrientation,
        parallelTubes=parallelTubes,
        verticalTubes=verticalTubes,
        z_in={z_in_shell}),
    xi_start=xi_shell_start) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,56})));
  Summary summary(outline(
      showExpertSummary=showExpertSummary,
      Q_flow=shell.heat.Q_flow,
      Delta_T_in=shell.flueGasInlet.T - tubes.summary.inlet.T,
      Delta_T_out=shell.flueGasOutlet.T - tubes.summary.outlet.T,
      effectiveness=wall.effectiveness,
      kA=wall.kA)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-92})));

  Basics.Interfaces.EyeOut eye if showData annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={100,80}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,80})));
protected
  Basics.Interfaces.EyeIn eye_int
    annotation (Placement(transformation(extent={{71,79},{73,81}})));

equation
  assert(diameter_o > diameter_i,
    "Outer diameter of tubes must be greater than inner diameter");

initial equation
  //        wall.T=(Tubes.bulk.T+shell.bulk.T)/2;

equation
  eye_int.m_flow = -Out1.m_flow;
  eye_int.T = tubes.summary.outlet.T - 273.15;
  eye_int.s = tubes.fluidOut.s/1e3;
  eye_int.p = tubes.outlet.p/1e5;
  eye_int.h = tubes.summary.outlet.h/1e3;
  connect(tubes.inlet, In2) annotation (Line(
      points={{38,-10},{74,-10},{74,-60},{100,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tubes.outlet, Out2) annotation (Line(
      points={{38,10},{64,10},{64,60},{100,60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tubes.heat, wall.innerPhase) annotation (Line(
      points={{28,1.77636e-015},{30.5,1.77636e-015},{30.5,21},{30,21}},
      color={127,0,0},
      smooth=Smooth.None));
  connect(shell.heat, wall.outerPhase) annotation (Line(
      points={{10,56},{30,56},{30,39}},
      color={127,0,0},
      smooth=Smooth.None));
  connect(shell.inlet, In1) annotation (Line(
      points={{1.83697e-015,66},{0,66},{0,98}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(shell.outlet, Out1) annotation (Line(
      points={{-1.83697e-015,46},{0,46},{0,-100}},
      color={118,163,176},
      smooth=Smooth.None));
  connect(eye_int, eye) annotation (Line(
      points={{72,80},{100,80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={Text(
          extent={{-86,92},{86,52}},
          lineColor={27,36,42},
          textString="NTU")}),Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,100}}),
                                      graphics));
end HEXvle2gas_L3_1ph_BU;
