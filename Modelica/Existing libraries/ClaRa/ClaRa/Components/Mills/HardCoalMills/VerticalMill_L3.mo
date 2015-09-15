within ClaRa.Components.Mills.HardCoalMills;
model VerticalMill_L3 "Vertical roller mill such as ball-and-race mill and roller-bowl mills"
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

  extends ClaRa.Basics.Icons.RollerBowlMill;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");
  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut=0,
    powerAux=P_mills) if                                                                                                 contributeToCycleSummary;

  import SI = ClaRa.Basics.Units;

  constant Basics.Units.EnthalpyMassSpecific
                                   Delta_h_evap=2500e3 "Heat of vaporization";
  constant Basics.Units.HeatCapacityMassSpecific
                                       cp_w= 4190 "Specific heat capacity of liquid water in the raw coal";

  parameter ClaRa.Basics.Media.Fuel.PartialFuel coal=simCenter.fuelModel1 "Medium to be used"
                        annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter TILMedia.GasTypes.BaseGas                  gas= simCenter.flueGasModel "Medium to be used in tubes"
                                 annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Components.Mills.HardCoalMills.Fundamentals.RollerBowlMillDefinition
                                                          millKoeff=
      ClaRa.Components.Mills.HardCoalMills.Fundamentals.STV1() "Coefficients of the mill"
                               annotation(choicesAllMatching, Dialog(group="Mill Definition"));
  parameter Integer N_mills= 1 "Number of equal mills in parallel" annotation(Dialog(group="Mill Definition"));

  parameter Basics.Units.Temperature
                           T_0 = simCenter.T_amb "Initial temperature in mill"
                                   annotation(Dialog(group="Initialisation"));
  parameter Basics.Units.Mass
                    M_c_0= 1000 "Initial Mass of raw coal on the table" annotation(Dialog(group="Initialisation"));
  parameter Basics.Units.Mass
                    M_pf_0= 100 "Initial Mass of pulverized coal on the table" annotation(Dialog(group="Initialisation"));
  parameter Basics.Units.Mass
                    M_cair_0= 100 "Initial Mass of pulverized coal in the air" annotation(Dialog(group="Initialisation"));

  parameter ClaRa.Basics.Choices.Init initChoice=ClaRa.Basics.Choices.Init.noInit "Initialisation option"
                            annotation(Dialog(group="Initialisation"));
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation" annotation(Dialog(tab="Summary and Visualisation"));

  parameter Boolean applyGrindingDelay=false "|Expert Settings||True if grinding process introducec a dead time";
  parameter SI.Time Tau_grind= 120 "Grinding dead time" annotation(Dialog(enable=applyGrindingDelay, tab="Expert Settings"));
  Basics.Units.Mass
          M_c(start=M_c_0) "Mass of ungrinded coal on the table";
  Basics.Units.Mass
          M_pf(start=M_pf_0) "Mass of pulverized coal on the table";
  Basics.Units.Mass
          M_cair(start=M_cair_0) "Mass of pulverized coal carried by primary air";

protected
  Basics.Units.MassFlowRate
                  m_flow_coal_in "Mass flow rate of raw coal to the mill";
  Basics.Units.MassFlowRate
                  m_flow_coal_pf "Mass flow rate of pulverized coal";
  Basics.Units.MassFlowRate
                  W_c_ "Mass flow of raw coal entering the grinding zone";
  Basics.Units.MassFlowRate
                  m_flow_coal_out "Mass flow rate of pulverized coal out of the mill";
  Basics.Units.MassFlowRate
                  m_flow_coal_ret "Mass flow rate of coal returnig to the table";
  Basics.Units.MassFlowRate
                  m_flow_air "Primary air mass flow rate";
  Real xi_coal_in[coal.nc-1] "Mositure content of incoming raw coal";
  Real xi_air_in[gas.nc-1] "Mositure content of incoming raw coal";
  Basics.Units.Pressure
              Delta_p_pa(displayUnit="Pa") "Primary air difference pressure";

  ClaRa.Basics.Functions.ClaRaDelay.ExternalTable pointer_W_c= ClaRa.Basics.Functions.ClaRaDelay.ExternalTable();
public
  Basics.Units.Temperature
                 T_out(start=T_0) "Classifier Temperature (outlet temperature)";
  Basics.Units.Temperature
                 T_coal_in "Coal inlet temperature";
  Basics.Units.Temperature
                 T_air_in "Primary air inlet temperature";

  Real P_grind "Power consumed for grinding in p.u.";
  Basics.Units.Frequency
               rpm=classifierSpeed;

  outer ClaRa.SimCenter simCenter;

  Modelica.Blocks.Interfaces.RealOutput Delta_p_mill(unit="Pa") "Pressure Difference between inlet and outlet connector"
                                                    annotation(Placement(transformation(extent={{100,50},
            {140,90}})));
  Modelica.Blocks.Interfaces.RealInput classifierSpeed "Speed of classifier"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,108})));
  TILMedia.Gas_pT     gasIn(
    p=inlet.flueGas.p,
    T=inStream(inlet.flueGas.T_outflow),
    xi=inStream(inlet.flueGas.xi_outflow),
    gasType=gas)
    annotation (Placement(transformation(extent={{-88,-70},{-68,-50}})));

  ClaRa.Components.Mills.HardCoalMills.Fundamentals.SummaryMill summary(
    T_coal_in=T_coal_in,
    T_air_in=T_air_in,
    rpm_classifier=classifierSpeed*60,
    P_grind=P_grind,
    m_flow_air_out=-outlet.flueGas.m_flow,
    mass_coal=N_mills*(M_cair + M_pf + M_c),
    m_flow_coal_in=inlet.coal.m_flow,
    m_flow_air_in=inlet.flueGas.m_flow,
    m_flow_tot_in=inlet.coal.m_flow + inlet.flueGas.m_flow,
    m_flow_coal_out=-outlet.coal.m_flow,
    m_flow_tot_out=-outlet.coal.m_flow - outlet.flueGas.m_flow,
    T_out=T_out) annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Basics.Interfaces.CoalDust_inlet      inlet(                                               flueGas(
        Medium=gas), coalType=coal) "Combined gas-and-coal(raw, wet) inlet"
    annotation (Placement(transformation(extent={{-110,-8},{-90,12}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Basics.Interfaces.CoalDust_outlet      outlet(                                               flueGas(
        Medium=gas), coalType=coal) "Combined gas-and-coal(pulverised, dry) outlet"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  TILMedia.Gas_pT     gasOut(
    p=outlet.flueGas.p,
    T=T_out,
    gasType=gas,
    xi=inStream(outlet.flueGas.xi_outflow))
    annotation (Placement(transformation(extent={{70,-68},{90,-48}})));
  Modelica.Blocks.Interfaces.RealOutput P_mills(unit="W") "Mill power of all parallel mills"
                                                    annotation(Placement(transformation(extent={{100,22},
            {140,62}})));
equation
//____________________________________________
//__________Boundaries:_______________________
  T_air_in = inStream(inlet.flueGas.T_outflow);
  m_flow_air = inlet.flueGas.m_flow/N_mills;
  xi_air_in = inStream(inlet.flueGas.xi_outflow);
  T_coal_in = inStream(inlet.coal.T_outflow);
  W_c_ = inlet.coal.m_flow/N_mills;
  xi_coal_in = inStream(inlet.coal.xi_outflow);

//_____________________________________________
  inlet.coal.p=inlet.flueGas.p;
  inlet.coal.T_outflow=T_out;
//  inlet.coal.Xi_outflow[1:coal.nc-1]= inStream(outlet.coal.Xi_outflow[1:coal.nc-1])/sum(inStream(outlet.coal.Xi_outflow[1:coal.nc-1]))  "ideal drying of the coal";
  inlet.coal.xi_outflow= inStream(outlet.coal.xi_outflow); //DUMMY value - backflow is not supported!

  inlet.flueGas.p=outlet.flueGas.p+Delta_p_pa;
  inlet.flueGas.T_outflow=T_out;
  inlet.flueGas.xi_outflow=inStream(outlet.flueGas.xi_outflow);//dummy

//____________________________________________
  outlet.coal.m_flow = -(m_flow_coal_out*(sum(xi_coal_in)))*N_mills;
  outlet.coal.T_outflow = T_out;
  outlet.coal.xi_outflow[1:coal.nc - 1] = inStream(inlet.coal.xi_outflow[1:coal.nc
     - 1])/sum(inStream(inlet.coal.xi_outflow[1:coal.nc - 1])) "ideal drying of the coal";

//  outlet.flueGas.p = p;
  outlet.flueGas.T_outflow = T_out;
  outlet.flueGas.m_flow = -(inlet.flueGas.m_flow + inlet.coal.m_flow*(1-sum(xi_coal_in))); //no air mass storage and instaneous, ideal drying

//  outlet.flueGas.Xi_outflow[1:end-1] = (inlet.flueGas.m_flow*xi_air_in[1:end-1])./(-outlet.flueGas.m_flow);
//  outlet.flueGas.Xi_outflow[end] = (inlet.flueGas.m_flow*xi_air_in[end] + inlet.coal.m_flow*(1-sum(xi_coal_in)))/(-outlet.flueGas.m_flow);
  outlet.flueGas.xi_outflow[1:7] = (inlet.flueGas.m_flow*xi_air_in[1:7]) ./ (-
    outlet.flueGas.m_flow);
  outlet.flueGas.xi_outflow[8] = (inlet.flueGas.m_flow*xi_air_in[8] + inlet.coal.m_flow
    *(1 - sum(xi_coal_in)))/(-outlet.flueGas.m_flow);
  outlet.flueGas.xi_outflow[9:end] = (inlet.flueGas.m_flow*xi_air_in[9:end]) ./ (
    -outlet.flueGas.m_flow);
//______________________________________________________________________________
// Calculation of the connecting mass flows between the mass storage
   Delta_p_mill= millKoeff.K_7 * Delta_p_pa + millKoeff.K_8*M_cair*100;
   m_flow_coal_pf=millKoeff.K_5*m_flow_air*M_pf;
   m_flow_coal_out=millKoeff.K_4*M_cair*(1-min(rpm,millKoeff.K_6)/millKoeff.K_6);
   m_flow_coal_ret=millKoeff.K_9*M_cair;
   P_grind=0.01*(millKoeff.K_2*M_pf+millKoeff.K_3*M_c)+millKoeff.E_e;
   Delta_p_pa=millKoeff.K_12*abs(m_flow_air)*m_flow_air/max(gasIn.d,0.0001); //From mill volume flow measurement using an orifice
   P_mills=millKoeff.P_nom*P_grind*N_mills;

  //this is beyond Nimcyks model: a dead time taking particle transport
  //  from the top of the raw coal pile on the grinding table to the grinding zone_______________
   if applyGrindingDelay then
     m_flow_coal_in = ClaRa.Basics.Functions.ClaRaDelay.getDelayValuesAtTime(
        pointer_W_c,
        time,
        W_c_,
        time-Tau_grind);
   else
     m_flow_coal_in=W_c_;
   end if;
  //__________________
//____________________________________________
//______Mass Balances_________________________
//Mass balances for the grinding table and the transport area:
  der(M_c)=m_flow_coal_in+m_flow_coal_ret-millKoeff.K_1*M_c;
  der(M_pf)=millKoeff.K_1*M_c-m_flow_coal_pf;
  der(M_cair)=m_flow_coal_pf-m_flow_coal_out-m_flow_coal_ret;

//____________________________________________
//_____Energy balance for the hole mill:______
// the energy balance as in equation (7) of [1] but with the derivative of the coal mass coming from the der(U) term
     der(T_out)=1/millKoeff.K_11*((gasIn.T-273.15)*gasIn.cp*m_flow_air
                                 + (1-sum(xi_coal_in)) * inlet.coal.m_flow/N_mills*cp_w*(inStream(inlet.coal.T_outflow)-273.15)
                                 + sum(xi_coal_in) * inlet.coal.m_flow/N_mills*coal.cp*(inStream(inlet.coal.T_outflow)-273.15)
                                 + outlet.flueGas.m_flow/N_mills* (gasOut.T-273.15)*gasOut.cp
                                 - (1-sum(xi_coal_in)) * inlet.coal.m_flow/N_mills * Delta_h_evap
                                 + sum(outlet.coal.xi_outflow) * outlet.coal.m_flow/N_mills * coal.cp * (T_out-273.15)
                                 + millKoeff.K_10*P_grind*100 - (der(M_c)+der(M_pf)+der(M_cair))*coal.cp*(T_out-273.15));

initial equation
  if initChoice == ClaRa.Basics.Choices.Init.noInit then
  //do nothing
  elseif initChoice == ClaRa.Basics.Choices.Init.steadyDensity then
    der(M_c)=0;
    der(M_cair)=0;
    der(M_pf)=0;
  elseif initChoice == ClaRa.Basics.Choices.Init.steadyTemperature then
    der(T_out)=0;
  elseif initChoice == ClaRa.Basics.Choices.Init.steadyState then
    der(M_c)=0;
    der(M_cair)=0;
    der(M_pf)=0;
    der(T_out)=0;
  else
    assert(false,"Unknown initialisation option");
  end if;

annotation (Diagram(graphics), Icon(graphics),
    Documentation(info="<html>
<h4>VerticalMill_3</h4>

<p>
A grey-box model for a hard coal mill compreding both, ball-and race and bowl mills<br>
The model is taken from Niemczyk [1] and the nomenclature is taken over to a certain extend to ensure a high transparancy of the model equations.<br>
</p>

<h5>General model approach:</h5>

<p>
The raw coal falls through a vertical funnel onto the grinding table. The coal is pulverized utilising rolling bowls or balls rolling over the grinding table. The pulverised coal is lifted by the primary air flow that transports the coal the the clasiifier section. Due to centrifugal forces that act on the coal particles only the smaller ones exit the mill, coarse particles fall back to the grinding table, see the figure below.<br>
<img src=\"../figures/HardCoalMill_SketchBowlMill.png\"/><br>
Most of the grinding mill models known from the literature distinct a number of control volumes thus allowing the consideration of mass and energy storage effects but avoiding a too high level of detail.<br>
</p>

<p>
The presented model takes the follong mass storages into account:<br>
<ul>
<li>Mass of raw coal on the table</li>
<li>Mass of pulverized coal on the table</li>
<li>Mass of pulverized coal carried by the primary air.</li>
</ul>
For these balance rooms a mass balance is derived:<br>
</p>

<p>
<img src=\"../figures/HardCoalMill_equation.png\" alt=\"\"><br>
</p>

<p>
The mass flow rates between the balance rooms have to  be calculated using simple algebraic equations without involving the physical effects:<br>
</p>

<p>
<img src=\"../figures/HardCoalMill_equation001.png\" alt=\"\"><br>
The given set of equations does not take different sizes of particles into account, i.e. the coal is either pulverized or not. Please note that there is no mass storage for air or water in the system which is fine as the water and air mass in the mill is usually considerably smaller than the coal mass.<br>
</p>

<p>
The tranport coefficients arising from this simple phenomenological approach have to be quantified by fitting the model results to measurement data. However, all of these coefficients have a meaningful physical background and some of them could be calculated from geometric parameters or even replaced when applying more physical model approaches. For the sake of simplicity of the model the latter mentioned options where not persuited.<br>
The following coefficients are involved so far:<br>
</p>

<p>
<img src=\"../figures/HardCoalMill_equation002.png\" alt=\"\"><br>
</p>

<p>
In order to define the outlet states of the coal and the primary air a global energy balance for the complete mill including the complete interior equipment as well as the stored coal is applied:<br>
</p>

<p>
<img src=\"../figures/HardCoalMill_equation003.png\" alt=\"\"><br>
This formula involves convective transport of enthalpy across the boundries and the energy input due to the grinding process. The corresponing equation (7) from [1] neglects the transport sensible heat of the evaporated moisture in the coal flow leaving the mill. Furthermore,  the derivaties <img src=\"../figures/HardCoalMill_equation004.png\" alt=\"\"> and <img src=\"../figures/HardCoalMill_equation005.png\" alt=\"\"> arising from the left-hand term of the upper equation is neglected due to minor importance. All of the neglected terms are added, the first menstioned one is of significant influence on the system temperature (and seems to be included in the used source code by Nimczyk - leaving this term leads to significant deviations from the provided measurement data!) while the time derivations of the mass M and the cpecific heat capacity of the system are added for the sake of completeness. In modification of the literature the coal dust leaving the mill through the corresponding connector is completely dried. The evaporated water is transported by the primary air, i.e. the coal dust duct is splitted into a part transporting the dry coal and a part transporting the moist primary air including the water content of the raw coal. Therefore, <strong>the connectors primaryAirOutlet and coalDust belong toghether and should alway be trated as one connector.</strong> To give a concrete example, the coal mill feeds the burners and so the connector primaryAirOutlet should be conected to the burner model as well as the coalDust connector.<br>
</p>

<p>
This leads to:<br>
<img src=\"../figures/HardCoalMill_equation006.png\" alt=\"\"><br>
The power applied for desintegration of the coal  in W/(p.u.load)is:<br>
</p>

<p>
<img src=\"../figures/HardCoalMill_equation012.png\" alt=\"\"><br>
Herein, two further coefficients are used:<br>
</p>

<p>
<img src=\"../figures/HardCoalMill_equation007.png\" alt=\"\"><br>
When comparing the simulation results with both, the simulation results of [1] and the measurement data provided in [1] it turns out that the given value for <img src=\"../figures/HardCoalMill_equation008.png\" alt=\"\"> is too small,  aproximately by factor 155 for mill STV1. This was corrected for each of the mills discussed  in [1]. However, a new optimisation concentrating on the coefficients <img src=\"../figures/HardCoalMill_equation009.png\" alt=\"\"> using the Nelder-Mead-algorithm leads to slightly different values, showing better agreement of the. The results of this optimisation can be found in the validation case <strong>ValidateRollerBowlMill_3.</strong><br>
</p>

<p>
In order to gain information of the mill's coal charge the pressure drop is of interest. This is a function of the coal mass in the transport area and a friction pressure drop due to the mass transport through the mill and a geostatic pressure difference depending on the coal particle mass in the transport area :<br>
</p>

<p>
<img src=\"../figures/HardCoalMill_equation010.png\" alt=\"\"><br>
This introduces to more  coefficients:<br>
</p>

<p>
<img src=\"../figures/HardCoalMill_equation011.png\" alt=\"\"><br>
</p>

<p>
The pressure drop due to friction was taken as an input by [1] but can be calculated using a equation of the form:<br>
</p>

<p>
<img src=\"../figures/HardCoalMill_equation013.png\" alt=\"\"> <br>
thus adding one more coefficient:<br>
</p>

<p>
<img src=\"../figures/HardCoalMill_equation014.png\" alt=\"\"><br>
</p>


<h5>References:</h5>
<p>
[1]    <strong>Piotr Niemczyk and Palle Andersen, Jan Dimon Bendtsen, Tom Søndergaard Pedersen Anders Peter Ravn:</strong> \"Derivation and validation of a coal mill model for control\", IFAC Symposium for Power Plant Simulation and Control, Tampera,Finland, 2009.<br>
</p>
</html>"));
end VerticalMill_L3;
