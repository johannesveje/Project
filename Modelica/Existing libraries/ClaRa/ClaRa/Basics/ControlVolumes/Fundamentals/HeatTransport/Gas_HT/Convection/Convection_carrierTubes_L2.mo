within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection;
model Convection_carrierTubes_L2 "Carrier Tube Geo || L2 || Convection Longitudinal Tubes"
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
  //Equations according to Handbuch fuer Heizung und Klimatechnik, Schramek

  parameter Integer heatSurfaceAlloc=3 "To be considered heat transfer area"        annotation(dialog(enable=false,tab="Expert Setting"),choices(choice=1 "Lateral surface",
                          choice=2 "Inner heat transfer surface", choice=3 "Selection to be extended"));
  parameter String temperatureDifference= "Logarithmic mean" "Temperature Difference"
                                             annotation(Dialog(group="Heat Transfer"), choices(choice="Arithmetic mean", choice="Logarithmic mean", choice="Inlet",  choice="Outlet"));
  parameter ClaRa.Basics.Units.Length d_ct=0.04 "Diameter of carrier tubes";
  parameter Real N_ct=16 "Number of carrier tubes";
  parameter Real CF_fouling=0.8 "Scaling factor accounting for the fouling of the wall";

  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha;
  ClaRa.Basics.Units.Velocity w;

  Units.Temperature Delta_T_wi "Temperature difference between wall and fluid inlet temperature";
  Units.Temperature Delta_T_wo "Temperature difference between wall and fluid outlet temperature";
  Units.Temperature Delta_T_mean;
  Units.Temperature Delta_T_U;
  Units.Temperature Delta_T_L;

protected
  Real Nu_dm;
  Real K;
  Real nu;
  ClaRa.Basics.Units.Temperature T_prop_am;
  //arithmetic mean for calculation of substance properties

  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes
    geo;
  ClaRa.Basics.Units.MassFraction xi_mean[iCom.mediumModel.nc - 1];

  TILMedia.Gas_pT properties(
    p=(iCom.p_in + iCom.p_out)/2,
    T=T_prop_am,
    xi=xi_mean,
    gasType=iCom.mediumModel,
    computeTransportProperties=true)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  TILMedia.Gas_pT properties_tw(
    p=(iCom.p_in+iCom.p_out)/2,
    T=heat.T,
    xi=xi_mean,
    gasType=iCom.mediumModel,
    computeTransportProperties=true)
    annotation (Placement(transformation(extent={{72,-12},{92,8}})));

equation
  T_prop_am = (iCom.T_out + iCom.T_in)/2;
  //T_mean * Modelica.Math.log(abs((heat.T - iCom.T_in)/(heat.T - iCom.T_out))) = ((heat.T - iCom.T_in) - (heat.T - iCom.T_out));

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

  w = (iCom.V_flow_in - iCom.V_flow_out)/(2*geo.A_cross);

  nu = properties.transp.eta/properties.d;
  K = nu*geo.height/(w*(d_ct/2)^2);
  //Nu_dm = 2* 0.55/(K^0.5)+ 10/9 * 0.95/(K^0.1);
  Nu_dm*(K^0.5)*(K^0.1) = 2*0.55*(K^0.1) + 10/9*(K^0.5)*0.95;

  alpha = Nu_dm*properties_tw.transp.lambda/geo.height * CF_fouling;

  heat.Q_flow = geo.A_heat_CF[heatSurfaceAlloc]*alpha*Delta_T_mean;

  annotation (Documentation(info="<html>
<p><b>Model description: </b>A correlation for convective heat transfer at a&nbsp;cylindric&nbsp;tube&nbsp;for&nbsp;longitudinal&nbsp;flow</p>
<p><b>Contact:</b> Lasse Nielsen, TLK-Thermo GmbH</p>
<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Needs geometry model for tube banks</li>
<li>Equations according to: VDI-W&auml;rmeatlas: 10.bearbeitete und erweiterte Auflage, 2006, chapter Ge 1-5</li>
</ul></p>
</html>"));
end Convection_carrierTubes_L2;
