within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL;
model QuadraticNominalPoint_L4 "Medium independent || Nominal point, property independent"
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

//   import
//     ClaRa.Basics.ControlVolumes.Fundamentals.FlowModels.FlowModelStructure;

 extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L4;

//  outer ClaRa.Components.ComponentBaseClasses.Fundamentals2.PipeGeometry geo;

 parameter Modelica.SIunits.Pressure Delta_p_smooth=iCom.Delta_p_nom/iCom.N_cv*0.2 "|Small Mass Flows|For pressure losses below this value the square root of the quadratic pressure loss model is regularised";

 final parameter FluidDissipation.Utilities.Types.PressureLossCoefficient zeta_TOT = iCom.Delta_p_nom/iCom.m_flow_nom^2 "Pressure loss coefficient for total pipe";
protected
 FluidDissipation.Utilities.Types.PressureLossCoefficient zeta[iCom.N_cv+1] "Pressure loss coefficient for total pipe";

equation
// Note that we want distribute zeta linearly over tha pipe length. Hence use zeta[i]=zeta_TOT*Delta_x_FM[i]/(L -Delta_x_FM[1]-Delta_x_FM[N_cv+1] ) <-- notice that the last two terms depend on the flow model
// for the homotopy equation we use a linear function depending on the nominal pressure difference and mass flow and the actual pressure difference.
// Notice that we have to use the rugularised square root in order to allow for negative initial pressure losses!
 if not frictionAtInlet and not frictionAtOutlet then
     for i in 2:iCom.N_cv loop
       zeta[i]=zeta_TOT*Delta_x_FM[i]/(sum(Delta_x_FM)-Delta_x_FM[1]-Delta_x_FM[iCom.N_cv+1]);
       m_flow[i] = if useHomotopy then homotopy(sqrt(1/zeta[i])* ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth), (iCom.Delta_p_nom/iCom.m_flow_nom)*Delta_x_FM[i]/(sum(Delta_x_FM)-Delta_x_FM[1]-Delta_x_FM[iCom.N_cv+1]) *Delta_p[i])
     else sqrt(1/zeta[i])* ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth);
      end for;
   zeta[1]=0;
   Delta_p[1]=0;
   zeta[iCom.N_cv+1]=0;
   Delta_p[iCom.N_cv+1]=0;

 elseif not frictionAtInlet and frictionAtOutlet then
   for i in 2:iCom.N_cv+1 loop
       zeta[i]=zeta_TOT*Delta_x_FM[i]/(sum(Delta_x_FM)-Delta_x_FM[1]);
       m_flow[i] = if useHomotopy then homotopy(sqrt(1/zeta[i])* ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth), (iCom.Delta_p_nom/iCom.m_flow_nom)*Delta_x_FM[i]/(sum(Delta_x_FM)-Delta_x_FM[1]-Delta_x_FM[iCom.N_cv+1]) *Delta_p[i])
     else sqrt(1/zeta[i])* ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth);
   end for;
   zeta[1]=0;
   Delta_p[1]=0;

 elseif frictionAtInlet and not frictionAtOutlet then
   for i in 1:iCom.N_cv loop
       zeta[i]=zeta_TOT*Delta_x_FM[i]/(sum(Delta_x_FM)-Delta_x_FM[iCom.N_cv+1]);
       m_flow[i] = if useHomotopy then homotopy(sqrt(1/zeta[i])* ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth), (iCom.Delta_p_nom/iCom.m_flow_nom)*Delta_x_FM[i]/(sum(Delta_x_FM)-Delta_x_FM[1]-Delta_x_FM[iCom.N_cv+1]) *Delta_p[i])
     else sqrt(1/zeta[i])* ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth);
   end for;
   zeta[iCom.N_cv+1]=0;
   Delta_p[iCom.N_cv+1]=0;

 else //FlowModel=FlowModelStructure.inlet_dp_innerPipe_dp_outlet
   for i in 1:iCom.N_cv+1 loop
       zeta[i]=zeta_TOT*Delta_x_FM[i]/(sum(Delta_x_FM));
       m_flow[i] = if useHomotopy then homotopy(sqrt(1/zeta[i])* ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth), (iCom.Delta_p_nom/iCom.m_flow_nom)*Delta_x_FM[i]/(sum(Delta_x_FM)-Delta_x_FM[1]-Delta_x_FM[iCom.N_cv+1]) *Delta_p[i])
     else sqrt(1/zeta[i])* ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth);
   end for;

 end if;

end QuadraticNominalPoint_L4;
