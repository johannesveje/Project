within ClaRa.Basics.ControlVolumes.Fundamentals.Check;
model TestImpactOfFluidPropertiesAtWall "Testing wall temperature impact on Nusselt Number"
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;
parameter Real h_in = -50e3 + TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(), 1e5);
parameter Real h_out = TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(), 1e5);
parameter Real m_flow_D = 1;

// Real MIN=1e-5;
// Real Pr_w "Prandtl number of fluid near wall";
// Real Pr "Prandtl number of fluid";
// Real K
//     "Heat flow direction coefficient due to temperature difference between fluid and wall";
// Real kc_new=Volume.heattransfer.alpha/K;
// Real ratio_PrPr_w=Pr/Pr_w;
// Real Re;
// Real L=if Volume.geo.parallelTubes then Volume.geo.L else (Modelica.Constants.pi/2*Volume.heattransfer.inCon_1ph.d_a);
// Real psi = if b >= 1 then 1 - Modelica.Constants.pi/4/a else 1 - Modelica.Constants.pi/4/a/b;
// Real a=Volume.heattransfer.inCon_1ph.s_1/Volume.heattransfer.inCon_1ph.d_a;
// Real b=Volume.heattransfer.inCon_1ph.s_2/Volume.heattransfer.inCon_1ph.d_a;
// Real failureStatus = if (Re<10e6 and Re>10) and (Pr<10e3 and Pr>0.6)  then 0 else 1;
  Modelica.Blocks.Sources.Ramp     constQ_flow(
    startTime=500,
    offset=0,
    duration=100,
    height=3e5)
              annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Modelica.Blocks.Sources.Constant
                               ramp1(k=m_flow_D)
                annotation (Placement(transformation(extent={{100,60},{80,80}})));
  Modelica.Blocks.Sources.Constant
                               ramp5(k=50 + 273.15)
              annotation (Placement(transformation(extent={{100,20},{80,40}})));
  Modelica.Blocks.Sources.Constant
                               ramp3(k=1e5)
              annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  FluidVolumes.VolumeVLE_2 Volume(
    m_flow_nom=m_flow_D,
    p_nom(displayUnit="Pa") = 1e5,
    p_start(displayUnit="Pa") = 1e5,
    h_nom=2740e3,
    redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    h_start=400e3,
    initType=ClaRa.Basics.Choices.Init.steadyState,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubes (
        Nt=100,
        length=
          1,
        parallelTubes=true,
        N_rows=1),
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltShell1ph_L2) "max(0.000001, ((1 - Volume.bulk.q)*Volume.M))/noEvent(max(Volume.bulk.VLE.d_l, Volume.bulk.d))"
    annotation (Placement(transformation(extent={{20,40},{0,60}})));

  Components.BoundaryConditions.BoundaryVLE_Txim_flow massFlowSource1(
    variable_m_flow=true,
    variable_T=true,
    p_nom=100000) annotation (Placement(transformation(extent={{60,40},{40,60}})));
  Components.BoundaryConditions.BoundaryVLE_phxi pressureSink1(
    h_const=h_in,
    variable_p=true,
    p_const=100000) annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1   valveLinear_1_XRG1(
      redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         m_flow_nom=if ((m_flow_D) > 0) then (m_flow_D) else 10, Delta_p_nom=
            if ((1000) <> 0) then (1000) else 1000))
                                                 annotation (Placement(
        transformation(
        extent={{-10,6},{10,-6}},
        rotation=180,
        origin={-30,50})));
  inner SimCenter simCenter(
    redeclare replaceable TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1,
    useHomotopy=true,
    redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid2) annotation (Placement(transformation(extent={{-200,0},{-180,20}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Modelica.Blocks.Sources.Ramp Temp(
    startTime=500,
    duration=100,
    height=45,
    offset=50 + 273.15)
              annotation (Placement(transformation(extent={{-100,74},{-80,94}})));
  Modelica.Blocks.Sources.Ramp Temp1(
    duration=100,
    offset=0,
    startTime=1500,
    height=-90)
              annotation (Placement(transformation(extent={{-100,106},{-80,126}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=4)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-55,90})));
  Modelica.Blocks.Sources.Ramp Temp2(
    duration=100,
    offset=0,
    height=+150,
    startTime=3000)
              annotation (Placement(transformation(extent={{-100,140},{-80,160}})));
  Modelica.Blocks.Sources.Ramp Temp3(
    duration=100,
    offset=0,
    startTime=5000,
    height=+2500)
              annotation (Placement(transformation(extent={{-100,174},{-80,194}})));
equation
//    Pr   = Volume.heattransfer.Pr;
//    Pr_w=  Volume.heattransfer.inVar_1ph.eta_w*Volume.heattransfer.inVar_1ph.cp_w/max(MIN,Volume.heattransfer.inVar_1ph.lambda_w);
//    Re = Volume.heattransfer.Re;
//
// //K = ClaRa.Basics.Functions.Stepsmoother(1+1e-3, 1-1e-3, Pr/Pr_w) * max(1e-5,(Pr/Pr_w)^0.25) + (1-ClaRa.Basics.Functions.Stepsmoother(1+1e-3, 1-1e-3, Pr/Pr_w))*max(1e-5,(Pr/Pr_w)^0.11);
//
//  if Volume.heattransfer.inVar_1ph.x<=0 then // liquid
//
//     K = if Pr/Pr_w > 1 then (max(MIN,Pr/Pr_w))^0.25 else (max(MIN,Pr/Pr_w))^0.11;
//
//  elseif Volume.heattransfer.inVar_1ph.x>=1 then //vapour
//
//      K = 1;
//
//  else
//
//      K= 1;
//
//  end if;

  connect(Volume.inlet, massFlowSource1.steam_a)
                                                annotation (Line(
      points={{20,50},{20,50},{40,50}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(valveLinear_1_XRG1.inlet, Volume.outlet)
                                                  annotation (Line(
      points={{-20,50},{0,50}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink1.steam_a,valveLinear_1_XRG1. outlet)
                                                          annotation (Line(
      points={{-60,50},{-40,50}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp3.y, pressureSink1.p) annotation (Line(
      points={{-99,50},{-88,50},{-88,56},{-80,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, massFlowSource1.m_flow) annotation (Line(
      points={{79,70},{72,70},{72,56},{62,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp5.y, massFlowSource1.T) annotation (Line(
      points={{79,30},{74,30},{74,50},{62,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, Volume.heat) annotation (Line(
      points={{-20,90},{10,90},{10,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Temp1.y, multiSum.u[1]) annotation (Line(
      points={{-79,116},{-64,116},{-64,93.15},{-61,93.15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temp.y, multiSum.u[2]) annotation (Line(
      points={{-79,84},{-64,84},{-64,91.05},{-61,91.05}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.y, prescribedTemperature.T) annotation (Line(
      points={{-47.98,90},{-42,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temp2.y, multiSum.u[3]) annotation (Line(
      points={{-79,150},{-64,150},{-64,88.95},{-61,88.95}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temp3.y, multiSum.u[4]) annotation (Line(
      points={{-79,184},{-64,184},{-64,86.85},{-61,86.85}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-200,0},{180,240}},
          preserveAspectRatio=true),
                      graphics={Text(
          extent={{-180,240},{180,200}},
          lineColor={0,0,255},
          fontSize=12,
          horizontalAlignment=TextAlignment.Left,
          textString="Starting with constQ_flow.offset = 0 and increasing Q_flow leads to an error (solved with constQ_flow.offset = 1)
        --> plot K, iCom.steamQuality, iCom.T_in, iCom.T_out, Pr, Pr_w,kc

VARIABLES OF INTEREST:
See variable K")}),
    experiment(
      StopTime=3000,
      NumberOfIntervals=5000,
      Tolerance=1e-006,
      Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equdistant=false),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)));
end TestImpactOfFluidPropertiesAtWall;
