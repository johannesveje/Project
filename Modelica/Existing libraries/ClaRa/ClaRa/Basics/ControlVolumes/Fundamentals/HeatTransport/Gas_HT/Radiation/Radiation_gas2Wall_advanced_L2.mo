within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation;
model Radiation_gas2Wall_advanced_L2 "All Geo || L2 || Radiation Between Gas And Wall (Advanced)"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.HeatTransfer_L2;
  outer ClaRa.Basics.Records.IComGas_L2 iCom;
  extends ClaRa.Basics.Icons.Epsilon;

  parameter Real CF_fouling=0.8 "Scaling factor accounting for the fouling of the wall";
  parameter Real emissivity_wall=0.8 "Emissivity of the wall";

  parameter String suspension_calculationType="Fixed" "Calculation type"
    annotation (Dialog(group=
          "Emissivity and absorbance factor calculation of the suspension volume"),
      choices(choice="Fixed" "Use fixed value for gas emissivity", choice=
          "Calculated" "Calculate suspension emissivity according to VDI Waermeatlas", choice=
          "Gas calculated, particles fixed" "Gas emissivity calculated, particle emissivity fixed"));
  parameter Integer heatSurfaceAlloc=1 "To be considered heat transfer area"        annotation(dialog(enable=false,tab="Expert Setting"),choices(choice=1 "Lateral surface",
                          choice=2 "Inner heat transfer surface", choice=3 "Selection to be extended"));

  parameter Real emissivity_suspension_fixed=0.9 "Fixed value for gas emissivity"
    annotation (Dialog(enable=(suspension_calculationType == "Fixed"),
        group="Emissivity and absorbance factor calculation of the suspension volume"));

//   parameter String absorbance_suspension_calculationType="Fixed"
//     "Calculation type"
//     annotation (Dialog(group=
//           "Emissivity and absorbance factor calculation of the gas volume"),
//       choices(choice="Fixed" "Use fixed value for gas absorbance", choice=
//           "Calculated" "Calculate gas absorbance according to VDI Waermeatlas"));

  parameter Real absorbance_suspension_fixed=0.9 "Fixed value for gas absorbance"
    annotation (Dialog(enable=(suspension_calculationType == "Fixed"),
        group="Emissivity and absorbance factor calculation of the suspension volume"));

  parameter Real emissivity_particle=0.2 "Value considering dust particles if emissivity and absorbance are calculated"
    annotation (Dialog(enable=(suspension_calculationType == "Gas calculated, particles fixed"),group=
          "Emissivity and absorbance factor calculation of the suspension volume"));

  parameter ClaRa.Basics.Units.DensityMassSpecific soot_load_n = 163.5e-6 "Amount of soot inside the products at standard temperature and pressure"
    annotation (Dialog(enable=(suspension_calculationType == "Calculated"),
        group="Soot particle properties"));

  parameter ClaRa.Basics.Units.MassFraction x_coke = 0.1 "Coke fraction of used coal"
    annotation (Dialog(enable=(suspension_calculationType == "Calculated"),
        group="Coal particle properties"));

  parameter ClaRa.Basics.Units.DensityMassSpecific d_coke = 850 "Coke density"
    annotation (Dialog(enable=(suspension_calculationType == "Calculated"),
        group="Coal particle properties"));

  parameter ClaRa.Basics.Units.Length diameter_mean_coke = 65e-6 "Mean weighted diameter of coke particles (Rosin-Rammler-Distribution)"
    annotation (Dialog(enable=(suspension_calculationType == "Calculated"),
        group="Coal particle properties"));

  parameter Real n_var_coke = 1.5 "Variance parameter of coke particle distribution (Rosin-Rammler-Distribution)"
    annotation (Dialog(enable=(suspension_calculationType == "Calculated"),
        group="Coal particle properties"));

  parameter Real Q_mean_abs_coke = 0.85 "Mean relative cross section for absorption of coke particles"
    annotation (Dialog(enable=(suspension_calculationType == "Calculated"),
        group="Coal particle properties"));

  parameter ClaRa.Basics.Units.DensityMassSpecific d_ash = 2200 "Ash density"
    annotation (Dialog(enable=(suspension_calculationType == "Calculated"),
        group="Ash particle properties"));

  parameter ClaRa.Basics.Units.Length diameter_mean_ash = 16.8e-6 "Mean weighted diameter of ash particles (Rosin-Rammler-Distribution)"
    annotation (Dialog(enable=(suspension_calculationType == "Calculated"),
        group="Ash particle properties"));

  parameter Real n_var_ash = 1.5 "Variance parameter of ash particle distribution (Rosin-Rammler-Distribution)"
    annotation (Dialog(enable=(suspension_calculationType == "Calculated"),
        group="Ash particle properties"));

  parameter Real Q_mean_abs_ash = 0.2 "Mean relative cross section for absorption of ash particles"
    annotation (Dialog(enable=(suspension_calculationType == "Calculated"),
        group="Ash particle properties"));

//   parameter String HT_equationType="VDIWA-Kc-(18)"
//     "Heat transfer correlation according to VDI Waermeatlas"
//     annotation (Dialog(group=
//           "Heat transfer equation"),
//       choices(choice="VDIWA-Kc-(18)" "Chapter Kc eq. 18", choice=
//           "VDIWA-Ke-(6a)"
//         "Chapter Ke eq. 6a (better approximation esp. for surfaces with high reflexion)"));

public
  Units.Temperature T_mean;
  Real emissivity_suspension;
  Real absorbance_suspension;
  Real emissivity_H2O_CO2;
  Real absorbance_H2O_CO2;
  Real view_factor_wall;
  Real s_gl; //equivalent thickness
protected
  Real x;
  Real y;
  Real a1_T_gas;
  Real a2_T_gas;
  Real a3_T_gas;
  Real a1_T_wall;
  Real a2_T_wall;
  Real a3_T_wall;
  Real emissivity_S_1;
  Real emissivity_S_2;
  Real emissivity_S_3;
//   Real k_soot_1;
//   Real k_soot_2;
//   Real k_soot_3;
  Real k_coke;
  Real k_ash;
  Real coke_load;
  Real ash_load;
  Real soot_load;
  Real heat_flux_density;

  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock geo;
  outer ClaRa.Basics.Units.MassFraction xi_coal;
  ClaRa.Basics.Units.MassFraction xi_mean[iCom.mediumModel.nc - 1];
  //Composition needed for heat transfer correlations

   TILMedia.Gas_pT properties(
     p=(iCom.p_in+iCom.p_out)/2,
     T=T_mean,
     xi=xi_mean,
     gasType=iCom.mediumModel)
     annotation (Placement(transformation(extent={{-10,-12},{10,8}})));

equation
  //T_mean = (iCom.T_out + iCom.T_in)/2;
  T_mean = iCom.T_out;
  //zeros(iCom.mediumModel.nc-1) = - xi_mean * (iCom.m_flow_in - iCom.m_flow_out)
  //                      + (iCom.m_flow_in*iCom.xi_in - iCom.m_flow_out*iCom.xi_out);
  xi_mean = iCom.xi_out;
  s_gl = 3.6*(geo.volume/(geo.width*geo.length*2 + geo.width*geo.height*2 + geo.length*
    geo.height*2));

  x = if geo.flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical
      then geo.width/geo.height else geo.width/geo.length;
  y = if geo.flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical
      then geo.length/geo.height else geo.height/geo.length;

    //________________________/ Calculation of the view factor of the wall surface \_____________________
  view_factor_wall = 1 - (2/(Modelica.Constants.pi*x*y)*(1/2*log((1 + x^2)*(1
     + y^2)/(1 + x^2 + y^2)) + x*sqrt(1 + y^2)*atan(x/sqrt(1 + y^2)) + y*sqrt(1
     + x^2)*atan(y/sqrt(1 + x^2)) - x*atan(x) - y*atan(y)));
  // Calculated with difference of view-factor-sum (=1) and the view factor for top surface!

  //A_eff = CF_fouling*geo.A_heat_CF[heatSurfaceAlloc]*view_factor_wall;

  //________________________/ Calculation of gas emissivity and absorbance \_____________________
  if suspension_calculationType == "Fixed" then
    emissivity_suspension = emissivity_suspension_fixed;
    emissivity_H2O_CO2 = 0.0;
    absorbance_suspension = absorbance_suspension_fixed;
    absorbance_H2O_CO2 = 0.0;
    emissivity_S_1 = 0;
    emissivity_S_2 = 0;
    emissivity_S_3 = 0;
    a1_T_gas = 0;
    a2_T_gas = 0;
    a3_T_gas = 0;
    a1_T_wall = 0;
    a2_T_wall = 0;
    a3_T_wall = 0;
    k_coke = 0;
    k_ash = 0;
    coke_load = 0;
    ash_load = 0;
    soot_load = 0;

    heat.Q_flow = CF_fouling * geo.A_heat_CF[heatSurfaceAlloc] * view_factor_wall * Modelica.Constants.sigma * emissivity_wall/(absorbance_suspension
                   + emissivity_wall - absorbance_suspension*emissivity_wall)*(absorbance_suspension*heat.T^4 - emissivity_suspension*T_mean^4);

  elseif suspension_calculationType == "Gas calculated, particles fixed" then

     k_coke = 0;
     k_ash = 0;
     coke_load = 0;
     ash_load = 0;
     soot_load = 0;

      a1_T_gas = 0.13 + 0.265*(T_mean/1000);
      a2_T_gas = 0.595 - 0.15*(T_mean/1000);
      a3_T_gas = 0.275 - 0.115*(T_mean/1000);

      a1_T_wall = 0.13 + 0.265*(heat.T/1000);
      a2_T_wall = 0.595 - 0.15*(heat.T/1000);
      a3_T_wall = 0.275 - 0.115*(heat.T/1000);

      emissivity_S_1 = (1 - exp(0*(properties.p_i[3] +
      properties.p_i[8])/1e5*s_gl));
      emissivity_S_2 = (1 - exp(-0.824*(properties.p_i[
      3] + properties.p_i[8])/1e5*s_gl));
      emissivity_S_3 = (1 - exp(-25.91*(
      properties.p_i[3] + properties.p_i[8])/1e5*s_gl));

      emissivity_H2O_CO2 = a1_T_gas*emissivity_S_1 + a2_T_gas*emissivity_S_2 + a3_T_gas*emissivity_S_3;

      emissivity_suspension = emissivity_H2O_CO2 + emissivity_particle -
      emissivity_H2O_CO2*emissivity_particle;

      absorbance_H2O_CO2 = a1_T_wall*(1 - exp(0*(properties.p_i[3] +
      properties.p_i[8])/1e5*s_gl)) + a2_T_wall*(1 - exp(-0.824*(properties.p_i[
      3] + properties.p_i[8])/1e5*s_gl)) + a3_T_wall*(1 - exp(-25.91*(
      properties.p_i[3] + properties.p_i[8])/1e5*s_gl));

      absorbance_suspension = absorbance_H2O_CO2 + emissivity_particle -
                              absorbance_H2O_CO2*emissivity_particle;

      heat.Q_flow = CF_fouling * geo.A_heat_CF[heatSurfaceAlloc] * view_factor_wall * Modelica.Constants.sigma * emissivity_wall/(absorbance_suspension
                   + emissivity_wall - absorbance_suspension*emissivity_wall)*(absorbance_suspension*heat.T^4 - emissivity_suspension*T_mean^4);

   elseif suspension_calculationType == "Calculated" then

      a1_T_gas = 0.13 + 0.265*(T_mean/1000);
      a2_T_gas = 0.595 - 0.15*(T_mean/1000);
      a3_T_gas = 0.275 - 0.115*(T_mean/1000);

      a1_T_wall = 0.13 + 0.265*(heat.T/1000);
      a2_T_wall = 0.595 - 0.15*(heat.T/1000);
      a3_T_wall = 0.275 - 0.115*(heat.T/1000);

      emissivity_H2O_CO2 = a1_T_gas*(1 - exp(0*(properties.p_i[3] +
      properties.p_i[8])/1e5*s_gl)) + a2_T_gas*(1 - exp(-0.824*(properties.p_i[
      3] + properties.p_i[8])/1e5*s_gl)) + a3_T_gas*(1 - exp(-25.91*(
      properties.p_i[3] + properties.p_i[8])/1e5*s_gl));

      absorbance_H2O_CO2 = a1_T_wall*(1 - exp(0*(properties.p_i[3] +
      properties.p_i[8])/1e5*s_gl)) + a2_T_wall*(1 - exp(-0.824*(properties.p_i[
      3] + properties.p_i[8])/1e5*s_gl)) + a3_T_wall*(1 - exp(-25.91*(
      properties.p_i[3] + properties.p_i[8])/1e5*s_gl));

      soot_load = soot_load_n * (273.15/T_mean);

      coke_load = x_coke * xi_coal * properties.d;
      k_coke = Q_mean_abs_coke * 3 * Modelica.Constants.pi / (2 * d_coke * diameter_mean_coke * n_var_coke * sin(Modelica.Constants.pi/n_var_coke));

      ash_load = properties.xi[1] * properties.d;
      k_ash = Q_mean_abs_ash * 3 * Modelica.Constants.pi / (2 * d_ash * diameter_mean_ash * n_var_ash * sin(Modelica.Constants.pi/n_var_ash));

      emissivity_S_1 = (1 - exp( -( 0*(properties.p_i[3] +
      properties.p_i[8])/1e5 + 3460*soot_load + k_coke*coke_load + k_ash*ash_load)*s_gl));
      emissivity_S_2 = (1 - exp( -( 0.824*(properties.p_i[3] +
      properties.p_i[8])/1e5 + 960*soot_load + k_coke*coke_load + k_ash*ash_load)*s_gl));
      emissivity_S_3 = (1 - exp( -( 25.91*(properties.p_i[3] +
      properties.p_i[8])/1e5 + 960*soot_load + k_coke*coke_load + k_ash*ash_load)*s_gl));

      emissivity_suspension = a1_T_gas*emissivity_S_1 + a2_T_gas*emissivity_S_2 + a3_T_gas*emissivity_S_3;
      absorbance_suspension = a1_T_wall*emissivity_S_1 + a2_T_wall*emissivity_S_2 + a3_T_wall*emissivity_S_3;

      heat.Q_flow = CF_fouling * geo.A_heat_CF[heatSurfaceAlloc] * view_factor_wall * Modelica.Constants.sigma *
                    ( emissivity_S_1 * emissivity_wall/ (1 - (1 - emissivity_wall)*(1 - emissivity_S_1)) * (a1_T_wall * heat.T^4 - a1_T_gas * T_mean^4)
                    + emissivity_S_2 * emissivity_wall/ (1 - (1 - emissivity_wall)*(1 - emissivity_S_2)) * (a2_T_wall * heat.T^4 - a2_T_gas * T_mean^4)
                    + emissivity_S_3 * emissivity_wall/ (1 - (1 - emissivity_wall)*(1 - emissivity_S_3)) * (a3_T_wall * heat.T^4 - a3_T_gas * T_mean^4));

  else
    emissivity_suspension = emissivity_suspension_fixed;
    emissivity_H2O_CO2 = 0.0;
    absorbance_suspension = absorbance_suspension_fixed;
    absorbance_H2O_CO2 = 0.0;
    emissivity_S_1 = 0;
    emissivity_S_2 = 0;
    emissivity_S_3 = 0;
    a1_T_gas = 0;
    a2_T_gas = 0;
    a3_T_gas = 0;
    a1_T_wall = 0;
    a2_T_wall = 0;
    a3_T_wall = 0;
    k_coke = 0;
    k_ash = 0;
    coke_load = 0;
    ash_load = 0;
    soot_load = 0;

    heat.Q_flow = CF_fouling * geo.A_heat_CF[heatSurfaceAlloc] * view_factor_wall *Modelica.Constants.sigma*emissivity_wall/(absorbance_suspension
                 + emissivity_wall - absorbance_suspension*emissivity_wall)*(absorbance_suspension*heat.T^4 - emissivity_suspension*T_mean^4);
  end if;

  heat_flux_density = -heat.Q_flow/(1000*geo.A_heat[heatSurfaceAlloc]);

  annotation (Documentation(info="<html>
<p><b>Model description: </b>A correlation for radiant heat transfer between gas and wall inside furnaces</p>
<p><b>Contact:</b> Lasse Nielsen, TLK-Thermo GmbH</p>
<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Emissivity and Absorbance of flue gas can be calculated</li>
<li>Emissivity of particles is regarded as constant value</li>
<li>Configuration factors are regarded (radiating gas volume is treated as radiating surface)</li>
<li>Equations according to: VDI-W&auml;rmeatlas: 10. bearbeitete und erweiterte Auflage, 2006, chapters Kb, Kc and Kd</li>
<li>Heat transfer equations are chosen as eq. (18) from chapter Kc if property calculations are not considered or eq. (6a) from chapter Ke (better approximation especially for surfaces with higher reflexion) if emissivities and absorbances are calculated</li>
<li>Particle parameters are to be set according to the Rosin-Rammler-Distribution</li>
</ul></p>
</html>"));
end Radiation_gas2Wall_advanced_L2;
