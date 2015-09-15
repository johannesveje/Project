within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT;
model NusseltPipe1ph_L2 "Pipe Geo || L2 || HTC || Nusselt (1ph)"
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

    // TILMedia VLEFluidFunctions
  import fluidFunction_cp = TILMedia.VLEFluidFunctions.specificIsobaricHeatCapacity_phxi;
  import fluidFunction_lambda = TILMedia.VLEFluidFunctions.thermalConductivity_phxi;
  import fluidFunction_eta = TILMedia.VLEFluidFunctions.dynamicViscosity_phxi;
  import fluidFunction_rho = TILMedia.VLEFluidFunctions.density_phxi;

  // TILMedia VLEFluidObjectFunctions
  import fluidObjectFunction_cp = TILMedia.VLEFluidObjectFunctions.specificIsobaricHeatCapacity_phxi;
  import fluidObjectFunction_lambda = TILMedia.VLEFluidObjectFunctions.thermalConductivity_phxi;
  import fluidObjectFunction_eta = TILMedia.VLEFluidObjectFunctions.dynamicViscosity_phxi;
  import fluidObjectFunction_rho = TILMedia.VLEFluidObjectFunctions.density_phxi;

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HeatTransfer_L2;
  //extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferVLE;
  //extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferGas;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeType_L2;

  outer ClaRa.SimCenter simCenter;
//  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowCylinder             geo;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry geo;
  parameter Integer heatSurfaceAlloc=1 "To be considered heat transfer area"        annotation(dialog(enable=false,tab="Expert Setting"),choices(choice=1 "Lateral surface",
                                                                                   choice=2 "Inner heat transfer surface",
                                      choice=3 "Selection to be extended"));
//  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha_nom = (min(1e3*inVar_1ph_nom.lambda/inCon_1ph.d_hyd,FluidDissipation.HeatTransfer.StraightPipe.kc_overall(inCon_1ph, inVar_1ph_nom)));
protected
parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha_nom=FluidDissipation.HeatTransfer.StraightPipe.kc_overall(inCon_1ph, inVar_1ph_nom);
//    parameter ClaRa.Basics.Choices.HeatTransfer HTModel = ClaRa.Basics.Choices.HeatTransfer.pipeBoilingHor
//     "Type of two-phase heat transfer"  annotation(Dialog(group="Heat Transfer"));

public
  Modelica.SIunits.CoefficientOfHeatTransfer alpha;
  Real Re;

parameter Real CF_alpha_tubes=1;

  final parameter FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_con inCon_1ph(
      L=geo.length,
    roughness=FluidDissipation.Utilities.Types.Roughness.Neglected,
    d_hyd=geo.diameter)
    annotation (Placement(transformation(extent={{34,-100},{54,-80}})));

  final parameter FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_var inVar_1ph_nom(
    cp=fluidFunction_cp(iCom.mediumModel,iCom.p_nom,iCom.h_nom,iCom.xi_nom),
    eta=fluidFunction_eta(iCom.mediumModel,iCom.p_nom,iCom.h_nom,iCom.xi_nom),
    lambda=fluidFunction_lambda(iCom.mediumModel,iCom.p_nom,iCom.h_nom,iCom.xi_nom),
    rho=fluidFunction_rho(iCom.mediumModel,iCom.p_nom,iCom.h_nom,iCom.xi_nom),
    m_flow=noEvent(abs(iCom.m_flow_nom/geo.N_tubes)))
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_var inVar_1ph(
    cp=fluidObjectFunction_cp(iCom.p_out,iCom.h_out,iCom.xi_out,iCom.fluidPointer_out),
    lambda=max(1e-10, fluidObjectFunction_lambda(iCom.p_out,iCom.h_out,iCom.xi_out,iCom.fluidPointer_out)),
    rho=fluidObjectFunction_rho(iCom.p_out,iCom.h_out,iCom.xi_out,iCom.fluidPointer_out),
    eta=fluidObjectFunction_eta(iCom.p_out,iCom.h_out,iCom.xi_out,iCom.fluidPointer_out),
    m_flow=noEvent(max(0.0000001, abs(iCom.m_flow_in/geo.N_tubes))))
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));

equation
  Re=4*inVar_1ph.m_flow/inCon_1ph.d_hyd/Modelica.Constants.pi/inVar_1ph.eta;

  heat.Q_flow = alpha*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean; //Index 1 for shell surface

// defining the HTC for a straight pipe for ONE PHASE FLOW:

     alpha= CF_alpha_tubes* (if useHomotopy then homotopy(noEvent(min(1e4*inVar_1ph_nom.lambda/inCon_1ph.d_hyd,FluidDissipation.HeatTransfer.StraightPipe.kc_overall(inCon_1ph, inVar_1ph))),
                                                 alpha_nom*abs(sum(iCom.m_flow_in)/geo.N_tubes)/sum(iCom.m_flow_nom)/geo.N_tubes)
     else noEvent(min(1e4*inVar_1ph_nom.lambda/inCon_1ph.d_hyd,FluidDissipation.HeatTransfer.StraightPipe.kc_overall(inCon_1ph, inVar_1ph))));

//  alpha= if useHomotopy then homotopy(FluidDissipation.HeatTransfer.StraightPipe.kc_overall(inCon_1ph, inVar_1ph),
//                                                 alpha_nom*abs(sum(iCom.m_flow_in)/geo.N_tubes)/sum(iCom.m_flow_nom)/geo.N_tubes)
//     else FluidDissipation.HeatTransfer.StraightPipe.kc_overall(inCon_1ph, inVar_1ph);

end NusseltPipe1ph_L2;
