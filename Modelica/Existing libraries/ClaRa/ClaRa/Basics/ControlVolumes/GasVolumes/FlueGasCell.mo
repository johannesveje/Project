within ClaRa.Basics.ControlVolumes.GasVolumes;
model FlueGasCell "A 0-d control volume for flue gas"
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
  outer ClaRa.SimCenter simCenter;

// ***************************** defintion of medium used in cell *************************************************
inner parameter TILMedia.GasTypes.BaseGas medium = simCenter.flueGasModel "Medium to be used in tubes"
                                  annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

// ************************* replacable models for heat transfer, pressure loss and geometry **********************
  replaceable model HeatTransfer =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L2 "1st: choose geometry definition | 2nd: edit corresponding record"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);
    replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2 "1st: choose geometry definition | 2nd: edit corresponding record"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

  replaceable model Geometry =
      ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry "1st: choose geometry definition | 2nd: edit corresponding record"
    annotation (Dialog(group="Geometry"), choicesAllMatching=true);

// ********************************************* Parmeters *******************************************

inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));
parameter Boolean allow_reverseFlow = true annotation(Evaluate=true, Dialog(tab="Advanced"));
parameter Boolean use_dynamicMassbalance = true annotation(Evaluate=true, Dialog(tab="Advanced"));
parameter Integer heatSurfaceAlloc=1 "Heat transfer area to be considered"          annotation(dialog(group="Geometry"),choices(choice=1 "Lateral surface",
                                                                                   choice=2 "Inner heat transfer surface"));
inner parameter Modelica.SIunits.MassFlowRate m_flow_nom= 10 "Nominal mass flow rates at inlet"
                                        annotation(Dialog(tab="General", group="Nominal Values"));

  inner parameter Modelica.SIunits.Pressure p_nom=1e5 "Nominal pressure"                    annotation(Dialog(group="Nominal Values"));
  inner parameter Modelica.SIunits.SpecificEnthalpy h_nom=1e5 "Nominal specific enthalpy"      annotation(Dialog(group="Nominal Values"));

inner parameter ClaRa.Basics.Choices.Init initType=ClaRa.Basics.Choices.Init.noInit "Type of initialisation"
                             annotation(Dialog(tab="Initialisation", choicesAllMatching));
  parameter Modelica.SIunits.Temperature T_start= 273.15 + 100.0 "Start value of system temperature"
                                        annotation(Dialog(tab="Initialisation"));
  final parameter Modelica.SIunits.SpecificEnthalpy h_start=
          TILMedia.GasFunctions.specificEnthalpy_pTxi(medium, p_start, T_start, xi_start) "Start value of system specific enthalpy";
//          TILMedia.GasFunctions.specificEnthalpy_pTxi(medium, p_start, T_start, xi_start[1:end-1]/sum(xi_start))
//    "Start value of system specific enthalpy";
  parameter Modelica.SIunits.Pressure p_start= 1.013e5 "Start value of sytsem pressure"
                                     annotation(Dialog(tab="Initialisation"));
  parameter Modelica.SIunits.MassFraction xi_start[medium.nc-1]=zeros(medium.nc-1) "Start value of sytsem mass fraction"
                                          annotation(Dialog(tab="Initialisation"));

protected
   Modelica.SIunits.SpecificEnthalpy h_out;
   Modelica.SIunits.SpecificEnthalpy h_in;
   inner Modelica.SIunits.SpecificEnthalpy h(start=h_start);
   Real drhodt;
   Modelica.SIunits.Mass mass;
   Modelica.SIunits.Pressure p(start=p_start);
  Modelica.SIunits.MassFraction xi[medium.nc-1]( start=xi_start) "mass fraction";
public
  HeatTransfer heattransfer
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  inner Geometry geo   annotation (Placement(transformation(extent={{-48,60},
            {-28,80}})));

  PressureLoss pressureLoss annotation (Placement(transformation(extent={{12,60},
            {32,80}})));

  ClaRa.Basics.Interfaces.GasPortIn inlet(Medium=medium, m_flow(min=if
          allow_reverseFlow then -Modelica.Constants.inf else 1e-5)) "Inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.GasPortOut outlet(Medium=medium, m_flow(max=if
          allow_reverseFlow then Modelica.Constants.inf else -1e-5)) "Outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  TILMedia.Gas_pT     flueGasInlet(gasType = medium, p=inlet.p, T=noEvent(actualStream(inlet.T_outflow)), xi=noEvent(actualStream(inlet.xi_outflow)))
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  TILMedia.Gas_pT     flueGasOutlet(gasType = medium, p=outlet.p, T=noEvent(actualStream(outlet.T_outflow)), xi=noEvent(actualStream(outlet.xi_outflow)))
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  inner TILMedia.Gas_ph     bulk(
    computeTransportProperties=false,
    gasType = medium,p=p,h=h,xi=xi,
    stateSelectPreferForInputs=true)
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));

  ClaRa.Basics.Interfaces.HeatPort_a
                                   heat
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  //Summary

  record Outline
   extends ClaRa.Basics.Icons.RecordIcon;
   ClaRa.Basics.Units.Volume volume_tot "Total volume";
   ClaRa.Basics.Units.Area A_heat "Heat transfer area";
   ClaRa.Basics.Units.HeatFlowRate Q_flow_tot "Total heat flow rate";
   ClaRa.Basics.Units.PressureDifference Delta_p "Pressure difference p_in - p_out";
  end Outline;

 record Gas
  extends ClaRa.Basics.Icons.RecordIcon;
  input ClaRa.Basics.Units.Mass m "Mass flow rate"
                                               annotation(Dialog);
  input ClaRa.Basics.Units.Temperature T "Temperature"
                                                   annotation(Dialog);
  input ClaRa.Basics.Units.Pressure p "Pressure"
                                             annotation(Dialog);
  input ClaRa.Basics.Units.EnthalpyMassSpecific h "Specific enthalpy"
                                                                  annotation(Dialog);
  input ClaRa.Basics.Units.Enthalpy H "Specific enthalpy"
                                                      annotation(Dialog);
  input ClaRa.Basics.Units.DensityMassSpecific rho "Specific enthalpy"
                                                                   annotation(Dialog);
 end Gas;

inner record Summary
   extends ClaRa.Basics.Icons.RecordIcon;
   Outline outline;
   ClaRa.Basics.Records.FlangeGas inlet;
   Gas gas;
   ClaRa.Basics.Records.FlangeGas outlet;
end Summary;

inner Summary    summary(outline(volume_tot=geo.volume, A_heat=geo.A_heat[heatSurfaceAlloc], Q_flow_tot=heat.Q_flow, Delta_p=inlet.p-outlet.p),
                   inlet(m_flow=inlet.m_flow,  T=inStream(inlet.T_outflow), p=inlet.p, h=flueGasInlet.h, H_flow=inlet.m_flow*flueGasInlet.h),
                   gas(m=mass, T=bulk.T, p=p, h=h, H=h*mass, rho=bulk.d),
                   outlet(m_flow=-outlet.m_flow,  T=outlet.T_outflow, p=outlet.p, h=flueGasOutlet.h, H_flow=-outlet.m_flow*flueGasOutlet.h))
    annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));

//iCom
protected
  inner ClaRa.Basics.Records.IComBase_L2 iCom(
    p_in=inlet.p,
    T_in=flueGasInlet.T,
    m_flow_in=inlet.m_flow,
    p_out=outlet.p,
    T_out=flueGasOutlet.T,
    m_flow_out=outlet.m_flow,
    T_bulk=bulk.T,
    p_bulk=bulk.p,
    p_nom=p_nom,
    m_flow_nom=m_flow_nom,
    h_nom=h_nom) annotation (Placement(transformation(extent={{-80,-102},{-60,-82}})));

equation
// Asserts ~~~~~~~~~~~~~~~~~~~
  assert(geo.volume>0, "The system volume must be greater than zero!");
  assert(geo.A_heat[heatSurfaceAlloc]>=0, "The area of heat transfer must be greater than zero!");
  if allow_reverseFlow then
    assert( 0==0, "Dummy");
    else
  assert(  not inlet.m_flow < 0, "Flow reversal at inlet, but allow_reverseFlow is set to FALSE!");
  assert( not outlet.m_flow > 0, "Flow reversal at outlet, but allow_reverseFlow is set to FALSE!");
  end if;

// Port connection
inlet.T_outflow  = bulk.T;
outlet.T_outflow = bulk.T;

  inlet.xi_outflow= xi;
  outlet.xi_outflow
                  = xi;

h_in=flueGasInlet.h;
h_out=flueGasOutlet.h;

mass = geo.volume * bulk.d;

/*
inlet.p=if useHomotopy then homotopy(p+pressureLoss.Delta_p + (geo.z_in-geo.z_out)*Modelica.Constants.g_n*bulk.d,
                                         p+pressureLoss.Delta_p + (geo.z_in-geo.z_out)*Modelica.Constants.g_n*d_nom)
            else p+pressureLoss.Delta_p + (geo.z_in-geo.z_out)*Modelica.Constants.g_n*bulk.d;*/

   inlet.p =  p + pressureLoss.Delta_p;// + (geo.z_in-geo.z_out)*Modelica.Constants.g_n*bulk.d;
   outlet.p = p;

// Mass balance
  if use_dynamicMassbalance then
    inlet.m_flow + outlet.m_flow  =  drhodt*geo.volume;
    der(xi) =
     1/mass * (inlet.m_flow*(flueGasInlet.xi - xi) + outlet.m_flow*(flueGasOutlet.xi - xi));
  else
    inlet.m_flow + outlet.m_flow  =  0;
    zeros(medium.nc-1) =
      (inlet.m_flow*(flueGasInlet.xi - xi) + outlet.m_flow*(flueGasOutlet.xi - xi));
  end if;

  if use_dynamicMassbalance then
    drhodt = bulk.drhodh_pxi * der(h)
             + bulk.drhodp_hxi * der(p)
             + sum({bulk.drhodxi_ph[i] * der(bulk.xi[i]) for i in 1:medium.nc-1});
  else
     drhodt = bulk.drhodh_pxi * der(h)
             + bulk.drhodp_hxi * der(p);
  end if;

  der(h) =  (inlet.m_flow*(h_in-h) + outlet.m_flow*(h_out-h)  + geo.volume*der(p) + heat.Q_flow)/mass "Energy balance";

//     der(h) =  if useHomotopy then homotopy((inlet.m_flow*h_in + outlet.m_flow*h_out  + geo.V*der(p) + heat.Q_flow - h*geo.V*drhodt), (m_flow_nom*h_in -m_flow_nom*h_out  + geo.V*der(p) + heat.Q_flow - h*geo.V*drhodt))/mass
//     else (inlet.m_flow*h_in + outlet.m_flow*h_out  + geo.V*der(p) + heat.Q_flow - h*geo.V*drhodt)/mass
//     "Energy balance";

  connect(heattransfer.heat, heat) annotation (Line(
      points={{-60,70},{-60,90},{0,90},{0,100}},
      color={0,0,255},
      smooth=Smooth.None));

initial equation
//  outlet.m_flow = m_flow_nom;
  if initType == ClaRa.Basics.Choices.Init.steadyState then
    der(h)=0;
    der(p)=0;
  elseif initType == ClaRa.Basics.Choices.Init.steadyPressure then
    der(p)=0;
  elseif initType == ClaRa.Basics.Choices.Init.steadyEnthalpy then
    der(h)=0;
  elseif initType == ClaRa.Basics.Choices.Init.steadyDensity then
    drhodt=0;
  end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}),
                                      graphics));
end FlueGasCell;
