within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection;
model Convection_tubeBank_L2 "Tube Geo || L2 || Convection Tube Bank"
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
  parameter Real CF_fouling=0.8 "Scaling factor accounting for the fouling of the wall";
  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area"        annotation(dialog(enable=false,tab="Expert Setting"),choices(choice=1 "Lateral surface",
                          choice=2 "Inner heat transfer surface", choice=3 "Selection to be extended"));
  parameter String temperatureDifference= "Logarithmic mean" "Temperature Difference"
                                             annotation(Dialog(group="Heat Transfer"), choices(choice="Arithmetic mean", choice="Logarithmic mean", choice="Inlet",  choice="Outlet"));
public
  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha;
  ClaRa.Basics.Units.Length length_char;
  //flow length
  ClaRa.Basics.Units.Velocity w;
  Real Re_psi1;
  Real Nu_llam;
  Real Nu_lturb;
  Real Nu_l0;
  Real Nu_tubeBank;

  Units.Temperature Delta_T_wi "Temperature difference between wall and fluid inlet temperature";
  Units.Temperature Delta_T_wo "Temperature difference between wall and fluid outlet temperature";
  Units.Temperature Delta_T_mean;
  Units.Temperature Delta_T_U;
  Units.Temperature Delta_T_L;

protected
  Real nu;
  Real f_a;
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
  T_prop_am = (iCom.T_in + iCom.T_out)/2;
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
  //logarithmic mean temperature between fluid inlet, outlet and tube wall

  w = iCom.V_flow_in/geo.A_front;
  //undisturbed velocity at inlet is needed
  length_char =Modelica.Constants.pi/2*geo.diameter_t;
  nu = properties.transp.eta/properties.d;
  //Re_psi1 = w * length_char/(psi*nu);
  Re_psi1 = properties.d*w*length_char/(geo.psi*properties.transp.eta);

  Nu_llam = 0.664*sqrt(Re_psi1)*(properties.transp.Pr)^(1/3);
  Nu_lturb = (0.037*(Re_psi1)^(0.8)*properties.transp.Pr)/(1 + 2.443*(Re_psi1)^
    (-0.1)*(properties.transp.Pr^(2/3) - 1));
  Nu_l0 = 0.3 + sqrt(Nu_llam^2 + Nu_lturb^2);

  if geo.staggeredAlignment == false then
    f_a = 1 + 0.7/(Re_psi1)^(1.5)*(geo.b/geo.a - 0.3)/(geo.b/geo.a + 0.7)^2;
  else
    f_a = 1 + 2/(3*geo.b);
  end if;
  // "Partly staggered"
  //   if c < (a/4) then
  //     f_a = 1 + 0.7/(Re_psi1)^(1.5) * (b/a - 0.3)/(b/a + 0.7)^2;
  //   else
  //     f_a = 1 + 2/(3*b);
  //   end if;
  // else
  //   f_a = 0;
  // end if;

  if geo.N_rows < 10 then
    Nu_tubeBank = (1 + (geo.N_rows - 1)*f_a)/(geo.N_rows)*Nu_l0;
  else
    Nu_tubeBank = f_a*Nu_l0;
  end if;

  alpha = Nu_tubeBank*properties.transp.lambda/length_char * CF_fouling;

  //heat.Q_flow = A_eff * alpha*(heat.T - T_mean);
  heat.Q_flow = geo.A_heat_CF[heatSurfaceAlloc]*alpha*Delta_T_mean;
  annotation (Documentation(info="<html>
<p><b>Model description: </b>A correlation for convective heat transfer inside tube banks</p>
<p><b>Contact:</b> Lasse Nielsen, TLK-Thermo GmbH</p>
<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Aligned, staggered or partly staggered tubes supported</li>
<li>Needs geometry model for tube banks</li>
<li>Equations according to: VDI-W&auml;rmeatlas: 10.bearbeitete und erweiterte Auflage, 2006, chapter Gg1-4</li>
</ul></p>
</html>"));
end Convection_tubeBank_L2;
