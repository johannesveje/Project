within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes;
model CrossCounterFlow "cross-counter flow heatexchanger n tube rows and n passes"
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

extends ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.GeneralHeatExchanger(
    final a=C[1],
    final b=C[2],
    final c=C[3],
    final d=C[4]);
extends ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Icons.HEX_CrossCounterFlow_Icon;

parameter Integer N_rp "Number of tube rows and passes";

final parameter Real C[4]=
if N_rp==1 then {0.433,1.60,0.267,0.5}
 elseif
       N_rp==2 then {0.0737, 1.97, 0.533, 0.640}
 elseif
       N_rp==3 then {0.0332, 2.01, 0.540, 0.640}
 elseif
       N_rp==4 then {0.0188, 2.01, 0.540, 0.650}
 else
     {0,0,0,0.5};
  annotation (Icon(graphics),   Documentation(info="<html>
<p>VDI-Waermeatlas Chapter Ca5, 9th edition, VDI-Verlag, 2006</p>
</html>"));
end CrossCounterFlow;
