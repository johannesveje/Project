within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection;
model ConvectionAndRadiation_tubeBank_L2 "Tube Geo || L2 || Convection And Radiation Inside Tube Banks"
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
  extends ClaRa.Basics.Icons.AlphaEpsilon;

  //Equations according to Effenberger/VDI-Waermeatlas

  parameter Real CF_fouling=0.8 "Scaling factor accounting for the fouling of the wall";

  parameter String epsilon_gas_calculationType="Fixed" "Calculation type"
    annotation (Dialog(group=
          "Emissivity and absorbance factor calculation of the gas volume"),
      choices(choice="Fixed" "Use fixed value for gas emissivity", choice=
          "Calculated" "Calculate gas emissivity according to VDI Waermeatlas"));

  parameter Real epsilon_gas_fixed=0.9 "Fixed value for gas emissivity"
    annotation (Dialog(enable=(epsilon_gas_calculationType == "Fixed"), group=
          "Emissivity and absorbance factor calculation of the gas volume"));

  parameter String alpha_gas_calculationType="Fixed" "Calculation type"
    annotation (Dialog(group=
          "Emissivity and absorbance factor calculation of the gas volume"),
      choices(choice="Fixed" "Use fixed value for gas absorbance", choice=
          "Calculated" "Calculate gas absorbance according to VDI Waermeatlas"));

  parameter Real alpha_gas_fixed=0.9 "Fixed value for gas absorbance"
    annotation (Dialog(enable=(alpha_gas_calculationType == "Fixed"), group=
          "Emissivity and absorbance factor calculation of the gas volume"));

  parameter Real epsilon_tubes=0.8 "Emissivity of the tubes" annotation (Dialog(
        group="Emissivity and absorbance factor calculation of the gas volume"));
  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area"        annotation(dialog(enable=false,tab="Expert Setting"),choices(choice=1 "Lateral surface",
                          choice=2 "Inner heat transfer surface", choice=3 "Selection to be extended"));
  parameter String temperatureDifference= "Logarithmic mean" "Temperature Difference"
         annotation(Dialog(group="Heat Transfer"), choices(choice="Arithmetic mean", choice="Logarithmic mean", choice="Inlet",  choice="Outlet"));

public
  ClaRa.Basics.Units.Velocity w;
  ClaRa.Basics.Units.HeatFlowRate Q_flow_rad;
  ClaRa.Basics.Units.HeatFlowRate Q_flow_conv;
  Real epsilon_gas;
  Real alpha_gas;
  //absorbance
  Real alpha;
  //convective heat transfer coefficient
  Real s_gl; //equivalent thickness
  Real Nu_llam;
  Real Nu_lturb;
  Real Nu_l0;
  Real Nu_tubeBank;
  Units.Temperature Delta_T_wi "Temperature difference between wall and fluid inlet temperature";
  Units.Temperature Delta_T_wo "Temperature difference between wall and fluid outlet temperature";
  Units.Temperature Delta_T_mean_conv;
  Units.Temperature Delta_T_U;
  Units.Temperature Delta_T_L;
  Units.Temperature T_mean_rad;

protected
  Real Re_psi1;
  Real nu;
  Real f_a;
  Real a1_epsilon;
  Real a2_epsilon;
  Real a3_epsilon;
  Real a1_alpha;
  Real a2_alpha;
  Real a3_alpha;
  ClaRa.Basics.Units.Length length_char;
  //flow legth
  ClaRa.Basics.Units.Temperature T_prop_am;
  //arithmetic mean for calculation of substance properties
  //ClaRa.Basics.Units.Temperature T_mean_conv;

  ClaRa.Basics.Units.MassFraction xi_mean[iCom.mediumModel.nc - 1];
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubes
    geo;

  TILMedia.Gas_pT properties(
    p=(iCom.p_in + iCom.p_out)/2,
    T=T_prop_am,
    xi=xi_mean,
    gasType=iCom.mediumModel,
    computeTransportProperties=true)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  //Radiative Heat Transfer
  T_prop_am = (iCom.T_out + iCom.T_in)/2;
  T_mean_rad = (iCom.T_out + iCom.T_in)/2;
  zeros(iCom.mediumModel.nc-1) = - xi_mean * (iCom.m_flow_in - iCom.m_flow_out)
                        + (iCom.m_flow_in*iCom.xi_in - iCom.m_flow_out*iCom.xi_out);
  //mean temperature for radiation

  s_gl = 3.6*geo.volume/geo.A_heat_CF[heatSurfaceAlloc];

  a1_epsilon = 0.13 + 0.265*(T_mean_rad/1000);
  a2_epsilon = 0.595 - 0.15*(T_mean_rad/1000);
  a3_epsilon = 0.275 - 0.115*(T_mean_rad/1000);

  a1_alpha = 0.13 + 0.265*(heat.T/1000);
  a2_alpha = 0.595 - 0.15*(heat.T/1000);
  a3_alpha = 0.275 - 0.115*(heat.T/1000);

  //________________________/ Calculation of gas emissivity and absorbance \_____________________
  if epsilon_gas_calculationType == "Fixed" then
    epsilon_gas = epsilon_gas_fixed;

  elseif epsilon_gas_calculationType == "Calculated" then

    epsilon_gas = a1_epsilon*(1 - exp(0*(properties.p_i[3] + properties.p_i[8])/1e5
      *s_gl)) + a2_epsilon*(1 - exp(-0.824*(properties.p_i[3] + properties.p_i[
      8])/1e5*s_gl)) + a3_epsilon*(1 - exp(-25.91*(properties.p_i[3] + properties.p_i[
      8])/1e5*s_gl));

  else
    epsilon_gas = epsilon_gas_fixed;
  end if;

  if alpha_gas_calculationType == "Fixed" then
    alpha_gas = alpha_gas_fixed;
  elseif alpha_gas_calculationType == "Calculated" then

    alpha_gas = a1_alpha*(1 - exp(0*(properties.p_i[3] + properties.p_i[8])/1e5*
      s_gl)) + a2_alpha*(1 - exp(-0.824*(properties.p_i[3] + properties.p_i[8])/1e5
      *s_gl)) + a3_alpha*(1 - exp(-25.91*(properties.p_i[3] + properties.p_i[8])/1e5
      *s_gl));

  else
    alpha_gas = alpha_gas_fixed;
  end if;

  Q_flow_rad = geo.A_heat_CF[heatSurfaceAlloc]*CF_fouling*Modelica.Constants.sigma*epsilon_tubes/(alpha_gas +
    epsilon_tubes - alpha_gas*epsilon_tubes)*(alpha_gas*heat.T^4 - epsilon_gas*
    T_mean_rad^4);

  //Convective Heat Transfer
  //T_mean_conv  * Modelica.Math.log(abs((heat.T - iCom.T_in)/(heat.T - iCom.T_out))) = ((heat.T - iCom.T_in) - (heat.T - iCom.T_out));
  Delta_T_wi = heat.T-iCom.T_in;
  Delta_T_wo = heat.T-iCom.T_out;
  Delta_T_U=  max(Delta_T_wi,Delta_T_wo);
  Delta_T_L= min(Delta_T_wi,Delta_T_wo);

   if temperatureDifference=="Logarithmic mean" then
     Delta_T_mean_conv = noEvent(if floor(abs(Delta_T_wo)*1/eps)<=1 or floor(abs(Delta_T_wi)*1/eps)<=1 then 0
            elseif (heat.T<iCom.T_out and heat.T>iCom.T_in) or (heat.T>iCom.T_out and heat.T<iCom.T_in) then 0 elseif  floor(abs(Delta_T_wo-Delta_T_wi)*1/eps)<1 then Delta_T_wi
            else (Delta_T_U-Delta_T_L)/log(Delta_T_U/Delta_T_L));
   elseif temperatureDifference=="Arithmetic mean" then
     Delta_T_mean_conv = heat.T - (iCom.T_in + iCom.T_out)/2;
   elseif temperatureDifference=="Inlet" then
     Delta_T_mean_conv = heat.T - iCom.T_in;
   else
     Delta_T_mean_conv = heat.T - iCom.T_out;
   end if;

  //logarithmic mean temperature between fluid inlet, outlet and tube wall

  //    a = s_1/d_tubes;
  //    b = s_2/d_tubes;
  //    c = s_3/d_tubes;
  //
  //    if b >= 1 then
  //      psi = 1-(Modelica.Constants.pi/(4*a));
  //    else
  //      psi = 1-(Modelica.Constants.pi/(4*a*b));
  //    end if;

  w = iCom.V_flow_in/(geo.A_front);
  //A_fr used because undisturbed velocity at inlet is needed
  length_char =Modelica.Constants.pi/2*geo.diameter_t;
  nu = properties.transp.eta/properties.d;
  //Re_psi1 = w * length_char/(psi*nu);
  Re_psi1 = properties.d*w*length_char/(geo.psi*properties.transp.eta);

  Nu_llam = 0.664*sqrt(Re_psi1)*(properties.transp.Pr)^(1/3);
  Nu_lturb = (0.037*(Re_psi1)^(0.8)*properties.transp.Pr)/(1 + 2.443*(Re_psi1)^
    (-0.1)*(properties.transp.Pr^(2/3) - 1));
  Nu_l0 = 0.3 + sqrt(Nu_llam^2 + Nu_lturb^2);

  if geo.staggeredAlignment == false then
    f_a = 1 + 0.7/(geo.psi)^(1.5)*(geo.b/geo.a - 0.3)/(geo.b/geo.a + 0.7)^2;
  else
    f_a = 1 + 2/(3*geo.b);
  end if;
  //  elseif tubeArrangementType == "Partly staggered" then
  //    if c < (a/4) then
  //      f_a = 1 + 0.7/(Re_psi1)^(1.5) * (b/a - 0.3)/(b/a + 0.7)^2;
  //    else
  //      f_a = 1 + 2/(3*b);
  //    end if;
  //  else
  //    f_a = 0;
  //  end if;

  if geo.N_rows < 10 then
    Nu_tubeBank = (1 + (geo.N_rows - 1)*f_a)/(geo.N_rows)*Nu_l0;
  else
    Nu_tubeBank = f_a*Nu_l0;
  end if;

  alpha = Nu_tubeBank*properties.transp.lambda/length_char * CF_fouling;

  Q_flow_conv = geo.A_heat_CF[heatSurfaceAlloc]*alpha*Delta_T_mean_conv;

  heat.Q_flow = Q_flow_rad + Q_flow_conv;

  annotation (Documentation(info="<html>
<p><b>Model description: </b>A correlation for radiant and convective heat transfer inside tube banks</p>
<p><b>Contact:</b> Lasse Nielsen, TLK-Thermo GmbH</p>
<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Aligned, staggered or partly staggered tubes supported</li>
<li>Emissivity and Absorbance of flue gas can be calculated</li>
<li>Emissivity of particles can is regarded as constant value</li>
<li>Needs geometry model for tube banks</li>
<li>Equations according to: VDI-W&auml;rmeatlas: 10.bearbeitete und erweiterte Auflage, 2006, chapter Kc and Gg</li>
</ul></p>
</html>"));
end ConvectionAndRadiation_tubeBank_L2;
