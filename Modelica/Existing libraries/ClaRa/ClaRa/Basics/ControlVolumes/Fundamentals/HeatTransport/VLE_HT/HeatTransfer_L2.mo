within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT;
partial model HeatTransfer_L2 " L2 || HT-BaseClass"

//  SI.Temperature T_mean "Mean temperature of Fluid";

//  outer ClaRa.Basics.Records.IComVLE iCom;
//  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L2;
extends ClaRa.Basics.Icons.Alpha;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE;
  outer ClaRa.Basics.Records.IComVLE_L2 iCom;

//   constant String vle = "true";

  outer parameter Boolean useHomotopy;

  parameter String temperatureDifference= "Logarithmic mean" "Temperature Difference"
                                            annotation(Dialog(group="Heat Transfer"), choices(choice="Arithmetic mean", choice="Logarithmic mean", choice="Inlet",  choice="Outlet"));

  SI.Temperature Delta_T_wi "Temperature difference between wall and fluid inlet temperature";
  SI.Temperature Delta_T_wo "Temperature difference between wall and fluid outlet temperature";
  SI.Temperature Delta_T_mean;

  SI.Temperature Delta_T_U;
  SI.Temperature Delta_T_L;
  //constant Real eps=1e-4;
  //SI.Temperature T_mean;

  ClaRa.Basics.Interfaces.HeatPort_a heat annotation (Placement(transformation(extent={{90,-10},
            {110,10}}),          iconTransformation(extent={{90,-10},{110,10}})));

equation
  Delta_T_wi = heat.T-iCom.T_in;
  Delta_T_wo = heat.T-iCom.T_out;
  Delta_T_U=  max(Delta_T_wi,Delta_T_wo);
  Delta_T_L= min(Delta_T_wi,Delta_T_wo);

//    Delta_T_mean= noEvent(if floor(abs(Delta_T_wo)*1/eps)<=1 or floor(abs(Delta_T_wi)*1/eps)<=1 then 0
//     elseif
//           (Delta_T_wo<-eps and Delta_T_wi>eps) or (Delta_T_wo>eps and Delta_T_wi<-eps) then 0 elseif  floor(abs(Delta_T_wo-Delta_T_wi)*1/eps)<1 then Delta_T_wi
//                          else (Delta_T_U-Delta_T_L)/log(Delta_T_U/Delta_T_L));
//   Delta_T_mean= (if abs(Delta_T_wo)<=1e-6 or abs(Delta_T_wi)<=1e-6 then 0
//    elseif
//          (heat.T<iCom.T_out and heat.T>iCom.T_in) or (heat.T>iCom.T_out and heat.T<iCom.T_in) then 0 elseif  abs(Delta_T_wo-Delta_T_wi)<1e-6 then Delta_T_wi
//                         else (Delta_T_U-Delta_T_L)/log(Delta_T_U/Delta_T_L));
//

//    T_mean= if useHomotopy then homotopy(((max(iCom.T_out,iCom.T_in)+2*1e-3)-(min(iCom.T_out,iCom.T_in)))/noEvent(log((max(iCom.T_out,iCom.T_in)+2*1e-3)/(min(iCom.T_out,iCom.T_in)+2*1e-3))), iCom.T)
//                           else          ((max(iCom.T_out,iCom.T_in)+2*1e-3)-(min(iCom.T_out,iCom.T_in)))/noEvent(log((max(iCom.T_out,iCom.T_in)+2*1e-3)/(min(iCom.T_out,iCom.T_in)+2*1e-3)));

 if temperatureDifference=="Logarithmic mean" then
   Delta_T_mean = noEvent(if floor(abs(Delta_T_wo)*1/eps)<=1 or floor(abs(Delta_T_wi)*1/eps)<=1 then 0
                     elseif (heat.T<iCom.T_out and heat.T>iCom.T_in) or (heat.T>iCom.T_out and heat.T<iCom.T_in) then 0
                     elseif  floor(abs(Delta_T_wo-Delta_T_wi)*1/eps)<1 then Delta_T_wi
                     else (Delta_T_U-Delta_T_L)/log(Delta_T_U/Delta_T_L));
 elseif temperatureDifference=="Arithmetic mean" then
     Delta_T_mean = heat.T - (iCom.T_in + iCom.T_out)/2;
 elseif temperatureDifference=="Inlet" then
     Delta_T_mean = heat.T - iCom.T_in;
 else
     Delta_T_mean = heat.T - iCom.T_out;
 end if;

end HeatTransfer_L2;
