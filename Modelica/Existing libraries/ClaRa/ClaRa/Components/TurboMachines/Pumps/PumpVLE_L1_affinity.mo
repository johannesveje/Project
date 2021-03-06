within ClaRa.Components.TurboMachines.Pumps;
model PumpVLE_L1_affinity "A pump for VLE mitures based on affinity laws"
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

  import SI = ClaRa.Basics.Units;
  import pow = FluidDissipation.Utilities.Functions.General.SmoothPower;
  import SM = ClaRa.Basics.Functions.Stepsmoother;
  import Modelica.Constants.pi;
  import TILMedia.VLEFluidObjectFunctions.specificEnthalpy_psxi;
  extends ClaRa.Components.TurboMachines.Pumps.Pump_Base(V_flow(start=V_flow_max*V_flow_opt_));
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");
  //extends Modelica.Icons.UnderConstruction;
  parameter Boolean useMechanicalPort=false "|Fundamental Definitions|True, if a mechenical flange should be used";
  parameter Boolean steadyStateTorque=false "|Fundamental Definitions|True, if steady state mechanical momentum shall be used";
  parameter SI.RPM rpm_fixed = 60 "Constant rotational speed of pump"
                                        annotation (Dialog( group = "Fundamental Definitions", enable = not useMechanicalPort));

  parameter SI.RPM rpm_nom "|Characteristic field|Nomial rotational speed"
                                                                          annotation(Dialog(groupImage="modelica://ClaRa/figures/ParameterDialog/PumpCharField1.png"));
  parameter SI.VolumeFlowRate V_flow_max "|Characteristic field|Maximum volume flow rate at nominal speed";
  parameter SI.Pressure Delta_p_max "|Characteristic field|Maximum pressure difference at nominal speed";
  parameter Real exp_hyd= 0.5 "|Characteristic field|Exponent for affinity law";
  parameter Real drp_exp= 0 "|Characteristic field|droop of exp_hyd w.r.t. rpm";
  parameter Real eta_hyd_nom=0.8 "|Expert Settings|Hydraulic losses - refer to documentation for details|Max. hydraulic efficiency at nominal speed";
  parameter Real exp_rpm=2 "|Expert Settings|Hydraulic losses - refer to documentation for details|Loss exponent w.r.t. rpm";
  parameter Real V_flow_opt_(min=0.0, max=1) = 0.6 "|Expert Settings|Hydraulic losses - refer to documentation for details|Relative position of nest point at V_flow axis in p.u.";
  parameter Real exp_flow=2 "|Expert Settings|Hydraulic losses - refer to documentation for details|Loss exponent w.r.t. volume flow";
  parameter SI.RPM rpm_stirrS = rpm_nom/4 "|Expert Settings|Hydraulic losses - refer to documentation for details|RPM at which rotor starts to act like a stirrer";
  parameter SI.RPM rpm_stirrE= rpm_nom/5 "|Expert Settings|Hydraulic losses - refer to documentation for details|RPM at which rotor acta like a stirrer";
  parameter SI.Area clearSection= 1 "|Expert Settings|Non-Design operation - refer to documentation for details|Effective clear section of pump";

  parameter SI.VolumeFlowRate V_flow_leak = 0.00002 "|Expert Settings|Non-Design operation - refer to documentation for details|Leakage mass flow";
  parameter SI.Pressure Delta_p_eps= 100 "|Expert Settings|Numerical Robustness|Small pressure difference for linearisation around zero mass flow";
  parameter Boolean stabiliseDelta_p=false "|Expert Settings|Numerical Robustness|Avoid chattering due to small pressure differences between inlet and outlet at small mass flows";
  parameter SI.Time Tau_stab=1 "Stabiliser state time constant - refer to documentation for details."
                                                                                            annotation(Dialog(tab="Expert Settings",group="Numerical Robustness",enable=stabiliseDelta_p));

  parameter Modelica.SIunits.Inertia J "Moment of Inertia" annotation(Dialog(group="Time Response Definitions", enable= not steadyStateTorque));

record Outline
  extends ClaRa.Components.TurboMachines.Pumps.Fundamentals.Outline;
  input ClaRa.Basics.Units.RPM rpm "Pump revolutions per minute";
end Outline;

record Summary
  extends ClaRa.Basics.Icons.RecordIcon;
  Outline outline;
  ClaRa.Basics.Records.FlangeVLE           inlet;
  ClaRa.Basics.Records.FlangeVLE           outlet;
end Summary;
protected
  TILMedia.VLEFluidObjectFunctions.VLEFluidPointer ptr_iso=
      TILMedia.VLEFluidObjectFunctions.VLEFluidPointer(
      medium.concatVLEFluidName,
      0,
      medium.mixingRatio_propertyCalculation[1:end - 1]/sum(medium.mixingRatio_propertyCalculation),
      medium.nc_propertyCalculation,
      medium.nc,
      TILMedia.Internals.redirectModelicaFormatMessage()) "Pointer to external medium memory for isentropic expansion state";
public
  SI.VolumeFlowRate V_flow_maxrpm "Volume flow due to affinity law";
  SI.Pressure Delta_p_maxrpm "Maximum pressure difference at constant speed";
  SI.Pressure Delta_p_ps "Pressure pseudo state prevents chattering";

 //Modelica.SIunits.AngularVelocity omega;
  //SI.Power P_loss;
  SI.Power P_shaft "Mechanicl power at shaft";
  Modelica.SIunits.AngularAcceleration a "Angular acceleration of the shaft";
  Modelica.SIunits.Torque tau_fluid "Fluid torque";
  SI.RPM rpm "Rotational speed";
  constant SI.RPM rpm_eps = 1e-5 "Rotational speed";
  Real eta_hyd(start=eta_hyd_nom) "Hydraulic efficiency";
  SI.EnthalpyMassSpecific h_iso "Outlet enthalpy with isentropic compression";

  Summary summary(outline(rpm=rpm,V_flow=V_flow, P_hyd=P_hyd,Delta_p=Delta_p,head= Delta_p/(fluidIn.d*Modelica.Constants.g_n), NPSHa = (inlet.p - fluidIn.VLE.p_l)/(fluidIn.d*Modelica.Constants.g_n), eta_hyd= eta_hyd, eta_mech=1),
                  inlet(showExpertSummary = showExpertSummary,m_flow=inlet.m_flow, T=fluidIn.T, p=inlet.p, h=fluidIn.h, s=fluidIn.s, steamQuality = fluidIn.q, H_flow= fluidIn.h*inlet.m_flow,  rho=fluidIn.d),
    outlet(
      showExpertSummary=showExpertSummary,
      m_flow=-outlet.m_flow,
      T=fluidOut.T,
      p=outlet.p,
      h=fluidOut.h,
      s=fluidOut.s,
      steamQuality=fluidOut.q,
      H_flow=fluidOut.h*outlet.m_flow,
      rho=fluidOut.d))                                                                                                     annotation(Placement(transformation(
        extent={{-10,-11},{10,11}},
        origin={-70,-91})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft
    annotation (Placement(transformation(extent={{-10,62},{10,82}}),
        iconTransformation(extent={{-10,89},{10,109}})));

initial equation
 if stabiliseDelta_p then
  Delta_p_ps=Delta_p;
 end if;

equation
  if stabiliseDelta_p then
   der(Delta_p_ps)=(Delta_p-Delta_p_ps)/Tau_stab;
  else
    Delta_p_ps=Delta_p;
  end if;
//   if not steadyStateTorque then
//     rpm=5100;
//   end if;

//____________________ Mechanics ___________________________
  if useMechanicalPort then
    der(shaft.phi) = (2*pi*rpm/60);
    J*a*rpm = - tau_fluid*2*pi*rpm/60 + shaft.tau*2*pi*rpm/60 "Mechanical momentum balance";
  else
    rpm = rpm_fixed;
    shaft.phi = 0.0;
  end if;

  if (steadyStateTorque) then
    a = 0;
  else
    a = (2*pi/60)^2*der(rpm);
  end if;
  tau_fluid = if noEvent(2*pi*rpm/60<1e-8) then 0 else P_shaft/(2*pi*rpm/60);
//_____________________Asserts______________________________
  assert(rpm_stirrS>rpm_stirrE, "rpm where stirring effects starts to dominate shall be smaller than rpm at which pump is acting completely as a stirrer.");

//____________________ Affinity Laws _______________________
  V_flow_maxrpm = V_flow_max*rpm/rpm_nom;
  Delta_p_maxrpm = Delta_p_max*(rpm/rpm_nom)^2;

//____________________ Squared Characteristic ______________

//____________________ Calculate Power _____________________
  //P_hyd = (fluidOut.h - fluidIn.h)*inlet.m_flow;
   P_hyd= Delta_p*V_flow; // Approximate rel. error is approx. 3% due to the assumption of constant density.

//          if Delta_p_ps>1 and Delta_p_maxrpm - Delta_p_ps>1 then // design operation
//            h_iso_in = specificEnthalpy_psxi(fluidOut.p, fluidIn.s, fluidIn.xi, fluidIn.vleFluidPointer);
//            h_iso_out = specificEnthalpy_psxi(fluidOut.p, fluidIn.s, fluidIn.xi, fluidIn.vleFluidPointer);
//            V_flow =  pow((Delta_p_maxrpm - Delta_p)/Delta_p_max, Delta_p_eps/Delta_p_max, exp_hyd+drp_exp*(rpm-rpm_nom))*V_flow_max;
//            P_shaft = P_hyd/eta_hyd;
//            c=2;
//          elseif Delta_p_ps<=1 then //reversed pressure difference, pump behaves like a throttle
//            h_iso_in = inStream(inlet.h_outflow);
//            h_iso_out = inStream(inlet.h_outflow);
//            V_flow = clearSection * ClaRa.Basics.Functions.ThermoRoot(-Delta_p/fluidIn.d, 100);
//            P_shaft = 0;
//            c=1;
//          else //backflow due to non-sufficient shaft power, i.e. the rpm is too low
//            h_iso_in = inStream(inlet.h_outflow);
//            h_iso_out = inStream(outlet.h_outflow);
//            V_flow =  ClaRa.Basics.Functions.ThermoRoot((Delta_p_maxrpm - Delta_p)/Delta_p_max, Delta_p_eps/Delta_p_max)*V_flow_max;
//            P_shaft = (Delta_p_maxrpm*V_flow_leak)/eta_hyd;//It is stated that a minimum leakage flow is pumped.
//            c=3;
//          end if;

//     c = SM(Delta_p_eps,2*Delta_p_eps, Delta_p_ps) *1
//         +    SM(2*Delta_p_eps,Delta_p_eps, Delta_p_ps)  * SM(Delta_p_maxrpm-Delta_p_eps, Delta_p_maxrpm, Delta_p_ps) *2
//         +     SM(Delta_p_maxrpm, Delta_p_maxrpm-Delta_p_eps, Delta_p_ps)*3;

  h_iso = SM(-Delta_p_eps,Delta_p_eps, Delta_p_ps) * inStream(inlet.h_outflow)
           + SM(Delta_p_eps,-Delta_p_eps, Delta_p_ps) * SM(Delta_p_maxrpm-Delta_p_eps, Delta_p_maxrpm, Delta_p_ps) * specificEnthalpy_psxi(fluidOut.p, fluidIn.s, fluidIn.xi, ptr_iso)
           + SM(Delta_p_maxrpm, Delta_p_maxrpm-Delta_p_eps, Delta_p_ps)  * inStream(inlet.h_outflow);

//   h_iso_out = SM(0,Delta_p_eps, Delta_p_ps) * inStream(inlet.h_outflow)
//             + SM(Delta_p_eps,0, Delta_p_ps) * SM(Delta_p_maxrpm-Delta_p_eps, Delta_p_maxrpm, Delta_p_ps) * specificEnthalpy_psxi(fluidOut.p, fluidIn.s, fluidIn.xi, ptr_iso)
//             + SM(Delta_p_maxrpm, Delta_p_maxrpm-Delta_p_eps, Delta_p_ps)  * inStream(outlet.h_outflow);

  V_flow = SM(0,Delta_p_eps, Delta_p_ps)  *clearSection * ClaRa.Basics.Functions.ThermoRoot(-Delta_p/fluidIn.d, 100)
         + SM(+Delta_p_eps,0, Delta_p_ps)  * SM(Delta_p_maxrpm-Delta_p_eps, Delta_p_maxrpm, Delta_p_ps) * pow((Delta_p_maxrpm - Delta_p)/Delta_p_max, Delta_p_eps/Delta_p_max, exp_hyd+drp_exp*(rpm-rpm_nom))*V_flow_max
         + SM(Delta_p_maxrpm, Delta_p_maxrpm-Delta_p_eps, Delta_p_ps)   * ClaRa.Basics.Functions.ThermoRoot((Delta_p_maxrpm - Delta_p)/Delta_p_max, Delta_p_eps/Delta_p_max)*V_flow_max;

  P_shaft = SM(-Delta_p_eps,Delta_p_eps, Delta_p_ps)                                                        *0
          + SM(+Delta_p_eps,-Delta_p_eps, Delta_p_ps)  * SM(Delta_p_maxrpm-Delta_p_eps,Delta_p_maxrpm, Delta_p_ps)  * P_hyd/eta_hyd
          + SM(Delta_p_maxrpm,Delta_p_maxrpm-Delta_p_eps, Delta_p_ps)                                           *(Delta_p_maxrpm*V_flow_leak)/eta_hyd;

  eta_hyd = noEvent(max(0.001,SM(rpm_stirrS,rpm_stirrE,rpm)*(eta_hyd_nom*(rpm_nom/abs(rpm+rpm_eps))^exp_rpm) * SM(Delta_p_eps,0, Delta_p)*(1-abs(pow(SM(Delta_p_eps,-Delta_p_eps, Delta_p)*max(V_flow_leak,V_flow)/(max(V_flow_leak,V_flow_maxrpm)*V_flow_opt_) - 1, 0.1, exp_flow)))));
//   eta_hyd2 =               SM(2500,2000,rpm)*(eta_hyd_nom*(rpm_nom/abs(rpm+rpm_eps))^exp_rpm) * SM(Delta_p_eps,0, Delta_p)*(1-abs(pow(SM(Delta_p_eps,-Delta_p_eps, Delta_p)*max(V_flow_leak,V_flow)/(max(V_flow_leak,V_flow_maxrpm)*V_flow_opt_) - 1, 0.1, exp_flow)));

//____________________ Balance equations ___________________

  inlet.m_flow + outlet.m_flow = 0.0 "Mass balance";
  Delta_p= outlet.p - inlet.p "Momentum balance";
  outlet.h_outflow = SM(2*Delta_p_eps,Delta_p_eps, Delta_p_ps)* SM(Delta_p_maxrpm-Delta_p_eps, Delta_p_maxrpm, Delta_p_ps)*(h_iso - inStream(inlet.h_outflow))/eta_hyd +  inStream(inlet.h_outflow) "Application of eta_hyd's definition";
  //outlet.h_outflow = inStream(inlet.h_outflow) + max(0,P_hyd)/max(1e-5,inlet.m_flow);
//___________________ Boundary definition __________________
  inlet.h_outflow = SM(0,Delta_p_eps, Delta_p_ps)* SM(Delta_p_maxrpm-Delta_p_eps, Delta_p_maxrpm, Delta_p_ps)*(h_iso - inStream(outlet.h_outflow))/eta_hyd +  inStream(outlet.h_outflow);
//    inlet.h_outflow = inStream(outlet.h_outflow);;

  inlet.m_flow=V_flow*(SM(+Delta_p_eps,-Delta_p_eps, Delta_p)*fluidIn.d + SM(-Delta_p_eps,Delta_p_eps, Delta_p)*fluidOut.d);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(graphics));
end PumpVLE_L1_affinity;
