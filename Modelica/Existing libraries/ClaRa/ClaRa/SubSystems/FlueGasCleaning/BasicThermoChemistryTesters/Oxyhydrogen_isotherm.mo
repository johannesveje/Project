within ClaRa.SubSystems.FlueGasCleaning.BasicThermoChemistryTesters;
model Oxyhydrogen_isotherm
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

  TILMedia.Gas_ph     educts(
    nc=3,
    gasType="TemoGas_Wasserstoff|TemoGas_Sauerstoff|TemoGas_Wasser",
                                                               T(start=300))
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  TILMedia.Gas_ph     products(
    nc=3,
    gasType="TemoGas_Wasserstoff|TemoGas_Sauerstoff|TemoGas_Wasser",
                                                               T(start=300))
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));

Modelica.SIunits.MassFlowRate gas_in;
 Modelica.SIunits.MassFlowRate gas_out;
Modelica.SIunits.HeatFlowRate Qdot;
final parameter Modelica.SIunits.MolarInternalEnergy delta_f_H_H2O = -241.826e3;// standard formation enthalpy (T = 298.15K /p = 1.0 bar)

equation
  gas_in = 1*educts.M_i[1]
                         +0.5
                            *educts.M_i[2];
  gas_out = (-1)*products.M_i[3];

  educts.T = 273.15 + 77+25;

  educts.p = 1.013e5;
  products.p =  1.013e5;

  educts.xi={2*educts.M_i[1]
                           /(2*educts.M_i[1]
                                           +educts.M_i[2]),educts.M_i[2]
                                                                      /(2*educts.M_i[
    1]                                                                                +educts.M_i[
    2])};
  products.xi={0.0,0.0};

// isotherm
  educts.T = products.T;

//Energy balance
  0 = gas_in*(educts.h) + gas_out*(products.h + products.hl[3]*(1-products.xi_gas[3])+delta_f_H_H2O/products.M_i[
    3])                                                                                                    +Qdot;

end Oxyhydrogen_isotherm;
