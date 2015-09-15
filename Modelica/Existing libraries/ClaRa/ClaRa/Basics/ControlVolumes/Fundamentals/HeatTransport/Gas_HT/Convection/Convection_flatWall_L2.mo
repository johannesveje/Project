within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection;
model Convection_flatWall_L2 "All Geo || L2 || Convection Flat Wall"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.HeatTransfer_L2;
  outer ClaRa.Basics.Records.IComGas_L2 iCom;

  //Equations according to VDI-Waermeatlas
  parameter Integer heatSurfaceAlloc=1 "To be considered heat transfer area"        annotation(dialog(enable=false,tab="Expert Setting"),choices(choice=1 "Lateral surface",
                          choice=2 "Inner heat transfer surface", choice=3 "Selection to be extended"));
  parameter String temperatureDifference= "Logarithmic mean" "Temperature Difference"
                                             annotation(Dialog(group="Heat Transfer"), choices(choice="Arithmetic mean", choice="Logarithmic mean", choice="Inlet",  choice="Outlet"));

//   final parameter ClaRa.Basics.Units.Area A_heat = if geo.flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical
//          then 2*(geo.width + geo.length)*geo.height else 2*(geo.width + geo.height)*geo.length;
  parameter Real CF_fouling=0.8 "Scaling factor accounting for the fouling of the wall";
  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha;
  ClaRa.Basics.Units.Velocity w;
  ClaRa.Basics.Units.Length length_char; //characteristic length

  Real Nu_llam;
  Real Nu_lturb;
  Real Nu_l0;
  Real Re;
  Real nu;

  Units.Temperature Delta_T_wi "Temperature difference between wall and fluid inlet temperature";
  Units.Temperature Delta_T_wo "Temperature difference between wall and fluid outlet temperature";
  Units.Temperature Delta_T_mean;
  Units.Temperature Delta_T_U;
  Units.Temperature Delta_T_L;

protected
  ClaRa.Basics.Units.Temperature T_prop_am;
  //arithmetic mean for calculation of substance properties
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubes
    geo;
  ClaRa.Basics.Units.MassFraction xi_mean[iCom.mediumModel.nc - 1];

  TILMedia.Gas_pT properties(
    p=(iCom.p_in + iCom.p_out)/2,
    T=T_prop_am,
    xi=xi_mean,
    gasType=iCom.mediumModel,
    computeTransportProperties=true)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  length_char = if geo.flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical
         then geo.height else geo.length;
  T_prop_am = (iCom.T_out + iCom.T_in)/2;
  // T_mean * Modelica.Math.log(abs((heat.T - iCom.T_in)/(heat.T - iCom.T_out))) = ((heat.T - iCom.T_in) - (heat.T - iCom.T_out));

  Delta_T_wi = heat.T-iCom.T_in;
  Delta_T_wo = heat.T-iCom.T_out;
  Delta_T_U=  max(Delta_T_wi,Delta_T_wo);
  Delta_T_L= min(Delta_T_wi,Delta_T_wo);

   if temperatureDifference=="Logarithmic mean" then
     Delta_T_mean = noEvent(if floor(abs(Delta_T_wo)*1/eps)<=1 or floor(abs(Delta_T_wi)*1/eps)<=1 then 0
            elseif (heat.T<iCom.T_out and heat.T>iCom.T_in) or (heat.T>iCom.T_out and heat.T<iCom.T_in) then 0 elseif  floor(abs(Delta_T_wo-Delta_T_wi)*1/eps)<1 then Delta_T_wi
            else (Delta_T_U-Delta_T_L)/log(Delta_T_U/Delta_T_L));
   elseif temperatureDifference=="Arithmetic mean" then
     Delta_T_mean = heat.T - (iCom.T_in + iCom.T_out)/2;
   elseif temperatureDifference=="Inlet" then
     Delta_T_mean = heat.T - iCom.T_in;
   else
     Delta_T_mean = heat.T - iCom.T_out;
   end if;

  zeros(iCom.mediumModel.nc-1) = - xi_mean * (iCom.m_flow_in - iCom.m_flow_out)
                        + (iCom.m_flow_in*iCom.xi_in - iCom.m_flow_out*iCom.xi_out);

  w = (iCom.V_flow_in - iCom.V_flow_out)/(2*(geo.A_cross + geo.A_front)/2);
  //mean velocity
  nu = properties.transp.eta/properties.d;
  //Re = w * geo.L/nu;
  Re = properties.d*w*length_char/(properties.transp.eta);

  Nu_llam = 0.664*sqrt(Re)*(properties.transp.Pr)^(1/3);
  Nu_lturb = (0.037*(Re)^(0.8)*properties.transp.Pr)/(1 + 2.443*(Re)^(-0.1)*(
    properties.transp.Pr^(2/3) - 1));
  Nu_l0 = sqrt(Nu_llam^2 + Nu_lturb^2);

  alpha = Nu_l0*properties.transp.lambda/length_char * CF_fouling;

  heat.Q_flow = geo.A_heat_CF[heatSurfaceAlloc]*alpha*Delta_T_mean;
  annotation (Documentation(info="<html>
<p><b>Model description: </b>A correlation for convective heat transfer at a flat surface</p>
<p><b>Contact:</b> Lasse Nielsen, TLK-Thermo GmbH</p>
<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Equations according to: VDI-W&auml;rmeatlas: 10.bearbeitete und erweiterte Auflage, 2006, chapter Gd1-5</li>
</ul></p>
</html>"));
end Convection_flatWall_L2;
