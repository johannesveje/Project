within ClaRa.Components.VolumesValvesFittings.Valves;
model ThreeWayValveGas_L1 "Three way valve for gaseous media, not suitable for back flows!"
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
  extends ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValve_baseGas;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");

  replaceable model PressureLoss =  ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticFrictionFlowAreaSymetric_TWV constrainedby ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.TWV_L1 "Pressure loss model" annotation(choicesAllMatching);

public
  parameter SI.Area effectiveFlowArea=7.85e-3 "Effective flow area for outlets"
    annotation(Dialog(group="Valve Parameters"));
//   parameter SI.Area effectiveFlowArea2=effectiveFlowArea1 "Effective flow area for outlet 2"
//     annotation(Dialog(group="Valve Parameters"));

  parameter SI.PressureDifference Delta_p_smooth = 100 "Below this value, root function is approximated linearly"
                                                                                 annotation(Dialog(tab = "Expert Settings", group="Numerical Robustness"));

parameter Boolean useStabilisedMassFlow=false "|Expert Settings|Numerical Robustness|";
    parameter SI.Time Tau= 0.001 "Time Constant of Stabilisation" annotation(Dialog(tab="Expert Settings", group = "Numerical Robustness", enable=useStabilisedMassFlow));

public
  record Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    //     Outline outline;
    ClaRa.Basics.Records.FlangeGas           inlet;
    ClaRa.Basics.Records.FlangeGas           outlet1;
    ClaRa.Basics.Records.FlangeGas           outlet2;
  end Summary;

   Summary summary(inlet(m_flow=inlet.m_flow,  T=gasIn.T, p=inlet.p, h=gasIn.h, H_flow= gasIn.h*inlet.m_flow),
                   outlet1(m_flow = -outlet1.m_flow, T=gasOut1.T, p=outlet1.p, h=gasOut1.h, H_flow= -gasOut1.h*outlet1.m_flow),
                   outlet2(m_flow = -outlet2.m_flow, T=gasOut2.T, p=outlet2.p, h=gasOut2.h, H_flow= -gasOut2.h*outlet2.m_flow))
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

inner ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.ICom_TWV iCom(
    p_in=inlet.p,
    p_out1=outlet1.p,
    p_out2=outlet2.p,
    rho_out1=gasOut1.d,
    rho_out2=gasOut2.d,
    opening_=splitRatio,
    m_flow_in=inlet.m_flow,
    rho_in=gasIn.d)      annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

    PressureLoss pressureLoss(useStabilisedMassFlow=useStabilisedMassFlow,
                              Tau=Tau,
                              Delta_p_smooth=Delta_p_smooth,
                              effectiveFlowArea1=effectiveFlowArea) annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

equation
  outlet1.m_flow = -pressureLoss.m_flow_1;
  outlet2.m_flow = -pressureLoss.m_flow_2;
  inlet.m_flow + outlet1.m_flow + outlet2.m_flow =0;

  // Isenthalpic state transformation (no storage and no loss of energy)
  inlet.T_outflow *(-inlet.m_flow) = (inStream(outlet1.T_outflow)*outlet1.m_flow + inStream(outlet2.T_outflow)*outlet2.m_flow);
  outlet1.T_outflow = inStream(inlet.T_outflow);
  outlet2.T_outflow = inStream(inlet.T_outflow);

  // No chemical reaction taking place:
  zeros(medium.nc-1)=inlet.xi_outflow *inlet.m_flow + (inStream(outlet1.xi_outflow)*outlet1.m_flow + inStream(outlet2.xi_outflow)*outlet2.m_flow);
  outlet1.xi_outflow = inStream(inlet.xi_outflow);
  outlet2.xi_outflow = inStream(inlet.xi_outflow);

annotation (
  Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,80}},
        grid={2,2}), graphics));
end ThreeWayValveGas_L1;
