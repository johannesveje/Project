within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes;
model ParallelFlow_L3 "Pure parallel flow heatexchanger L3"
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

extends ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.GeneralHeatExchanger_L3(
    final a=0.671,
    final b=2.11,
    final c=0.534,
    final d=0.5);
extends ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Icons.HEX_ParallelFlow_Icon;
equation

  h_o_in[1] = iCom.h_o_inlet;
  h_o_in[2] = iCom.h_o_out[1];
  h_o_in[3] = iCom.h_o_out[2];

  h_i_in[1] = iCom.h_i_inlet;
  h_i_in[2] = iCom.h_i_out[1];
  h_i_in[3] = iCom.h_i_out[2];

  T_in2out_o=iCom.T_123_o[{1,2,3,4,5,6}];
  T_in2out_i=iCom.T_123_i[{1,2,3,4,5,6}];

  if outerPhaseChange then
    iCom.Delta_h_1ph = noEvent(if T_in2out_o[1] > T_in2out_i[1] then iCom.h_o_out[1]/1000 else -iCom.h_o_out[1]/1000)
               - noEvent(if T_in2out_o[1] > T_in2out_i[1] then iCom.h_o_vap/1000 else -iCom.h_o_bub/1000);
    iCom.Delta_h_2ph = noEvent(if T_in2out_o[1] > T_in2out_i[1] then iCom.h_o_out[2]/1000 else -iCom.h_o_out[2]/1000)
                - noEvent(if T_in2out_o[1] > T_in2out_i[1] then iCom.h_o_bub/1000 else -iCom.h_o_vap/1000);

  else
    iCom.Delta_h_1ph = noEvent(if T_in2out_o[1] > T_in2out_i[1] then -iCom.h_i_out[1]/1000 else -iCom.h_i_out[1]/1000)
              - noEvent(if T_in2out_o[1] > T_in2out_i[1] then -iCom.h_i_bub/1000 else -iCom.h_i_vap/1000);
    iCom.Delta_h_2ph = noEvent(if T_in2out_o[1] > T_in2out_i[1] then -iCom.h_i_out[2]/1000 else iCom.h_i_out[2]/1000)
              - noEvent(if T_in2out_o[1] > T_in2out_i[1] then -iCom.h_i_vap/1000 else iCom.h_i_bub/1000);

  end if;

  yps[1] = yps_1ph;
  yps[2] = noEvent(max(0,min(1-yps_1ph, yps_2ph)));
  yps[3] = noEvent(max(0,min(1,1-yps[1]-yps[2])));
  ff_i ={1,1,1};
  ff_o ={1,1,1};

  z_o = {0, yps[1], yps[1], yps[1]+yps[2], yps[1]+yps[2], yps[1]+yps[2]+yps[3]};
  z_i=z_o;
  annotation (Icon(graphics),          Documentation(info="<html>
<p>VDI-Waermeatlas Chapter Ca5, 9th edition, VDI-Verlag, 2006</p>
</html>"));
end ParallelFlow_L3;
