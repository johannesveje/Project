within ClaRa.Components.HeatExchangers;
model HEXvle2vle_L3_2ph_BU_ntu "VLE 2 VLE | L3 | two phase at shell side | Block shape | U-type | NTU ansatz"
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

  // Extends from... ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  extends ClaRa.Basics.Icons.HEX04;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  outer ClaRa.SimCenter simCenter;

  record Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary=false;
    SI.HeatFlowRate Q_flow "Heat flow rate";
    SI.TemperatureDifference Delta_T_in "Fluid temperature at inlet T_1_in - T_2_in";
    SI.TemperatureDifference Delta_T_out "Fluid temperature at outlet T_1_out - T_2_out";
    Real effectiveness[3] if showExpertSummary "Effectivenes of HEX";
    Real kA[3](unit="W/K") if showExpertSummary "Overall heat resistance";
    SI.Length level_abs "Absolute filling level";
    Real level_rel "relative filling level";
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
  parameter SI.Length length=10 "Length of the HEX" annotation (Dialog(
      tab="Shell Side",
      group="Geometry",
      groupImage="modelica://ClaRa/figures/ParameterDialog/HollowBlockWithTubes_1.png"));
  parameter SI.Length height=3 "Height of HEX"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter SI.Length width=3 "Width of HEX"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter SI.Length z_in_shell=length/2 "Inlet position from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
    parameter SI.Length z_in_aux1=length/2 "Inlet position of auxilliary1 from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter SI.Length z_in_aux2=length/2 "Inlet position of auxilliary2 from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter SI.Length z_out_shell=length/2 "Outlet position from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length radius_flange=0.05 "|Shell Side|Geometry|Flange radius of all flanges";
  parameter SI.Mass mass_struc=0 "Mass of inner structure elements, additional to the tubes itself"
    annotation (Dialog(tab="Shell Side", group="Geometry"));

  //________________________________ Shell nominal parameter _____________________________________//
  parameter SI.MassFlowRate m_flow_nom_shell=10 "Nominal mass flow on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter SI.Pressure p_nom_shell=10 "Nominal pressure on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));
//   parameter SI.SpecificEnthalpy h_nom_shell=10
//     "Nominal specific enthalpy on shell side"
//     annotation (Dialog(tab="Shell Side", group="Nominal Values"));

  //________________________________ Shell initialisation  _______________________________________//
   parameter SI.EnthalpyMassSpecific h_liq_start=-10 +
       TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium_shell, p_start_shell) "|Shell Side|Initialisation|Start specific enthalpy of liquid phase";
   parameter SI.EnthalpyMassSpecific h_vap_start=+10 +
       TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(medium_shell, p_start_shell) "|Shell Side|Initialisation|Start specific enthalpy of steam phase";

//   parameter SI.SpecificEnthalpy h_start_shell=1e5
//     "Start value of sytsem specific enthalpy"
//     annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter SI.Pressure p_start_shell=1e5 "Start value of sytsem pressure"
    annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter Real level_rel_start=0.5 "|Shell Side|Initialisation| Start value for relative filling Level";
  parameter Basics.Choices.Init initTypeShell=ClaRa.Basics.Choices.Init.noInit "Type of initialisation"
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
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2 "Pressure loss model at the tubes side"
                                            annotation (Dialog(tab="Tubes",
        group="Fundamental Definitions"), choicesAllMatching);

  //________________________________ Tubes geometry _______________________________//
  parameter SI.Length diameter_i=0.048 "Inner diameter of horizontal tubes"
    annotation (Dialog(
      tab="Tubes",
      group="Geometry",
      groupImage="modelica://ClaRa/figures/ParameterDialog/HollowBlockWithTubes_2.png"));
  parameter SI.Length diameter_o=0.05 "Outer diameter of horizontal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_tubes=1000 "Number of horizontal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Boolean staggeredAlignment=true "True, if the tubes are aligned staggeredly, false otherwise"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_passes=1 "Number of passes of the internal tubes"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Boolean parallelTubes=false "True, if tubes are parallel to main orientation, else false"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter SI.Length z_in_tubes=length/2 "Inlet position from bottom"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter SI.Length z_out_tubes=length/2 "Outlet position from bottom"
    annotation (Dialog(tab="Tubes", group="Geometry"));

  parameter SI.Length Delta_z_par=2*diameter_o "Distance between tubes parallel to flow direction (center to center)"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter SI.Length Delta_z_ort=2*diameter_o "Distance between tubes orthogonal to flow direction (center to center)"
    annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Real CF_geo=1 "Correction coefficient due to fins etc."
    annotation (Dialog(tab="Tubes", group="Geometry"));

  //________________________________ Tubes nominal parameter _____________________________________//
  parameter SI.MassFlowRate m_flow_nom_tubes=10 "Nominal mass flow on tubes side"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter SI.Pressure p_nom_tubes=10 "Nominal pressure on tubes side"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter SI.EnthalpyMassSpecific h_nom_tubes=10 "Nominal specific enthalpy on tubes side"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter SI.HeatFlowRate Q_flow_nom=1e6 "Nominal heat flow rate"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));

  //________________________________ Tubes initialisation _______________________________________//
  parameter SI.EnthalpyMassSpecific h_start_tubes=1e5 "Start value of sytsem specific enthalpy"
    annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter SI.Pressure p_start_tubes=1e5 "Start value of sytsem pressure"
    annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter Basics.Choices.Init initTypeTubes=ClaRa.Basics.Choices.Init.noInit "Type of initialisation"
    annotation (Dialog(tab="Tubes", group="Initialisation"));

  //*********************************** / HOTWELL \ ***********************************//
  parameter Basics.Units.Length height_hotwell=1 "Height of the hotwell"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length width_hotwell=1 "Width of the hotwell"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length length_hotwell=1 "Length of the hotwell"
    annotation (Dialog(tab="Shell Side", group="Geometry"));

  //*********************************** / WALL \ ***********************************//
  //________________________________ Wall fundamentals _______________________________//
  replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Aluminum
    constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder"
    annotation (choicesAllMatching=true, Dialog(tab="Wall", group=
          "Fundamental Definitions"));

  //________________________________ Wall initialisation _______________________________________//
  parameter Basics.Units.Temperature T_w_tube_start[3]=ones(3)*293.15 "Initial temperature at inner phase"
    annotation (Dialog(tab="Wall", group="Initialisation"));
  parameter Basics.Units.Temperature T_w_shell_start[3]=ones(3)*293.15 "Initial temperature at outer phase"
    annotation (Dialog(tab="Wall", group="Initialisation"));
  parameter Basics.Choices.Init initTypeWall=ClaRa.Basics.Choices.Init.noInit "Init Option of Wall"
    annotation (Dialog(tab="Wall", group="Initialisation"));

  //*********************************** / EXPERT Settings and Visualisation \ ***********************************//
  parameter Basics.Units.Time Tau_cond=0.3 "|Expert Settings|Zone Interaction at Shell Side|Time constant of condensation";
  parameter Basics.Units.Time Tau_evap=0.03 "|Expert Settings|Zone Interaction at Shell Side|Time constant of evaporation";
  parameter Basics.Units.CoefficientOfHeatTransfer alpha_ph=50000 "|Expert Settings|Zone Interaction at Shell Side|HTC of the phase border";
  parameter Basics.Units.Area A_phaseBorder=shell.geo.A_hor*100 "|Expert Settings|Zone Interaction at Shell Side|Heat transfer area at phase border";
  parameter Real expHT_phases=0 "|Expert Settings|Zone Interaction at Shell Side|Exponent for volume dependency on inter phase HT";
  parameter Real absorbInflow=1 "|Expert Settings|Zone Interaction at Shell Side|Absorption of incoming mass flow to the zones 1: perfect in the allocated zone, 0: perfect according to steam quality";

  replaceable function HeatCapacityAveraging =
      ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Functions.ArithmeticMean
    constrainedby ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Functions.GeneralMean "|Expert Settings|NTU model|Method for Averaging of heat capacities"
    annotation (choicesAllMatching);

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";
  parameter Real gain_eff=1 "|Expert Settings|NTU model|Avoid effectiveness > 1, high gain_eff leads to stricter observation but may cause numeric errors";

  ClaRa.Basics.Interfaces.FluidPortIn In2(Medium=medium_tubes)
    annotation (Placement(transformation(extent={{88,-50},{108,-30}}),
        iconTransformation(extent={{88,-50},{108,-30}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out2(Medium=medium_tubes)
    annotation (Placement(transformation(extent={{88,50},{108,70}}),
        iconTransformation(extent={{88,50},{108,70}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  ClaRa.Basics.Interfaces.FluidPortIn In1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-10,88},{10,108}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.NTU_L3_standalone wall(
    length=length,
    redeclare replaceable model Material = WallMaterial,
    N_p=N_passes,
    radius_i=diameter_i/2,
    m_flow_i=tubes.inlet.m_flow,
    alpha_i=ones(3)*tubes.heattransfer.alpha,
    mass_struc=mass_struc,
    N_t=N_tubes,
    radius_o=diameter_o/2,
    h_i_inlet=inStream(tubes.inlet.h_outflow),
    h_o_inlet=inStream(shell.inlet[1].h_outflow),
    m_flow_o=sum(shell.inlet.m_flow),
    alpha_o={shell.heattransfer.alpha[1],shell.heattransfer.alpha[2],shell.heattransfer.alpha[2]},
    redeclare function HeatCapacityAveraging = HeatCapacityAveraging,
    medium_shell=medium_shell,
    medium_tubes=medium_tubes,
    redeclare model HeatExchangerType =
        ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CrossFlow_L3,
    T_w_i_start=T_w_tube_start,
    T_w_o_start=T_w_shell_start,
    initChoice=initTypeWall,
    outerPhaseChange=true,
    p_o=shell.outlet[1].p,
    p_i=tubes.outlet.p,
    showExpertSummary=showExpertSummary,
    gain_eff=gain_eff) annotation (Placement(transformation(extent={{20,24},{40,44}})));

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
        length=length),
    showExpertSummary=showExpertSummary)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={38,0})));

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
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndHotwell (
        height=height,
        width=width,
        length=length,
        diameter_t=diameter_o,
        N_tubes=N_tubes,
        staggeredAlignment=staggeredAlignment,
        height_hotwell=height_hotwell,
        width_hotwell=width_hotwell,
        length_hotwell=length_hotwell,
        Delta_z_par=Delta_z_par,
        Delta_z_ort=Delta_z_ort,
        N_inlet=3,
        z_out={z_out_shell},
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        z_in={z_in_shell,z_in_aux1,z_in_aux2}),
    Tau_cond=Tau_cond,
    Tau_evap=Tau_evap,
    alpha_ph=alpha_ph,
    A_heat_ph=A_phaseBorder,
    h_liq_start=h_liq_start,
    h_vap_start=h_vap_start,
    level_rel_start=level_rel_start,
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
      Delta_T_in=shell.summary.inlet[1].T - tubes.summary.inlet.T,
      Delta_T_out=shell.summary.outlet[1].T - tubes.summary.outlet.T,
      effectiveness=wall.summary.effectiveness,
      kA=wall.summary.kA,
      level_abs=shell.phaseBorder.level_abs,
      level_rel= shell.phaseBorder.level_rel)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-92})));
   Basics.Interfaces.EyeOut eye2 if showData annotation (Placement(
         transformation(
         extent={{10,-10},{-10,10}},
         rotation=180,
         origin={104,80})));
protected
   Basics.Interfaces.EyeIn eye_int2
     annotation (Placement(transformation(extent={{89,79},{91,81}})));
public
   Basics.Interfaces.EyeOut eye1 if showData annotation (Placement(
         transformation(
         extent={{-10,-10},{10,10}},
         rotation=270,
         origin={28,-98})));
protected
   Basics.Interfaces.EyeIn eye_int1
     annotation (Placement(transformation(extent={{27,-59},{29,-57}})));
//
public
  Basics.Interfaces.FluidPortIn       aux1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
  Basics.Interfaces.FluidPortIn       aux2(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}),
        iconTransformation(extent={{-110,50},{-90,70}})));

  Adapters.Scalar2VectorHeatPort reallocateHeatFlows(N=2, final equalityMode="Equal Temperatures")
    annotation (Placement(transformation(extent={{18,65},{30,73}})));
initial equation
   //        wall.T=(tubes.bulk.T+shell.bulk.T)/2;
//

equation
  connect(tubes.inlet, In2) annotation (Line(
      points={{38,-10},{72,-10},{72,-40},{98,-40}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tubes.outlet, Out2) annotation (Line(
      points={{38,10},{64,10},{64,60},{98,60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  assert(diameter_o > diameter_i,
    "Outer diameter of tubes must be greater than inner diameter");

   eye_int1.m_flow = -Out1.m_flow;
   eye_int1.T = shell.summary.outlet[1].T - 273.15;
   eye_int1.s = shell.fluidOut[1].s/1e3;
   eye_int1.p = shell.outlet[1].p/1e5;
   eye_int1.h = shell.summary.outlet[1].h/1e3;
   eye_int2.m_flow = -Out2.m_flow;
   eye_int2.T = tubes.summary.outlet.T - 273.15;
   eye_int2.s = tubes.fluidOut.s/1e3;
   eye_int2.p = tubes.outlet.p/1e5;
   eye_int2.h = tubes.summary.outlet.h/1e3;

  connect(wall.innerPhase[1], tubes.heat) annotation (Line(
      points={{30,23.3333},{30,8.88178e-016},{28,8.88178e-016}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wall.innerPhase[2], tubes.heat) annotation (Line(
      points={{30,24},{30,8.88178e-016},{28,8.88178e-016}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wall.innerPhase[3], tubes.heat) annotation (Line(
      points={{30,24.6667},{30,8.88178e-016},{28,8.88178e-016}},
      color={191,0,0},
      smooth=Smooth.None));
   connect(eye_int2, eye2) annotation (Line(
       points={{90,80},{104,80}},
       color={255,204,51},
       thickness=0.5,
       smooth=Smooth.None));
   connect(eye_int1, eye1) annotation (Line(
       points={{28,-58},{28,-98}},
       color={255,204,51},
       thickness=0.5,
       smooth=Smooth.None));
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
      points={{-100,60},{-70,60},{-70,74},{1.77636e-015,74},{1.77636e-015,70}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wall.outerPhase[3], shell.heat[1]) annotation (Line(
      points={{30,44.6667},{30,60},{9.5,60}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(reallocateHeatFlows.heatScalar, shell.heat[2]) annotation (Line(
      points={{18,69},{18,60},{10.5,60}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wall.outerPhase[1], reallocateHeatFlows.heatVector[1]) annotation (
      Line(
      points={{30,43.3333},{30,68.8}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wall.outerPhase[2], reallocateHeatFlows.heatVector[2]) annotation (
      Line(
      points={{30,44},{30,69.2}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={Text(
          extent={{-86,98},{86,58}},
          lineColor={27,36,42},
          textString="NTU")}),Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics));
end HEXvle2vle_L3_2ph_BU_ntu;
