within ClaRa.Components.VolumesValvesFittings.Pipes;
model Tube_FlueGas_L2_Simple "A single 1D tube-shaped control volume considering heat transfer in a straight pipe with static momentum balance and simple energy balance"
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

  extends ClaRa.Basics.Icons.Pipe_L2;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");

  import SI = ClaRa.Basics.Units;
  import Modelica.Constants.eps;

  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=noEvent(if sum(heat.Q_flow) > 0 then sum(heat.Q_flow) else 0),
    powerOut=if not heatFlowIsLoss then -sum(heat.Q_flow) else 0,
    powerAux=0) if  contributeToCycleSummary;
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation" annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean heatFlowIsLoss = true "True if negative heat flow is a loss (not a process product)" annotation(Dialog(tab="Summary and Visualisation"));

  outer ClaRa.SimCenter simCenter;

//## S U M M A R Y   D E F I N I T I O N #######################################################################
  record Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary annotation(Dialog(hide));

    parameter Basics.Units.Length
                        length "Length of pipe";
    input Basics.Units.Area
                  A_cross if  showExpertSummary "Cross sectional area" annotation(Dialog(show));
    input Basics.Units.Area
                  A_wall if  showExpertSummary "Total wall area" annotation(Dialog(show));
    input Basics.Units.Volume
                    volume_tot "Total volume of system" annotation(Dialog(show));

    parameter Integer N_cv "|Discretisation|Number of finite volumes";
    parameter Integer N_wall "|Discretisation|Number of wall elements";
    input Basics.Units.Length
                    Delta_x[N_cv] if  showExpertSummary "Pipe discretisation" annotation(Dialog(show));
    input Basics.Units.Volume
                    volume[N_cv] if  showExpertSummary "|Discretisation|Cell volumes"       annotation(Dialog(show));

    input Basics.Units.Pressure
                      dp "Pressure difference between outlet and inlet" annotation(Dialog);
    input Basics.Units.Mass
                  mass_tot "Total fluid mass in system mass"  annotation(Dialog(show));
    input Basics.Units.Enthalpy
                      H_tot if showExpertSummary "Total system enthalpy" annotation(Dialog(show));
    input Basics.Units.HeatFlowRate
                          Q_flow_tot "Heat flow through entire pipe wall"     annotation(Dialog);

    input Basics.Units.Mass
                  mass[N_cv] if showExpertSummary "Fluid mass in cells" annotation(Dialog(show));
    input Basics.Units.Momentum
                      I[N_cv+1] if  showExpertSummary "Momentum of fluid flow volumes through cell borders"     annotation(Dialog(show));
    input Basics.Units.Force
                   I_flow[N_cv+2] if showExpertSummary "Momentum flow through cell borders"     annotation(Dialog(show));
    input Basics.Units.MassFlowRate
                          m_flow[N_cv+1] if  showExpertSummary "Mass flow through cell borders"
                                                                          annotation(Dialog(show));
  end Outline;

  record Wall_L2
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary annotation(Dialog(hide));
    parameter Integer N_wall "Number of wall segments"  annotation(Dialog(hide));
    input Basics.Units.Temperature
                         T[N_wall] if  showExpertSummary "Temperatures of wall segments"
                                              annotation(Dialog);
    input Basics.Units.HeatFlowRate
                          Q_flow[N_wall] if  showExpertSummary "Heat flows through wall segments"
                                              annotation(Dialog);
  end Wall_L2;

  record Summary
     extends ClaRa.Basics.Icons.RecordIcon;
     Outline outline;
     ClaRa.Basics.Records.FlangeGas           inlet;
     ClaRa.Basics.Records.FlangeGas           outlet;
     ClaRa.Basics.Records.FluidVLE_L2           fluid;
     Wall_L2 wall;
  end Summary;

//## P A R A M E T E R S #######################################################################################

//____Geometric data_____________________________________________________________________________________
  inner parameter Basics.Units.Length
                            length= 1 "|Geometry|Length of the pipe";
  inner parameter Basics.Units.Length
                            diameter_i= 0.1 "|Geometry|Inner diameter of the pipe";

  parameter Integer N_tubes= 1 "|Geometry|Number Of parallel pipes";

protected
  final parameter Basics.Units.Volume
                            volume[N_cv]=Modelica.Constants.pi/4*diameter_i^2*Delta_x*N_tubes;

  final inner parameter Basics.Units.Area
                                A_cross[N_cv]=ones(N_cv)*Modelica.Constants.pi/4*diameter_i^2*N_tubes "cross area of volume elements";
  final inner parameter Basics.Units.Area
                                A_cross_FM[N_cv+1]=
   cat(1, {A_cross[1]}, {(A_cross[i]+A_cross[i+1])/2 for i in 1:N_cv-1},  {A_cross[N_cv]}) "cross area of flow model volume elements";

//____Discretisation_____________________________________________________________________________________
public
  inner parameter Integer N_cv=2 "|Discretisation|Number of finite volumes";
  final inner parameter Basics.Units.Length
                                  Delta_x[N_cv]=ones(N_cv)*length/N_cv "|Discretisation|DisWall_L4cretisation scheme";
  final inner parameter Basics.Units.Length
                                  Delta_x_FM[N_cv+1]=
  cat(1, {Delta_x[1]/2}, {(Delta_x[i-1]+Delta_x[i])/2 for i in 2:N_cv},  {Delta_x[N_cv]/2}) "length of flow model volume elements";

//____Media Data_____________________________________________________________________________________
 inner parameter TILMedia.GasTypes.BaseGas               medium = simCenter.flueGasModel "Medium to be used in tube"
                                 annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

//____Nominal Values_________________________________________________________________________________
public
 parameter Basics.Units.Pressure
                       p_nom[N_cv]= 1e5*ones(N_cv) "|Nominal Values|nominal pressure";
 parameter Basics.Units.Temperature T_nom[
                                         N_cv]= 293.15*ones(N_cv) "|Nominal Values|Nominal specific enthalpy for single tube";
 parameter Basics.Units.EnthalpyMassSpecific
                                   h_nom[N_cv]= ones(N_cv)*1e5 "|Nominal Values|Nominal specific enthalpy for single tube";
 inner parameter Basics.Units.MassFlowRate
                                 m_flow_nom=100 "|Nominal Values|Nominal mass flow w.r.t. all parallel tubes";

 inner parameter Basics.Units.Pressure
                                 Delta_p_nom=1e4 "|Nominal Values|Nominal pressure loss w.r.t. all parallel tubes";

  final parameter Basics.Units.DensityMassSpecific
                                      rho_nom[N_cv]= TILMedia.GasFunctions.density_pTxi(medium, p_nom, T_nom, xi_start) "Nominal density";

//____Physical Effects_____________________________________________________________________________________

public
  inner parameter Boolean frictionAtInlet=false "|Fundamental Definitions|True if pressure loss between first cell and inlet shall be considered"
                                                                                            annotation (choices(checkBox=true));
  inner parameter Boolean frictionAtOutlet=false "|Fundamental Definitions|True if pressure loss between last cell and outlet shall be considered"
                                                                                            annotation (choices(checkBox=true));

  replaceable model PressureLoss =
    ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseGas_L4 "|Physical Effects|Pressure Loss|Pressure loss model at the tubes side"
    annotation(choicesAllMatching);

   replaceable model HeatTransfer =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4
     constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas_L4 "|Physical Effects|Heat Transfer|Heat transfer mode at the tubes side"
    annotation(choicesAllMatching);

   replaceable model Geometry =
      Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry_N_cv                             constrainedby Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry_N_cv "|Physical Effects|Geometry|Pipe geometry"
   annotation(choicesAllMatching);

//____Initialisation_____________________________________________________________________________________
  parameter ClaRa.Basics.Choices.Init initType=ClaRa.Basics.Choices.Init.steadyState "|Initialisation|Model Settings|type of initialisation "
                                                              annotation(choicesAllMatching);
  inner parameter Boolean useHomotopy=simCenter.useHomotopy "|Initialisation|Model Settings|true, if homotopy method is used during initialisation";

  parameter Basics.Units.Temperature T_start[
                                            N_cv]=293.15*ones(N_cv) "|Initialisation||Initial temperature for single tube";
  parameter Basics.Units.Pressure
                        p_start[:]=1e5*ones(N_cv) "|Initialisation||Initial pressure";

  parameter Basics.Units.MassFraction xi_start[medium.nc - 1]=
     {0.01,0,0.1,0,0.74,0.13,0,0.02,0} "|Initialisation||Initial composition for single tube";
protected
  parameter Basics.Units.Pressure
                        p_start_internal[N_cv]=if size(p_start,1)==2 then linspace(p_start[1],p_start[2],N_cv) else p_start "Internal p_start array which allows the user to either state p_inlet, p_outlet if p_start has length 2, otherwise the user can specify an individual pressure profile for initialisation";
  parameter Basics.Units.Temperature
                        T_start_internal[N_cv]=if size(T_start,1)==2 then linspace(T_start[1],T_start[2],N_cv) else T_start "Internal T_start array which allows the user to either state T_inlet, T_outlet if T_start has length 2, otherwise the user can specify an individual Temperature profile for initialisation";

  parameter Basics.Units.EnthalpyMassSpecific h_start[N_cv]=TILMedia.GasFunctions.specificEnthalpy_pTxi(medium, p_start_internal, T_start_internal, xi_start) "|Initialisation||Initial specific enthalpy for single tube";

  parameter Basics.Units.DensityMassSpecific d_start[N_cv]=TILMedia.GasFunctions.density_pTxi(medium, p_start_internal, T_start_internal, xi_start) "|Initialisation||Initial density";

//____Summary and Visualisation_____________________________________________________________________________________
public
  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if an extended summary shall be shown, else false";
  parameter Boolean showData=false "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";

  Summary summary(
      outline(     showExpertSummary=showExpertSummary,
                   length=length,
                   A_cross=Modelica.Constants.pi/4*diameter_i^2*N_tubes,
                   A_wall= Modelica.Constants.pi*diameter_i*length*N_tubes,
                   volume_tot=sum(volume),
                   N_cv=N_cv,
                   N_wall=N_cv,
                   Delta_x=Delta_x,
                   volume=volume,
                   dp=outlet.p-inlet.p,
                   mass_tot=sum(mass),
                   H_tot=sum(h.*mass),
                   Q_flow_tot=sum(heat.Q_flow),
                   mass=mass,
                   I=Delta_x_FM.*m_flow,
                   I_flow=cat(1,{w_inlet*abs(w_inlet)*fluidInlet.d*A_cross[1]},{w[i]*abs(w[i])*fluid[i].d*A_cross[i] for i in 1:N_cv},{w_outlet*abs(w_outlet)*fluidOutlet.d*A_cross[N_cv]}),
                   m_flow=m_flow),
       inlet(      m_flow=inlet.m_flow,
                   T=fluidInlet.T,
                   p=fluidInlet.p,
                   h=fluidInlet.h,
                   H_flow=H_flow[1]),
      outlet(      m_flow=-outlet.m_flow,
                   T=fluidOutlet.T,
                   p=fluidOutlet.p,
                   h=fluidOutlet.h,
                   H_flow=H_flow[N_cv+1]),
      fluid(       showExpertSummary=showExpertSummary,
                   mass=mass[N_cv],
                   T=fluid[N_cv].T,
                   p=p[N_cv],
                   h=h[N_cv],
                   s=fluid[N_cv].s,
                   steamQuality=0,
                   H=mass[N_cv]*h[N_cv],
                   rho=fluid[N_cv].d),
      wall(        showExpertSummary=showExpertSummary,
                   N_wall=N_cv,
                   T=heat.T,
                   Q_flow=heat.Q_flow))
  annotation (Placement(transformation(extent={{-60,-52},{-40,-34}})));

//## V A R I A B length E   P A R T#######################################################################################

//____Energy / Enthalpy_________________________________________________________________________________________
public
  Basics.Units.EnthalpyMassSpecific
                          h[N_cv](start=h_start,stateSelect = StateSelect.prefer) "Cell enthalpy";

   Basics.Units.Temperature
                          T[N_cv](start=T_start) "Cell Temperature";
    SI.Temperature T_in[N_cv];
    SI.Temperature T_out[N_cv];

//____Pressure__________________________________________________________________________________________________
protected
 Basics.Units.Pressure
             p[N_cv](nominal=p_nom,start=p_start_internal) "Cell pressure";
 Basics.Units.Pressure
             Delta_p_fric[N_cv+1] "Pressure difference due to friction";

//____Mass and Density__________________________________________________________________________________________
  Basics.Units.Mass
          mass[N_cv] "Mass of fluid in cells";
  Basics.Units.Mass
          mass_FM[N_cv+1]=cat(1,{mass[1]/2},{(mass[i]+mass[i-1])/2 for i in 2:N_cv},{mass[N_cv]/2}) "Mass of fluid in flow cells";

  Real drhodt[N_cv];//(unit="kg/(m3s)")

  Modelica.SIunits.MassFraction xi[N_cv,medium.nc - 1];
  Real[N_cv+1, medium.nc-1] Xi_flow;

//____Flows and Velocities______________________________________________________________________________________
  Basics.Units.Power
           H_flow[N_cv+1] "Enthalpy flow rate at cell borders";
  Basics.Units.MassFlowRate
                  m_flow[N_cv+1](nominal=ones(N_cv+1)*m_flow_nom,start=ones(N_cv+1)*m_flow_nom);

  Basics.Units.Velocity
              w[N_cv] "flow velocities within cells of energy model == flow velocities across cell borders of flow model ";
  Basics.Units.Velocity
              w_inlet "flow velocity at inlet";
  Basics.Units.Velocity
              w_outlet "flow velocity at outlet";

//____Connectors________________________________________________________________________________________________
public
  ClaRa.Basics.Interfaces.GasPortIn inlet(Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{-150,-10},{-130,10}}),
        iconTransformation(extent={{-150,-10},{-130,10}})));
  ClaRa.Basics.Interfaces.GasPortOut outlet(Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{130,-10},{150,10}}),
        iconTransformation(extent={{130,-10},{150,10}})));

   ClaRa.Basics.Interfaces.HeatPort_a
                                    heat[N_cv] annotation (Placement(transformation(extent={{-10,30},
            {10,50}}),          iconTransformation(
         extent={{-10,-10},{10,10}},
         rotation=90,
         origin={0,40})));
//___Instantiation of Replaceable Models___________________________________________________________________________

protected
  inner TILMedia.Gas_ph       fluid[N_cv](p=p, h=h, xi=xi, each gasType=medium,
    each computeTransportProperties=true)                                                      annotation (Placement(transformation(extent={{-10,-40},
            {10,-20}},                                                                                                   rotation=0)));
public
  PressureLoss pressureLoss "Pressure loss model"
                            annotation(Placement(transformation(extent={{-40,0},
            {-20,20}})));
  HeatTransfer heatTransfer(final A_heat=N_tubes*Modelica.Constants.pi*diameter_i*Delta_x) "heat transfer model" annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

public
  inner TILMedia.Gas_pT       fluidInlet(
    p=inlet.p,
    T=noEvent(actualStream(inlet.T_outflow)),
    xi=noEvent(actualStream(inlet.xi_outflow)),
    gasType=medium) "Gas object at inlet port"     annotation (Placement(transformation(extent={{-90,-30},
            {-70,-10}},                                                                                                  rotation=0)));

  inner TILMedia.Gas_pT       fluidOutlet(
    gasType=medium,
    T=noEvent(actualStream(outlet.T_outflow)),
    p=outlet.p,
    xi=noEvent(actualStream(outlet.xi_outflow))) "Gas object at outlet port"
                                                              annotation (Placement(transformation(extent={{70,-30},
            {90,-10}},                                                                                                   rotation=0)));
protected
  inner Basics.Records.IComGas_L3 iCom(
    mediumModel=medium,
    xi=xi,
    N_cv=N_cv,
    volume=volume,
    p_in={inlet.p},
    T_in={fluidInlet.T},
    m_flow_in={inlet.m_flow},
    h_in={fluidInlet.h},
    xi_in={fluidInlet.xi},
    xi_out={fluidOutlet.xi},
    p_out={outlet.p},
    T_out={fluidOutlet.T},
    m_flow_out={outlet.m_flow},
    h_out={fluidOutlet.h},
    p_nom=p_nom[1],
    Delta_p_nom=Delta_p_nom,
    m_flow_nom=m_flow_nom,
    h_nom=h_nom[1],
    T=fluid.T,
    p=p,
    h=h,
    fluidPointer_in={fluidInlet.gasPointer},
    fluidPointer_out={fluidOutlet.gasPointer},
    fluidPointer=fluid.gasPointer,
    final N_inlet=1,
    final N_outlet=1) annotation (Placement(transformation(extent={{-80,-52},{-60,-34}})));

    inner Geometry geo(
    N_cv=N_cv,
    length = length,
    diameter = diameter_i,
    z_in = 0,
    z_out = 0)    annotation (Placement(transformation(extent={{0,0},{20,20}})));

//### E Q U A T I O N P A R T #######################################################################################
//-------------------------------------------
//initialisation

public
  Basics.Interfaces.EyeOut       eye if showData      annotation(Placement(transformation(extent={{140,-50},
            {160,-30}}), iconTransformation(extent={{130,-48},{150,-28}})));
protected
  Basics.Interfaces.EyeIn       eye_int
    annotation (Placement(transformation(extent={{95,-41},{97,-39}})));

initial equation
// m_flow[1:N_cv+1]=inlet.m_flow*ones(N_cv+1);
  if initType == ClaRa.Basics.Choices.Init.steadyState then
    der(h)=zeros(N_cv);
    der(outlet.p)=0;
  elseif initType == ClaRa.Basics.Choices.Init.steadyPressure then
    der(p)=zeros(N_cv);
  elseif initType == ClaRa.Basics.Choices.Init.steadyEnthalpy then
    der(h)=zeros(N_cv);
  end if;

  for i in 1:N_cv loop
    xi[i,:]=xi_start[1:end];
  end for;

equation

  connect(heat, heatTransfer.heat) annotation (Line(
      points={{0,40},{0,28},{-61,28},{-61,19}},
      color={0,0,0},
      smooth=Smooth.None));

//-------------------------------------------
//flow velocities at inlet and outlet
  w_inlet=inlet.m_flow/(A_cross_FM[1]*fluidInlet.d);
  w_outlet=-outlet.m_flow/(A_cross_FM[N_cv+1]*fluidOutlet.d);

//flow velocities in cells
  for i in 1:N_cv loop
     w[i]=(m_flow[i]+m_flow[i+1])/(2*fluid[i].d*A_cross[i]);
  end for;

//-------------------------------------------
//data exchange with friction model
//   for i in 2:N_cv loop
//     pressureLoss.rho[i]=( if m_flow[i]>0 then fluid[i-1].d else fluid[i].d);
//     //pressure loss due to friction referring to total tube bundle (not a single tube).
//     m_flow[i]=pressureLoss.m_flow[i];
//   end for;
//   pressureLoss.rho[1]=(if m_flow[1]>0 then fluidInlet.d else fluid[1].d);
//   pressureLoss.rho[N_cv+1]=(if m_flow[N_cv+1]>0 then fluid[N_cv].d else fluidOutlet.d);

    for i in 2:N_cv loop
    pressureLoss.rho[i] = homotopy(ClaRa.Basics.Functions.Stepsmoother(
      1e-5,
      -1e-5,
      m_flow[i])*fluid[i - 1].d + ClaRa.Basics.Functions.Stepsmoother(
      -1e-5,
      1e-5,
      m_flow[i])*fluid[i].d, fluid[i - 1].d);
    //pressure loss due to friction referring to total component (not a single cell).
    m_flow[i]=pressureLoss.m_flow[i];
  end for;
  pressureLoss.rho[1] = homotopy(ClaRa.Basics.Functions.Stepsmoother(
    1e-5,
    -1e-5,
    m_flow[1])*fluidInlet.d + ClaRa.Basics.Functions.Stepsmoother(
    -1e-5,
    1e-5,
    m_flow[1])*fluid[1].d, fluidInlet.d);
  pressureLoss.rho[N_cv + 1] = homotopy(ClaRa.Basics.Functions.Stepsmoother(
    1e-5,
    -1e-5,
    m_flow[N_cv + 1])*fluid[N_cv].d + ClaRa.Basics.Functions.Stepsmoother(
    -1e-5,
    1e-5,
    m_flow[N_cv + 1])*fluidOutlet.d, fluid[N_cv].d);

  m_flow[1]=inlet.m_flow;
  m_flow[1]=pressureLoss.m_flow[1];
  m_flow[N_cv+1]=-outlet.m_flow;
  m_flow[N_cv+1]=pressureLoss.m_flow[N_cv+1];

//-------------------------------------------
//data exchange with heat transfer model
  heatTransfer.m_flow=m_flow[1:N_cv];

//-------------------------------------------
//pressure drop due to friction
  for i in 2:N_cv loop
    //pressure due to friction
    Delta_p_fric[i]=pressureLoss.Delta_p[i];
  end for;

    Delta_p_fric[N_cv+1]=pressureLoss.Delta_p[N_cv + 1];
    Delta_p_fric[1]=pressureLoss.Delta_p[1];

//-------------------------------------------
//Enthalpy flows
  for i in 2:N_cv loop
    H_flow[i] = if useHomotopy then homotopy(semiLinear(m_flow[i], h[i-1], h[i]), h[i-1]*m_flow_nom) else semiLinear(m_flow[i], h[i-1], h[i]);
    Xi_flow[i,:] = if useHomotopy then homotopy(semiLinear(m_flow[i],(xi[i-1,:] - xi[i,:]),(xi[i,:]- xi[i,:])),(xi[i-1,:]- xi[i,:])*m_flow_nom)  else semiLinear(m_flow[i],(xi[i-1,:] - xi[i,:]),(xi[i,:]- xi[i,:]));
  end for;
  H_flow[1] = if useHomotopy then homotopy(semiLinear(m_flow[1],fluidInlet.h, h[1]), fluidInlet.h*m_flow_nom) else semiLinear(m_flow[1],fluidInlet.h, h[1]);
  H_flow[N_cv+1]=if useHomotopy then homotopy(semiLinear(m_flow[N_cv+1], h[N_cv], fluidOutlet.h), h[N_cv]*m_flow_nom) else semiLinear(m_flow[N_cv+1], h[N_cv], fluidOutlet.h);
  Xi_flow[1,:] = if useHomotopy then homotopy(semiLinear(m_flow[1],(fluidInlet.xi[:]- xi[1,:]),(xi[1,:]- xi[1,:])),(fluidInlet.xi[:]- xi[1,:])*m_flow_nom) else semiLinear(m_flow[1],(fluidInlet.xi[:]- xi[1,:]),(xi[1,:]- xi[1,:]));
  Xi_flow[N_cv+1,:] = if useHomotopy then homotopy(semiLinear(m_flow[N_cv+1],(xi[N_cv,:]- xi[N_cv,:]),(fluidOutlet.xi[:]- xi[N_cv,:])),(xi[N_cv,:]- xi[N_cv,:])*m_flow_nom) else semiLinear(m_flow[N_cv+1],(xi[N_cv,:]- xi[N_cv,:]),(fluidOutlet.xi[:]- xi[N_cv,:]));

   for i in 2:N_cv-1 loop
     T_in[i] = if m_flow[i] > 0 then T[i-1] else T[i];
     T_out[i] = if m_flow[i+1] > 0 then T[i] else T[i+1];
   end for;

   T_in[1] = if m_flow[1] > 0 then inStream(inlet.T_outflow) else T[1];
   T_out[1] = if m_flow[2] > 0 then T[1] else T[2];
   T_in[N_cv] = if m_flow[N_cv] > 0 then T[N_cv-1] else T[N_cv];
   T_out[N_cv] = if m_flow[N_cv+1] > 0 then T[N_cv] else inStream(outlet.T_outflow);

//-------------------------------------------
//Fluid mass in cells
  mass = if useHomotopy then homotopy(volume.*fluid.d, volume.*d_start) else volume.*fluid.d;

//-------------------------------------------
// definition of the cells' states:
  for i in 1:N_cv loop

     der(h[i])= (H_flow[i]- H_flow[i+1]
                 + heat[i].Q_flow
                 + der(p[i])*volume[i]
                 - h[i]*volume[i]*drhodt[i])
                  /mass[i];

     der(xi[i,:]) = 1/mass[i]*(Xi_flow[i,:] - Xi_flow[i+1,:]) "Component mass balance";

    drhodt[i]*volume[i]=m_flow[i]-m_flow[i+1] "Mass balance";
//     fluid[i].drhodp_hxi
//                    *der(p[i])=(drhodt[i]-der(h[i])*fluid[i].drhodh_pxi)
//       "Calculate pressure from enthalpy and density derivative";
            fluid[i].drhodp_hxi*der(p[i])=(drhodt[i]-der(h[i])*fluid[i].drhodh_pxi - sum({fluid[i].drhodxi_ph[j] * der(fluid[i].xi[j]) for j in 1:medium.nc-1})) "Calculate pressure from enthalpy and density derivative";

    T[i]=fluid[i].T;
  end for;

//-------------------------------------------
// Static momentum balance:
// notice that for a static momentum balance we need to apply the same balance as homotopy start equation. Otherwise the equations become trivial.
// For now we leave the homotopy inside for future development
for i in 2:N_cv loop
    0 =if useHomotopy then homotopy(p[i-1] - p[i] - Delta_p_fric[i],p[i-1] - p[i] - Delta_p_fric[i]) else p[i-1] - p[i]- Delta_p_fric[i];
end for;

  inlet.T_outflow=T[1];
  outlet.T_outflow=T[N_cv];

//enable / disable pressure losses due to friction for flows  inlet --> first cell / last cell --> outlet
if  not frictionAtInlet and not frictionAtOutlet then //no friction pressure loss inlet->first cell / no friction pressure loss last cell->outlet
  inlet.p = fluid[1].p;
  outlet.p= fluid[N_cv].p;

elseif frictionAtInlet and not frictionAtOutlet then //friction pressure loss inlet->first cell / no friction pressure loss last cell->outlet
    0 =    if useHomotopy then homotopy(inlet.p - p[1] - Delta_p_fric[1],inlet.p - p[1] - Delta_p_fric[1])
                                 else inlet.p - p[1] - Delta_p_fric[1];
  outlet.p= fluid[N_cv].p;

elseif  not frictionAtInlet and frictionAtOutlet then//"no friction pressure loss inlet->first cell / friction pressure loss last cell->outlet"
  0 =    if useHomotopy then homotopy(p[N_cv] - outlet.p - Delta_p_fric[N_cv+1],p[N_cv] - outlet.p - Delta_p_fric[N_cv+1])
                                 else p[N_cv] - outlet.p - Delta_p_fric[N_cv+1];
  inlet.p = fluid[1].p;

else //friction pressure loss inlet->first cell / friction pressure loss last cell->outlet
  0 = if useHomotopy then homotopy(inlet.p - p[1] - Delta_p_fric[1],inlet.p - p[1] - Delta_p_fric[1])
                                 else inlet.p - p[1] - Delta_p_fric[1];
  0 =    if useHomotopy then homotopy(p[N_cv] - outlet.p - Delta_p_fric[N_cv+1],p[N_cv] - outlet.p - Delta_p_fric[N_cv+1])
                                 else p[N_cv] - outlet.p - Delta_p_fric[N_cv+1];

end if;

//-------------------------------------------
//xi
  inlet.xi_outflow[:] = xi[1, :];
  outlet.xi_outflow[:] = xi[N_cv, :];

//-------------------------------------------
//Summary:
    eye_int.m_flow=-outlet.m_flow;
    eye_int.T= fluid[N_cv].T-273.15;
    eye_int.s=fluid[N_cv].s/1e3;
    eye_int.p=fluid[N_cv].p/1e5;
    eye_int.h=fluidOutlet.h/1e3;

  connect(eye,eye_int)  annotation (Line(
      points={{150,-40},{96,-40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-140,-50},
            {140,50}}),
                   graphics), Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-140,-50},{140,50}}),
                                      graphics),
    Documentation(info="<html>
<p><b>Model description: </b>A non-adiabatic 1D-tube model using a single pipe cell for the formulation</p>
<p><b>Contact:</b> Johannes Brunnemann, XRG Simulation GmbH</p>
<p>
<b>FEATURES</b>
<ul>
<li>This model uses TILMedia</li>
<li>Flow reversal is supported</li>

<li>distributed pressure loss, i.e. pressure loss occurs in first and second half cell, whereas the state is located in the cell center</li>
</ul></p>
<b>TODO</b>
<ul>

</ul>


<h4>Staggered Grid Approach</h4>


<p>

</p>

<h4>State Definitions</h4>
<p>

</p>


</html>"));
end Tube_FlueGas_L2_Simple;
