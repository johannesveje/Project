within ClaRa.Components.MechanicalSeparation;
model BalanceTank_L3 "A balance tank with a vent"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                            //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright © 2013-2015, DYNCAP research team.                              //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
 extends ClaRa.Basics.Icons.BalanceTank;
  outer ClaRa.SimCenter simCenter;

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid liquidMedium=simCenter.fluid1 "|Fundamental Definitions| Liquid medium in the component";
  parameter TILMedia.GasTypes.BaseGas gasMedium=simCenter.flueGasModel "|Fundamental Definitions|Gas medium in the component";
  replaceable model Material = TILMedia.SolidTypes.TILMedia_Aluminum "|Fundamental Definitions|Solid material of the tank"
    annotation (choicesAllMatching=true);
  replaceable model HeatTransfer =
      Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 "|Fundamental Definitions|Heat transfer model"
    annotation (choicesAllMatching=true);
  replaceable model PressureLoss =
      Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 "|Fundamental Definitions|Pressure loss model"
    annotation (choicesAllMatching=true);

  parameter Modelica.SIunits.Length diameter_i=2 "|Geometry|Inner diameter of the tank";
  parameter Modelica.SIunits.Length s_wall=2 "|Geometry|Wall thickness of the tank";
  parameter Modelica.SIunits.Length height=2 "|Geometry|Height of the tank";
  parameter Modelica.SIunits.Temperature T_start[3]=ones(3)*293.15 "|Initialisation|Wall|Start values of wall temperature";
  parameter ClaRa.Basics.Choices.Init initWall=ClaRa.Basics.Choices.Init.noInit "|Initialisation|Wall|Wall init option"
                                           annotation (choicesAllMatching);

  parameter SI.Length z_in[3]=ones(3)*height "|Geometry|Height of liquid inlet ports";
  parameter SI.Length z_out[1]={0.1} "|Geometry|Height of liquid outlet ports";

  parameter SI.CoefficientOfHeatTransfer alpha_ph=500 "|Expert Settings|Phase Border|HTC of the phase border";
  parameter SI.Area A_phaseBorder=volumeVLEGas_L3_1.geo.A_hor*100 "|Expert Settings|Phase Border|Heat transfer area at phase border";

  parameter SI.EnthalpyMassSpecific h_liq_start=-10 +
      TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(liquidMedium,
      p_start) "|Initialisation|Fluids|Start value ofliquid specific enthalpy";
  parameter SI.Temperature T_gas_start=293.15 "|Initialisation|Fluids|Start value of gas zone's temperature";
  parameter SI.Pressure p_start=1e5 "|Initialisation|Fluids|Start value of sytsem pressure";
  parameter SI.MassFraction xi_start[gasMedium.nc - 1]=zeros(gasMedium.nc
       - 1) "|Initialisation|Fluids|Initial gas mass fraction";
  parameter Real relLevel_start=0.5 "|Initialisation|Fluids|Initial value for relative level";
  parameter String initFluid="No init, use start values as guess" "|Initialisation|Fluids|Type of initialisation"
                                                    annotation (choices(choice = "No init, use start values as guess", choice="Steady state in p, h_liq, T_gas",
            choice = "Steady state in p", choice="steady State in h_liq and T_gas", choice = "Fixed value for filling level",
             choice = "Fixed values for filling level, p, h_liq, T_gas"));

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";

  Basics.Interfaces.FluidPortOut outlet(Medium=liquidMedium) "Outlet port"
    annotation (Placement(transformation(extent={{-106,-68},{-86,-48}}),
        iconTransformation(extent={{-106,-68},{-86,-48}})));
  Basics.Interfaces.FluidPortIn inlet3(Medium=liquidMedium) "Inlet port"
    annotation (Placement(transformation(extent={{170,190},{190,210}}),
        iconTransformation(extent={{170,190},{190,210}})));
  Basics.Interfaces.FluidPortIn inlet1(Medium=liquidMedium) "Inlet port"
    annotation (Placement(transformation(extent={{90,190},{110,210}}),
        iconTransformation(extent={{90,190},{110,210}})));
  Basics.Interfaces.FluidPortIn inlet2(Medium=liquidMedium) "Inlet port"
    annotation (Placement(transformation(extent={{132,190},{152,210}}),
        iconTransformation(extent={{132,190},{152,210}})));

  Basics.ControlVolumes.SolidVolumes.ThickWall_L4 wall(
    N_rad=3,
    sizefunc=+1,
    diameter_i=diameter_i,
    length=height,
    T_start=T_start,
    diameter_o=diameter_i + 2*s_wall,
    redeclare model Material = Material,
    initChoice=initWall) annotation (Placement(transformation(extent={{-44,14},{-24,34}})));

  Basics.ControlVolumes.FluidVolumes.VolumeVLEGas_L3 volumeVLEGas_L3_1(
    medium=liquidMedium,
    gasType=gasMedium,
    redeclare model HeatTransfer = HeatTransfer,
    redeclare model PressureLoss = PressureLoss,
    alpha_ph=alpha_ph,
    A_heat_ph=A_phaseBorder,
    h_liq_start=h_liq_start,
    T_gas_start=T_gas_start,
    p_start=p_start,
    xi_start=xi_start,
    showExpertSummary=showExpertSummary,
    level_rel_start=relLevel_start,
    initType=initFluid,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry (
        volume=height*diameter_i^2*Modelica.Constants.pi/4,
        N_heat=1,
        A_heat={Modelica.Constants.pi*diameter_i*height},
        A_cross=diameter_i^2*Modelica.Constants.pi/4,
        A_front=diameter_i^2*Modelica.Constants.pi/4,
        A_hor=diameter_i^2*Modelica.Constants.pi/4,
        N_inlet=3,
        N_outlet=1,
        height_fill=height,
        shape=[0,1; 1,1],
        z_out=z_out,
        z_in=z_in)) annotation (Placement(transformation(extent={{-6,-12},{-26,8}})));

  Basics.Interfaces.GasPortIn vent1(Medium=gasMedium)
    annotation (Placement(transformation(extent={{40,190},{60,210}}),
        iconTransformation(extent={{40,190},{60,210}})));

equation
  connect(volumeVLEGas_L3_1.outlet[1], outlet) annotation (Line(
      points={{-26,-2},{-26,-58},{-96,-58}},
      color={0,131,169},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(volumeVLEGas_L3_1.inlet[1], inlet1) annotation (Line(
      points={{-6,-2},{100,-2},{100,200}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(volumeVLEGas_L3_1.inlet[2], inlet2) annotation (Line(
      points={{-6,-2},{142,-2},{142,200}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(volumeVLEGas_L3_1.inlet[3], inlet3) annotation (Line(
      points={{-6,-2},{180,-2},{180,200}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(volumeVLEGas_L3_1.vent, vent1) annotation (Line(
      points={{-6,1.8},{-6,200},{50,200}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wall.innerPhase, volumeVLEGas_L3_1.heat) annotation (Line(
      points={{-34.2,14.4},{-28,14.4},{-28,20},{-16,20},{-16,7.8}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{200,200}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{200,200}}), graphics));
end BalanceTank_L3;
