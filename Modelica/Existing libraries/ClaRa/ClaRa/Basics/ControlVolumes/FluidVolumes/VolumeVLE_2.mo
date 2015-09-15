within ClaRa.Basics.ControlVolumes.FluidVolumes;
model VolumeVLE_2 "A lumped control volume for vapour/liquid equilibrium"
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

  extends ClaRa.Basics.Icons.Volume;

  extends ClaRa.Basics.Icons.ComplexityLevel(     complexity="L2");
//  extends BaseClasses.Interfaces.DataInterface(p_int=outlet.p/1e5,h_int=outlet.h_outflow/1e3, m_flow_int=-outlet.m_flow, T_int=fluidOut.T-273.15, s_int=refOutlet.s/1e3);
  outer ClaRa.SimCenter simCenter;

  import Modelica.Constants.eps;
  import ClaRa;

record Outline
  extends ClaRa.Basics.Icons.RecordIcon;
  parameter Boolean showExpertSummary = false;
  ClaRa.Basics.Units.Volume
                        volume_tot "Total volume";
  ClaRa.Basics.Units.Area
                      A_heat "Heat transfer area";
  ClaRa.Basics.Units.HeatFlowRate
                              Q_flow_tot "Total heat flow rate";
  ClaRa.Basics.Units.PressureDifference
                                    Delta_p "Pressure difference p_in - p_out";
end Outline;

record Summary
  extends ClaRa.Basics.Icons.RecordIcon;
  Outline outline;
  ClaRa.Basics.Records.FlangeVLE                inlet;
  ClaRa.Basics.Records.FlangeVLE                outlet;
  ClaRa.Basics.Records.FluidVLE_L2                fluid;
end Summary;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// replaceable models~~~~~~~~~~~~~~~~~~~~~~~~
  inner parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium=simCenter.fluid1 "Medium in the component"
                               annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model HeatTransfer =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2
          constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE "1st: choose heat transfer model | 2nd: edit corresponding record"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);
  replaceable model PhaseBorder =
      ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdealPhases "1st: choose phase border model | 2nd: edit corresponding record"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

    replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2 "1st: choose friction model | 2nd: edit corresponding record"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

  replaceable model Geometry =
      ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry "1st: choose geometry definition | 2nd: edit corresponding record"
    annotation (Dialog(group="Geometry"), choicesAllMatching=true);

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// parameters ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));
  inner parameter Modelica.SIunits.MassFlowRate m_flow_nom= 10 "Nominal mass flow rates at inlet"
                                        annotation(Dialog(tab="General", group="Nominal Values"));

  inner parameter Modelica.SIunits.Pressure p_nom=1e5 "Nominal pressure"                    annotation(Dialog(group="Nominal Values"));
  inner parameter Modelica.SIunits.SpecificEnthalpy h_nom=1e5 "Nominal specific enthalpy"      annotation(Dialog(group="Nominal Values"));

  parameter Modelica.SIunits.SpecificEnthalpy h_start= 1e5 "Start value of sytsem specific enthalpy"
                                             annotation(Dialog(tab="Initialisation"));
  parameter Modelica.SIunits.Pressure p_start= 1e5 "Start value of sytsem pressure" annotation(Dialog(tab="Initialisation"));
  inner parameter ClaRa.Basics.Choices.Init      initType=ClaRa.Basics.Choices.Init.noInit "Type of initialisation"
                             annotation(Dialog(tab="Initialisation", choicesAllMatching));

  parameter Boolean showExpertSummary = false "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Integer heatSurfaceAlloc=1 "Heat transfer area to be considered"          annotation(dialog(group="Geometry"),choices(choice=1 "Lateral surface",
                                                                                   choice=2 "Inner heat transfer surface"));

protected
    parameter Modelica.SIunits.Density rho_nom= TILMedia.VLEFluidFunctions.density_phxi(medium, p_nom, h_nom) "Nominal density";

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Variables and model instances ~~~~~~~~~~~~

  Modelica.SIunits.SpecificEnthalpy h_out;
  Modelica.SIunits.SpecificEnthalpy h_in;
  inner Modelica.SIunits.SpecificEnthalpy h(start=h_start);

  Real drhodt;//(unit="kg/(m3s)");

public
  Modelica.SIunits.Mass mass "Total system mass";
  inner ClaRa.Basics.Units.Pressure
                                p(start=p_start, stateSelect=StateSelect.prefer) "System pressure";
public
  ClaRa.Basics.Interfaces.FluidPortIn      inlet(Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut      outlet(  Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  ClaRa.Basics.Interfaces.HeatPort_a heat annotation (Placement(transformation(extent={{84,86},
            {104,106}}),        iconTransformation(
         extent={{-10,-10},{10,10}},
         rotation=90,
         origin={0,100})));

   Summary summary(inlet(showExpertSummary = showExpertSummary,m_flow=inlet.m_flow,  T=fluidIn.T, p=inlet.p, h=fluidIn.h,s=fluidIn.s, steamQuality=fluidIn.q, H_flow=fluidIn.h*inlet.m_flow, rho=fluidIn.d),
                   fluid(showExpertSummary = showExpertSummary, mass=mass, p=p, h=h, T=bulk.T,s=bulk.s, steamQuality=bulk.q, H=h*mass, rho=bulk.d),
                   outlet(showExpertSummary = showExpertSummary,m_flow = -outlet.m_flow, T=fluidOut.T, p=outlet.p, h=fluidOut.h, s=fluidOut.s, steamQuality=fluidOut.q, H_flow=-fluidOut.h*outlet.m_flow, rho=fluidOut.d),
    outline(
      volume_tot=geo.volume,
      A_heat=geo.A_heat[heatSurfaceAlloc],
      Delta_p=inlet.p - outlet.p,
      Q_flow_tot=heat.Q_flow))
    annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));
public
  TILMedia.VLEFluid_ph  fluidIn(vleFluidType =    medium, final p=inlet.p, final  h=h_in,
    computeTransportProperties=true,
    computeVLETransportProperties=true,
    computeVLEAdditionalProperties=true)                                                        annotation (Placement(transformation(extent={{-90,-10},
            {-70,10}},                                                                                                    rotation=0)));
  TILMedia.VLEFluid_ph  fluidOut(vleFluidType =    medium, p=outlet.p, h=h_out,
    computeTransportProperties=true,
    computeVLETransportProperties=true,
    computeVLEAdditionalProperties=true)                                         annotation(Placement(transformation(extent={{70,-10},
            {90,10}},                                                                                                    rotation=0)));

protected
  inner TILMedia.VLEFluid_ph  bulk(vleFluidType =    medium, p=p, h=h,
    computeVLEAdditionalProperties=true,
    computeVLETransportProperties=true,
    computeTransportProperties=true)                                                 annotation (Placement(transformation(extent={{-10,-10},
            {10,10}},                                                                                                    rotation=0)));

public
 HeatTransfer heattransfer(
 final heatSurfaceAlloc=heatSurfaceAlloc)
    annotation(Placement(transformation(extent={{-80,60},{-60,80}})));
  inner Geometry geo annotation (Placement(transformation(extent={{-48,60},
            {-28,80}})));
  PhaseBorder phaseBorder annotation (Placement(transformation(extent={{-18,60},{2,80}})));
  PressureLoss pressureLoss annotation (Placement(transformation(extent={{12,60},
            {32,80}})));

protected
  inner ClaRa.Basics.Records.IComVLE_L2 iCom(
    mass=mass,
    h_in=h_in,
    h_out=h_out,
    p_in=inlet.p,
    p_out=outlet.p,
    m_flow_in=inlet.m_flow,
    m_flow_out=outlet.m_flow,
    h_nom=h_nom,
    T_in=fluidIn.T,
    T_out=fluidOut.T,
    p_nom=p_nom,
    m_flow_nom=m_flow_nom,
    xi_in=fluidIn.xi,
    xi_out=fluidOut.xi,
    T_bulk=bulk.T,
    mediumModel=medium,
    p_bulk=bulk.p,
    h_bulk=bulk.h,
    xi_bulk=bulk.xi,
    fluidPointer_bulk=bulk.vleFluidPointer,
    fluidPointer_in=fluidIn.vleFluidPointer,
    fluidPointer_out=fluidOut.vleFluidPointer,
    xi_nom=zeros(medium.nc)) "Internal communication record" annotation (Placement(transformation(extent={{-80,-102},{-60,-82}})));
//     shape=geo.shape,
equation

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Asserts ~~~~~~~~~~~~~~~~~~~
  assert(geo.volume>0, "The system volume must be greater than zero!");
  assert(geo.A_heat[heatSurfaceAlloc]>=0, "The area of heat transfer must be greater than zero!");

//~~~~~~~~~~~~~~~~~~~~~~~~~~~
// System definition ~~~~~~~~
   mass= if useHomotopy then geo.volume*homotopy(bulk.d,rho_nom) else geo.volume*bulk.d;
 // der(mass)=drhodt*geo.V;
   drhodt*geo.volume=inlet.m_flow + outlet.m_flow "Mass balance";
   drhodt=der(p)*bulk.drhodp_hxi
                             + der(h)*bulk.drhodh_pxi;
                                                   //calculating drhodt from state variables

    der(h) =  if useHomotopy then homotopy((inlet.m_flow*h_in + outlet.m_flow*h_out + geo.volume*der(p) + heat.Q_flow - h*geo.volume*drhodt), (m_flow_nom*h_in - m_flow_nom*h_out  + geo.volume*der(p) + heat.Q_flow - h*geo.volume*drhodt))/mass
    else (inlet.m_flow*h_in + outlet.m_flow*h_out  + geo.volume*der(p) + heat.Q_flow - h*geo.volume*drhodt)/mass "Energy balance";

    inlet.h_outflow=phaseBorder.h_inflow;
    outlet.h_outflow=phaseBorder.h_outflow;

//      h_in= if useHomotopy then homotopy(actualStream(inlet.h_outflow), h) else actualStream(inlet.h_outflow);
//      h_out= if useHomotopy then homotopy(actualStream(outlet.h_outflow), h) else actualStream(outlet.h_outflow);

  h_in= if useHomotopy then homotopy(actualStream(inlet.h_outflow), inStream(inlet.h_outflow)) else actualStream(inlet.h_outflow);
  h_out= if useHomotopy then homotopy(actualStream(outlet.h_outflow), outlet.h_outflow) else actualStream(outlet.h_outflow);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  In the following equations dividing the friction pressure loss into two parts located at the inlet and outlet side respectively leads
//  to a disadvatageous coupling of flow model cascades and iteration of mass flow rates in some applications.
//    inlet.p  =  p + pressureLoss.Delta_p/2 + phaseBorder.dp_geo_in;
//    outlet.p = p - pressureLoss.Delta_p/2 + phaseBorder.dp_geo_out;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

   inlet.p  =p + pressureLoss.Delta_p + phaseBorder.Delta_p_geo_in;
   outlet.p =p + phaseBorder.Delta_p_geo_out "The friction term is lumped at the inlet side to avoid direct coupling of two flow models, this avoids aniteration of mass flow rates in some application cases";

// No chemical reaction taking place:
  inlet.xi_outflow   = inStream(outlet.xi_outflow);
  outlet.xi_outflow  = inStream(inlet.xi_outflow);

initial equation
//  vleFluid.h=(vleFluid.VLE.h_v + 1 - initialFillingLevel*(vleFluid.VLE.h_v + 1 - vleFluid.VLE.h_l*vleFluid.VLE.d_l/vleFluid.VLE.d_v))/(initialFillingLevel*(vleFluid.VLE.d_l/vleFluid.VLE.d_v - 1) + 1);
  //INIT.feedwatertank.h_cond_out
 // mass=geo.V*bulk.d;
  if initType==ClaRa.Basics.Choices.Init.steadyState then
    der(h)=0;
    der(p)=0;
  elseif initType==ClaRa.Basics.Choices.Init.steadyPressure then
    der(p)=0;
  elseif initType==ClaRa.Basics.Choices.Init.steadyEnthalpy then
    der(h)=0;
  end if;

equation
  connect(heattransfer.heat, heat) annotation (Line(
      points={{-60,70},{-60,86},{94,86},{94,96}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics), Diagram(graphics),
    Documentation(info="<html>
<p><b>Model description: </b>A non-adiabatic control volume without friction losses taking the geostatic pressure difference into account</p>
<p><b>Contact:</b> Friedrich Gottelt, Johannes Brunnemann, XRG Simulation GmbH</p>
<p><ul>
<li>This model uses TILMedia</li>
<li>This model is derived from ThermoPower.Water.Header</li>
<li>Flow reversal is supported</li>
<li>Homotopy initialisation is supported</li>
</ul></p>
</html>"));
end VolumeVLE_2;
