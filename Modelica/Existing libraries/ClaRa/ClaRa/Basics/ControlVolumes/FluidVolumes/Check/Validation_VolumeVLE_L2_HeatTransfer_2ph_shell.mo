within ClaRa.Basics.ControlVolumes.FluidVolumes.Check;
model Validation_VolumeVLE_L2_HeatTransfer_2ph_shell "Validation scenario from VDI W�rmeatlas 9. Auflage 2002 Chapter Ja 13 Example 2"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                        //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright � 2013-2015, DYNCAP research team.                                   //
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

  import SI = ClaRa.Basics.Units;

  parameter Units.EnthalpyMassSpecific
                                    h_in =  TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(), p);
  parameter Units.EnthalpyMassSpecific
                                    h_out = TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(), p);
  parameter Units.MassFlowRate
                            m_flow_D= Volume.geo.A_front*w_inf*0.019535;

  parameter Units.Velocity
                        w_inf = 71.3;
  parameter Units.Temperature
                           T_w = T_s - 1.01;
  parameter Units.Temperature
                           T_s = 22.07 + 273.15;
  parameter Units.Length
                      diameter_shell_o= 0.092 "Outer diameter of shell";
  parameter Units.Length
                      diameter_tube_o= 0.014 "Outer diameter of tube";

  parameter Units.Pressure
                        p =  TILMedia.VLEFluidFunctions.dewPressure_Txi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(), T_s);
  parameter Units.EnthalpyMassSpecific
                                    h = TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_Txi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),T_s);

  Real eta_l = TILMedia.VLEFluidFunctions.dynamicViscosity_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),p, T_w,{0});
  Real cp_l =  TILMedia.VLEFluidFunctions.specificIsobaricHeatCapacity_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),p, T_w,{0});
  Real lambda_l = TILMedia.VLEFluidFunctions.thermalConductivity_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),p, T_w,{0});
  Real rho_liq = TILMedia.VLEFluidFunctions.density_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),p, T_w,{0});
  Real h_l = TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),p,T_w,{0});

  Real alpha "Heat transfer coefficient";
  Real Pr "Prandtl number of the film";
  Real Re "Reynolds number of flowing steam";
  Real Nu "Nusselt number";
  Real failureStatus "0== boundary conditions fulfilled | 1== failure >> check if still meaningfull results";

//  Real Re_test;

  VolumeVLE_2                                         Volume(
    m_flow_nom=m_flow_D,
    p_nom(displayUnit="Pa") = p,
    h_nom=h_out + 10e3,
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2,
    h_start=h_out,
    p_start(displayUnit="Pa") = p + 30,
    initType=ClaRa.Basics.Choices.Init.steadyDensity,
    redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallySeparated,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltShell2ph_L2,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowCylinderWithTubes (
        N_inlet=1,
        N_outlet=1,
        z_in={diameter_shell_o/2},
        z_out={diameter_shell_o/2},
        orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
        diameter=diameter_shell_o,
        length=1,
        diameter_t=diameter_tube_o,
        length_tubes=diameter_shell_o,
        N_rows=1),
    heatSurfaceAlloc=2) "max(0.000001, ((1 - Volume.bulk.q)*Volume.M))/noEvent(max(Volume.bulk.VLE.d_l, Volume.bulk.d))"
    annotation (Placement(transformation(extent={{52,-80},{32,-60}})));

  Components.BoundaryConditions.BoundaryVLE_hxim_flow MassFlowSource(
    variable_m_flow=true,
    variable_h=true,
    m_flow_nom=m_flow_D,
    p_nom(displayUnit="Pa") = p) annotation (Placement(transformation(extent={{120,-80},{100,-60}})));
  Components.BoundaryConditions.BoundaryVLE_hxim_flow MassFlowSink(
    h_const=h_in,
    variable_m_flow=true,
    variable_h=true,
    p_nom(displayUnit="Pa") = p,
    m_flow_nom=m_flow_D) annotation (Placement(transformation(extent={{-38,-80},{-18,-60}})));
  inner SimCenter simCenter(redeclare replaceable TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1, useHomotopy=true) annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Modelica.Blocks.Sources.Constant const4(k=T_w)
              annotation (Placement(transformation(extent={{8,-32},{20,-20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{-5,-5},{5,5}},
        rotation=270,
        origin={41,-39})));
  TILMedia.VLEFluid_ph vleFluid(
    redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater vleFluidType,
    computeTransportProperties=true,
    computeVLEAdditionalProperties=true,
    computeVLETransportProperties=true,
    p=p,
    h=h)
        annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
  Modelica.Blocks.Sources.Constant
                               const(k=-m_flow_D)
                annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.Constant const1(k=h_in)
              annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

  Modelica.Blocks.Sources.Constant
                               const2(k=m_flow_D)
                annotation (Placement(transformation(extent={{160,-60},{140,-40}})));
  Modelica.Blocks.Sources.Constant const3(k=h_in)
              annotation (Placement(transformation(extent={{160,-100},{140,-80}})));
equation

(alpha, Pr,Re,Nu,failureStatus)=FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam(
FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_IN_con(d=diameter_tube_o, A_front=Modelica.Constants.pi/4*diameter_shell_o ^2),
FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_IN_var(cp_l=vleFluid.VLEAdditional.cp_l, lambda_l=vleFluid.VLETransp.lambda_l, rho_g=vleFluid.VLE.d_v, rho_l=vleFluid.VLE.d_l, eta_g=vleFluid.VLETransp.eta_v, eta_l=vleFluid.VLETransp.eta_l, T_s=T_s, dh_lg=vleFluid.VLE.h_v-vleFluid.VLE.h_l, m_flow=vleFluid.d*w_inf*Modelica.Constants.pi/4*diameter_shell_o ^2, T_w=T_w));

//Re_test=m_flow_D/(Modelica.Constants.pi/4*diameter_shell_o ^2)/(Volume.iCom.d_dew)*diameter_tube_o/(Volume.iCom.eta_bub/Volume.iCom.d_bub);
  connect(Volume.inlet,MassFlowSource. steam_a) annotation (Line(
      points={{52,-70},{52,-70},{100,-70}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(MassFlowSink.m_flow, const.y) annotation (Line(
      points={{-40,-64},{-54,-64},{-54,-50},{-59,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(MassFlowSink.steam_a, Volume.outlet) annotation (Line(
      points={{-18,-70},{32,-70}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(const1.y, MassFlowSink.h) annotation (Line(
      points={{-59,-90},{-54,-90},{-54,-70},{-40,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const2.y, MassFlowSource.m_flow) annotation (Line(
      points={{139,-50},{134,-50},{134,-64},{122,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const3.y, MassFlowSource.h) annotation (Line(
      points={{139,-90},{136,-90},{136,-70},{122,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature.T, const4.y) annotation (Line(
      points={{41,-33},{41,-26},{20.6,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, Volume.heat) annotation (Line(
      points={{41,-44},{41,-60},{42,-60}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-140},{180,120}},
          preserveAspectRatio=true),
                      graphics={Text(
          extent={{-110,110},{110,110}},
          lineColor={0,128,0},
          fontSize=27,
          textString="Validated -- 2013-01-22 //AR"),
                                Text(
          extent={{-100,100},{180,0}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="_______________________________________________________________________________________
PURPOSE:
>> validation of volume element with the 2ph heat transfer with the experimental data of 
      \"T. Fujii, Vol. 15 pp235-246, Pergamon Press 1972,
_______________________________________________________________________________________
Compare the following values of simulation with experimental data from literature:
>>Nusselt number: Volume.heattransfer.Nu_2ph vs. Literature = 1285.74  vs. 1250
>>Heat transfer coefficient: Volume.heattransfer.alpha vs. Literature = 55290 vs. 53500 W/m�K


")}),
    experiment(
      StopTime=50000,
      NumberOfIntervals=10000,
      Tolerance=1e-006,
      Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equdistant=false),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics));
end Validation_VolumeVLE_L2_HeatTransfer_2ph_shell;
