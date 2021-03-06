within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection;
model Convection_finnedTubes_L2 "Tube Geo || L2 || Convection Finned Tube Bank"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.HeatTransfer_L2;
  outer ClaRa.Basics.Records.IComGas_L2 iCom;
  //Equations according to VDI-Waermeatlas/Effenberger Dampferzeugung
  parameter ClaRa.Basics.Units.Length h_f=0.04 "Fin heigth";
  parameter ClaRa.Basics.Units.Length s_f=0.002 "Fin thickness";
  parameter ClaRa.Basics.Units.Length t_f=0.01 "Fin spacing";
  parameter String finGeometryType="Circular fins" "Fin geometry" annotation (
      Dialog(group="Fin geometry"), choices(choice="Circular fins" "Circular fin geometry",
                                 choice="Quadratic fins" "Quadratic fin geometry"));

  parameter Real CF_fouling=0.8 "Scaling factor accounting for the fouling of the wall";
  parameter String temperatureDifference= "Logarithmic mean" "Temperature Difference"
                                             annotation(Dialog(group="Heat Transfer"), choices(choice="Arithmetic mean", choice="Logarithmic mean", choice="Inlet",  choice="Outlet"));
  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area"        annotation(dialog(enable=false,tab="Expert Setting"),choices(choice=1 "Lateral surface",
                       choice=2 "Inner heat transfer surface", choice=3 "Selection to be extended"));
public
  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha;
  ClaRa.Basics.Units.Velocity w_0;
  //velocity at narrowed cross section
  ClaRa.Basics.Units.Velocity w;
  //velocity at free cross section
  ClaRa.Basics.Units.Temperature T_f;
  //fin temperature
  Real N_f;
  //Number of fins
  Real N_tubes_p;
  //number of parallel tubes
  Real Nu;
  Real Re;
  ClaRa.Basics.Units.Length length_tube;
  //tube length
  Units.Temperature Delta_T_wi "Temperature difference between wall and fluid inlet temperature";
  Units.Temperature Delta_T_wo "Temperature difference between wall and fluid outlet temperature";
  Units.Temperature Delta_T_mean;
  Units.Temperature Delta_T_U;
  Units.Temperature Delta_T_L;

protected
  ClaRa.Basics.Units.Area A_f;
  //surface of one fin
  ClaRa.Basics.Units.Area A_ts;
  //tube segment surface between fins
  ClaRa.Basics.Units.Area A_finned;
  //finned surface (overall)
  ClaRa.Basics.Units.Area A_tubes;
  //tube surface (overall, as it were without fins)
  ClaRa.Basics.Units.Area A_narrowed;
  //Narrowed cross section for velocity calculation
  Real eff_fins;
  //fin efficiency
  Real X;
  Real phi;
  Real phi_st;
  Real nu;
  Real f_al;
  //factor for aligned tubes
  Real f_st;
  //factor for staggered tubes

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

  TILMedia.Gas_pT properties_tw(
    p=(iCom.p_in+iCom.p_out)/2,
    T=heat.T,
    xi=xi_mean,
    gasType=iCom.mediumModel,
    computeTransportProperties=true)
    annotation (Placement(transformation(extent={{72,-12},{92,8}})));

  TILMedia.Solid solid_f(T=T_f, redeclare model SolidType =
        TILMedia.SolidTypes.TILMedia_Steel) annotation (Placement(
        transformation(extent={{-10,20},{10,40}}, rotation=0)));

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

  length_tube = if geo.flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.horizontal
         then if geo.parallelTubes then geo.length else geo.height else if
        geo.parallelTubes then geo.height else geo.length;

  N_f = geo.N_tubes*geo.N_passes*length_tube/t_f;
  //amount of fins

  A_f =(2*Modelica.Constants.pi/4*((geo.diameter_t + 2*h_f)^2 - (geo.diameter_t)
    ^2) + Modelica.Constants.pi*(geo.diameter_t + 2*h_f)*s_f);
  A_ts =Modelica.Constants.pi*geo.diameter_t*t_f;

  A_finned = A_f*N_f + A_ts*(N_f + 1);
  //overall surface (including fins) of the tubes
  A_tubes =Modelica.Constants.pi*geo.diameter_t*length_tube*geo.N_tubes*geo.N_passes;
  //tube surface (like without fins)

  N_tubes_p = geo.N_tubes*geo.N_passes/(geo.N_rows);
  A_narrowed =(geo.A_front) - N_tubes_p*(length_tube*geo.diameter_t + h_f*s_f*N_f/(
    geo.N_tubes*geo.N_passes)*2);

  w_0 = ((iCom.V_flow_in - iCom.V_flow_out)/2)/(geo.A_front);
  w = w_0*geo.A_front/A_narrowed;

  nu = properties.transp.eta/properties.d;
  Re =properties.d*w*geo.diameter_t/properties.transp.eta;

  if geo.N_rows >= 4 then
    f_al = 1.0;
    f_st = 1.0;
  elseif geo.N_rows == 3 then
    f_al = 0.91;
    f_st = 0.95;
  elseif geo.N_rows == 2 then
    f_al = 0.91;
    f_st = 0.87;
  elseif geo.N_rows == 1 then
    f_al = 0.91;
    f_st = 0.87;
  else
    f_al = 0;
    f_st = 0;
  end if;

  if geo.staggeredAlignment == false then
    Nu = 0.22*Re^0.6*properties.transp.Pr^(1/3)*(A_finned/A_tubes)^(-0.15)*f_al;
  else
    Nu = 0.38*Re^0.6*properties.transp.Pr^(1/3)*(A_finned/A_tubes)^(-0.15)*f_st;
  end if;

  alpha =Nu*properties_tw.transp.lambda/geo.diameter_t*CF_fouling;

  if finGeometryType == "Circular fins" then
    phi =((geo.diameter_t + 2*h_f)/geo.diameter_t - 1)*(1 + 0.35*log(geo.diameter_t
       + 2*h_f));
    phi_st = 0.0;
  else
    phi_st =1.28*(geo.diameter_t + 2*h_f)/geo.diameter_t*sqrt(1 - 0.2);
    //sqrt(1-0.2): 1 for quadratic fins, rectangular fins not implemented!
    phi = (phi_st - 1)*(1 + 0.35*log(phi_st));
  end if;

  X =phi*geo.diameter_t/2*sqrt(2*alpha/(solid_f.lambda*s_f));
  eff_fins*X = tanh(X);
  T_f = eff_fins*(heat.T - (iCom.T_in + iCom.T_out)/2) + (iCom.T_in + iCom.T_out)/2;

  heat.Q_flow = alpha*(A_ts*(N_f + 1) + eff_fins*A_f*N_f)*Delta_T_mean;

  annotation (DymolaStoredErrors, Documentation(info="<html>
<p><b>Model description: </b>A correlation for convective heat transfer inside finned tube banks</p>
<p><b>Contact:</b> Lasse Nielsen, TLK-Thermo GmbH</p>
<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Aligned and staggered tubes supported</li>
<li>Supports circular or quadratic fins only</li>
<li>Needs geometry model for tube banks</li>
<li>Equations according to: VDI-W&auml;rmeatlas: 10.bearbeitete und erweiterte Auflage, 2006, chapter Mb1-4 and H. Effenberger: Dampferzeugung, chapter 9.3.5</li>
</ul></p>
</html>"));
end Convection_finnedTubes_L2;
