within FluidDissipation.PressureLoss.Bend;
function dp_edgedOverall_MFLOW
  "Pressure loss of edged bend | calculate mass flow rate | overall flow regime | surface roughness"
  extends Modelica.Icons.Function;
  //SOURCE_1: Idelchik, I.E.: HANDBOOK OF HYDRAULIC RESISTANCE, 3rd edition, 2006.
  //SOURCE_2: Miller, D.S.: INTERNAL FLOW SYSTEMS, 2nd edition, 1984.
  //SOURCE_3: VDI-Waermeatlas, 9th edition, Springer-Verlag, 2002, Section Lac 6 (Verification)
  //Notation of equations according to SOURCES

  import FD = FluidDissipation.PressureLoss.Bend;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //input records
  input FluidDissipation.PressureLoss.Bend.dp_edgedOverall_IN_con IN_con
    "Input record for function dp_edgedOverall_MFLOW"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.Bend.dp_edgedOverall_IN_var IN_var
    "Input record for function dp_edgedOverall_MFLOW"
    annotation (Dialog(group="Variable inputs"));
  input SI.Pressure dp "Pressure loss" annotation (Dialog(group="Input"));

  //output variables
  output SI.MassFlowRate M_FLOW "Output for function dp_edgedOverall_MFLOW";

protected
  Real MIN=Modelica.Constants.eps;

  SI.Diameter d_hyd=IN_con.d_hyd "Hydraulic diameter";
  SI.Area A_cross=PI*d_hyd^2/4 "Circular cross sectional area";
  Real k=max(MIN, abs(IN_con.K)/IN_con.d_hyd) "Relative roughness";
  Real delta=IN_con.delta*180/PI "Angle of turning";

  //definition of flow regime boundaries
  SI.ReynoldsNumber Re_min=1 "Minimum Reynolds number";
  SI.ReynoldsNumber Re_lam_min=500
    "Start of transition regime for roughness contribution";
  SI.ReynoldsNumber Re_lam_max=1e4
    "End of transition regime for roughness contribution";
  SI.ReynoldsNumber Re_turb_min=1e5
    "Minimum Reynolds number for Reynolds-dependent transition regime";
  SI.ReynoldsNumber Re_turb_max=2e5
    "Maximum Reynolds number for Reynolds-dependent transition regime (k_Re=1)";
  SI.ReynoldsNumber Re_turb_const=1e6
    "Reynolds number for independence on pressure loss coefficient (1e6)";

  //SOURCE_1: p. 81, sec. 2-2-21: end of transition regime
  SI.ReynoldsNumber Re_lam_leave=min(Re_lam_max, max(Re_lam_min, 754*
      Modelica.Math.exp(if k <= 0.007 then 0.0065/0.007 else 0.0065/k)))
    "End of transition regime for roughness contribution";

  //SOURCE_1: p.366, diag. 6-7
  Real A=0.95 + 33.5/max(MIN, delta)
    "Coefficient considering effect of angle of turning on zeta_LOC";
  Real C1=1
    "Considering relative elongation of cross sectional area on zeta_LOC (here: circular cross sectional area)";

  //SOURCE_1: p.366, diag. 6-7
  TYP.LocalResistanceCoefficient zeta_LOC=max(MIN, 0.95*sin(PI/180*delta/2)^2
       + 2.05*sin(PI/180*delta/2)^4) "Local resistance coefficient";

  //SOURCE_1: p.365: Correction w.r.t effect of Reynolds number
  Real B=24.8 "Coefficient considering effect of Reynolds number on zeta_TOT";
  Real exp=0.263 "Exponent for Reynolds number correction";
  Real pow=(2 - exp) "pressure loss = f(mass flow rate^pow)";
//   Real k_Re = B/(max(MIN, velocity)*IN_con.d_hyd*IN_var.rho)^exp*IN_var.eta^exp;

  SI.Velocity v_min = Re_min*IN_var.eta/(IN_var.rho*d_hyd)
    "Minimum mean velocity for regularization";

  SI.Pressure dp_min=A*C1*zeta_LOC*(B/2)*(d_hyd/IN_var.eta)^(-exp)*IN_var.rho^(1 - exp)
      *v_min^(pow)
    "Linear smoothing of mass flow rate for decreasing pressure loss";

  SI.Velocity v_lam_min = Re_lam_min*IN_var.eta/(IN_var.rho*d_hyd)
    "Mean velocity for starting of transition to roughness regime";
  SI.Velocity v_lam_leave = Re_lam_leave*IN_var.eta/(IN_var.rho*d_hyd)
    "Mean velocity for end of transition to roughness regime";

  SI.Pressure dp_lam_min=A*C1*zeta_LOC*(B/2)*(d_hyd/IN_var.eta)^(-exp)*IN_var.rho^(1 - exp)
      *v_lam_min^(pow)
    "Pressure loss for starting of transition to roughness regime";

  TYP.DarcyFrictionFactor lambda_lam_leave_rough=0.25/(Modelica.Math.log10(k/(3.7*
      IN_con.d_hyd) + 5.74/Re_lam_leave^0.9))^2
    "Darcy friction factor considering surface roughness at Re_lem_leave";
  TYP.DarcyFrictionFactor lambda_lam_leave_smooth=0.25/(Modelica.Math.log10(5.74/Re_lam_leave^0.9))^2
    "Darcy friction factor neglecting surface roughness at Re_lam_leave";

  SI.Pressure dp_lam_leave=A*C1*zeta_LOC*(B/2)*max(1, min(1.4, (lambda_lam_leave_rough/
      lambda_lam_leave_smooth)))*(d_hyd/IN_var.eta)^(-exp)*IN_var.rho^(1 - exp)
      *v_lam_leave^(pow)
    "Pressure loss at end of transition to surface roughness regime";

  TYP.DarcyFrictionFactor lambda_turb_min_rough=0.25/(Modelica.Math.log10(k/(3.7*
      IN_con.d_hyd) + 5.74/Re_turb_min^0.9))^2
    "Darcy friction factor considering surface roughness at starting transition to constant turbulent regime";
  TYP.DarcyFrictionFactor lambda_turb_min_smooth=0.25/(Modelica.Math.log10(5.74/Re_turb_min^0.9))^2
    "Darcy friction factor neglecting surface roughness at starting transition to constant turbulent regimee";

  TYP.DarcyFrictionFactor lambda_turb_max_rough=0.25/(Modelica.Math.log10(k/(3.7*
      IN_con.d_hyd) + 5.74/Re_turb_max^0.9))^2
    "Darcy friction factor considering surface roughness at starting transition to constant turbulent regime";
  TYP.DarcyFrictionFactor lambda_turb_max_smooth=0.25/(Modelica.Math.log10(5.74/Re_turb_max^0.9))^2
    "Darcy friction factor neglecting surface roughness at starting transition to constant turbulent regimee";

  SI.Velocity v_turb_min = Re_turb_min*IN_var.eta/(IN_var.rho*d_hyd)
    "Mean velocity for starting of transition to constant turbulent regime";

  SI.Velocity v_turb_max = Re_turb_max*IN_var.eta/(IN_var.rho*d_hyd)
    "Mean velocity for end of transition to constant turbulent regime";

  SI.Pressure dp_turb_min=A*C1*zeta_LOC*(B/2)*max(1, min(1.4, (lambda_turb_min_rough/
      lambda_turb_min_smooth)))*(d_hyd/IN_var.eta)^(-exp)*IN_var.rho^(1 - exp)
      *v_turb_min^(pow)
    "Pressure loss at starting of transition to constant turbulent regime";

  SI.Pressure dp_turb_max=A*C1*zeta_LOC*max(1, min(1.4, (lambda_turb_max_rough/
      lambda_turb_max_smooth)))*IN_var.rho/2*v_turb_max^2
    "Pressure loss at end of transition to constant turbulent regime";

  SI.Velocity v_turb=(A*C1*zeta_LOC*IN_var.rho/2)^(-0.5)*
      FluidDissipation.Utilities.Functions.General.SmoothPower(
      abs(dp),
      dp_min,
      0.5) "Mean velocity under turbulent conditions";

  SI.Velocity v_lam=(2*(d_hyd/IN_var.eta)^exp/(A*C1*zeta_LOC*B*(IN_var.rho)^(1 - exp)))^(1/pow)*
      FluidDissipation.Utilities.Functions.General.SmoothPower(
      abs(dp),
      dp_min,
      1/pow) "Mean velocity under laminar conditions";

  //mean velocity under smooth conditions w.r.t flow regime
  SI.Velocity v_smooth=if abs(dp) > dp_turb_max then v_turb
      else if abs(dp) < dp_turb_min then v_lam
      else SMOOTH(
      dp_turb_max,
      dp_turb_min,
      abs(dp))*v_turb + SMOOTH(
      dp_turb_min,
      dp_turb_max,
      abs(dp))*v_lam "Mean velocity under smooth conditions";

  SI.ReynoldsNumber Re_smooth=max(Re_min, IN_var.rho*v_smooth*d_hyd/IN_var.eta)
    "Reynolds number under smooth conditions";

  //SOURCE_2: p.191, eq. 8.4: considering surface roughness
  TYP.DarcyFrictionFactor lambda_FRI_rough=0.25/(Modelica.Math.log10(k/(3.7*
      IN_con.d_hyd) + 5.74/max(Re_lam_min, Re_smooth)^0.9))
      ^2 "Darcy friction factor considering surface roughness";
  TYP.DarcyFrictionFactor lambda_FRI_smooth=0.25/(Modelica.Math.log10(5.74/max(Re_lam_min, Re_smooth)^0.9))^2
    "Darcy friction factor neglecting surface roughness";

  //SOURCE_3: Lac 6, Figure 18
  Real CF_fri= SMOOTH(dp_lam_leave, dp_lam_min, abs(dp))*max(1, min(1.4, (lambda_FRI_rough/
      lambda_FRI_smooth))) + SMOOTH(dp_lam_min, dp_lam_leave, abs(dp))
    "Correction factor for surface roughness";

  SI.Velocity velocity=v_smooth/max(1, CF_fri)^(0.5)
    "Corrected velocity considering surface roughness";

algorithm
    M_FLOW := sign(dp)*IN_var.rho*A_cross*velocity;

  annotation (
    Inline = false,
    smoothOrder(normallyConstant=IN_con) = 2,
    inverse(dp=FluidDissipation.PressureLoss.Bend.dp_edgedOverall_DP(
          IN_con,
          IN_var,
          M_FLOW)),
    Documentation(info="<html>
<p>
Calculation of pressure loss in edged bends with sharp corners at overall flow regime for incompressible and single-phase fluid flow through circular cross sectional area considering surface roughness.
</p>
 
There are larger pressure losses in an edged bend compared to a curved bend under the same conditions. The effect of a sharp corner in an edged bend on the pressure loss is much larger than the influence of surface roughness.
 
<<p>
This function can be used to calculate both the pressure loss at known mass flow rate <b> or </b> mass flow rate at known pressure loss within one function in dependence of the known 
variable (dp or m_flow).
</p>
 
<p>
Generally this function is numerically best used for the <b> compressible case </b> if the pressure loss (dp) is known (out of pressures as state variable) and the mass flow rate (M_FLOW) has to be calculated. On the other hand the function <a href=\"Modelica://FluidDissipation.PressureLoss.Bend.dp_edgedOverall_DP\">dp_edgedOverall_DP</a> is numerically best used for the <b> incompressible case </b>, where the mass flow rate (m_flow) is known (as state variable) in the used model and the corresponding pressure loss (DP) has to be calculated. 
</p> 
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This function shall be used inside of the restricted limits according to the referenced literature.
<ul>
 <li>
      <b> circular cross sectional area </b> <i>[Idelchik 2006, p. 366, diag. 6-7] </i>
 </li>
 <li> 
      <b> edged bend with sharp corners at turning </b> <i>[Idelchik 2006, p. 366, diag. 6-7] </i>
 </li>
 <li> 
      <b> 0&deg; &le; angle of turning &le; 180&deg; </b> <i>[Idelchik 2006, p. 338, sec. 19] </i>
 </li> 
 <li> 
      <b> length of bend straight starting section / diameter &ge; 10 </b> <i>[Idelchik 2006, p. 366, diag. 6-7] </i>
 </li> 
</ul>
 
<h4><font color=\"#EF9B13\">Geometry</font></h4> 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/bend/pic_edgedBend.png\">
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The pressure loss <b> dp </b> for edged bends is determined by:
<p>
<pre>
    dp = zeta_TOT * (rho/2) * velocity^2 
</pre>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> rho            </b></td><td> as density of fluid [kg/m3],</td></tr>
<tr><td><b> velocity       </b></td><td> as mean velocity [m/s],</td></tr>
<tr><td><b> zeta_TOT       </b></td><td> as pressure loss coefficient [-].</td></tr>
</table>
</p>
 
The pressure loss coefficient <b> zeta_TOT </b> of an edged bend can be calculated for different angles of turning <b> delta </b> by:
<p>
<pre>
    zeta_TOT = A * C1 * zeta_LOC * CF_Fri* CF_Re <i>[Idelchik 2006, p. 366, diag. 6-7] </i> and <i>[Miller 1984, p. 149, sec. 9.4]</i>
</pre>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> A              </b></td><td> as coefficient considering effect for angle of turning [-],</td></tr>
<tr><td><b> C1             </b></td><td> as coefficient considering relative elongation of cross sectional area (here: circular cross sectional area) [-],</td></tr>
<tr><td><b> CF_Fri         </b></td><td> as correction factor considering surface roughness [-],</td></tr>
<tr><td><b> CF_Re          </b></td><td> as correction factor considering Reynolds number [-],</td></tr>
<tr><td><b> delta          </b></td><td> as angle of turning [deg].</td></tr>
</table>
</p>
 
The correction factor <b> CF_Fri </b> regarding the influence of surface roughness is determined as ratio of the Darcy friction factor for rough surfaces to smooth surfaces according to <i>[Miller, p. 207, eq. 9.3]:</i> 
</p>
<pre>
    CF_Fri = lambda_FRI_rough / lambda_FRI_smooth
</pre>
 
<p>
and the Darcy friction factors <b> lambda_FRI </b> are calculated with an approximated Colebrook-White law according to <i>[Miller, p. 191, eq. 8.4]:</i>  
</p>
<pre>
    lambda_FRI = 0.25*(lg(K/(3.7*d_hyd) + 5.74/Re^0.9))^-2
</pre>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> d_hyd              </b></td><td> as hydraulic diameter [m],</td></tr>
<tr><td><b> K                  </b></td><td> as absolute roughness (average height of surface asperities) [m],</td></tr>
<tr><td><b> lambda_FRI         </b></td><td> as Darcy friction factor[-],</td></tr>
<tr><td><b> Re                 </b></td><td> as Reynolds number [m],</td></tr>
<tr><td><b> zeta_TOT           </b></td><td> as pressure loss coefficient [-].</td></tr>
</table>
</p>
 
<p> 
Note that the Darcy friction factor for a smooth surface <b> lambda_FRI_smooth </b> is calculated with the previous equation and an absolute roughness of <b> K = 0 </b>. 
</p> 
 
<p> 
The correction for surface roughness through <b> CF_Fri </b> is used only in the turbulent regime, where the fluid flow is influenced by surface asperities not covered by a laminar boundary layer. Here the correction according to friction starts at <b> Re &ge; Re_lam_leave </b> according to <i>[Idelchik 2006, p. 336, sec. 15]</i>. Here the end of the laminar regime is restricted to a Reynolds number smaller than 2e3 w.r.t <i>[VDI, p. Lac 6, fig. 16]</i>. 
</p>
 
<p>
Nevertheless the transition point from the laminar to the transition regime is shifted to smaller Reynolds numbers for an increasing absolute roughness. This effect is considered according to <i>[Samoilenko in Idelchik 2006, p. 81, sec. 2-1-21]</i> as: 
<pre>
    Re_lam_leave = 754*exp(if k &le; 0.007 then 0.0065/0.007 else 0.0065/k)
</pre>
</p> 
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> k = K /d_hyd       </b></td><td> as relative roughness [-],</td></tr>
<tr><td><b> Re_lam_leave       </b></td><td> as Reynolds number for leaving laminar regime [-].</td></tr>
</table>
</p>
 
<p>
Note that the beginning of the laminar regime cannot be beneath <b> Re &le; 5e2 </b>.
</p> 
 
<p>
In addition the influence or decreasing Reynolds numbers <b> Re </b> on the pressure loss coefficient <b> zeta_TOT </b> in the laminar and turbulent regime is considered through a second correction factor <b> CF_Re </b> according to <i>[Miller 1984, p. 149, sec. 9.4]</i> by:
</p>
 
<pre>
CF_Re = B/Re^exp for Re &le; 2e5
</pre>

<p>
with
</p>
 
<p>
<table>
<tr><td><b> B                </b></td><td> as coefficient considering effect of Reynolds number in laminar regime [-],</td></tr>
<tr><td><b> exp              </b></td><td> as exponent for Reynolds number [-],</td></tr>
<tr><td><b> Re               </b></td><td> as Reynolds number [-], </td></tr>
</table>
</p>

<p>
Note that the coefficient <b> B </b> considers the influence of the angle of turning <b> delta </b> on the pressure loss coefficient <b> zeta_TOT </b> in the laminar regime according to <i>[Idelchik 2006, p. 340, sec. 28]</i>.
</p>

<p>
Note that the correction of the pressure loss coefficient <b> zeta_TOT </b> is influenced by the correction factor <b> CF_Re </b> only for decreasing Reynolds numbers <b> Re </b> out of the turbulent fluid flow regime at <b> Re &le; 2e5 </b> into transition and laminar fluid flow regime.
</p>

 
<h4><font color=\"#EF9B13\">Verification</font></h4>      
<p>
The pressure loss coefficient <b> zeta_TOT </b> of a edged bend in dependence of the Reynolds number <b> Re </b> for different angles of turning <b> delta </b> is shown in the figures below.
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/bend/fig_bend_dp_edgedOverall_ZETAvsRE.png\">
</p>
 
<p> 
Pressure loss calculation of edged bends is complex and there are large differences in literature data. Nevertheless these calculations cover the usual range of pressure loss coefficients for an edged bend. 
</p>
 
<p>
The validation of the pressure loss coefficient for an edged bends shows four possible flow regimes:
<ul>
 <li>
      <b> laminar regime </b> for Re &le; 5e2
 <li> 
      <b> transition regime </b> for 5e2 &le; Re &le; 1e3 ... 1e4
 <li> 
      <b> turbulent regime dependent on Reynolds number</b> for 2e3 ... 1e4 &le; Re &le; 1e5
 <li> 
      <b> turbulent regime independent on Reynolds number</b> for Re &ge; 2e5
</ul>
</p>
 
<p>
<b> Compressible case </b> [Mass flow rate = f(dp)]: 
</p>  
<p> 
The mass flow rate in dependence of the pressure loss of water is shown for different angles of turning:
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/bend/fig_bend_dp_edgedOverall_MFLOWvsDPwrtDelta.png\">
</p>
 
<h4><font color=\"#EF9B13\">References</font></h4> 
<dl>
<dt>Idelchik,I.E.:</dt>
    <dd><b>Handbook of hydraulic resistance</b>.
    Jaico Publishing House,Mumbai,3rd edition, 2006.</dd>
<dt>Miller,D.S.:</dt>
    <dd><b>Internal flow systems</b>.
    volume 5th of BHRA Fluid Engineering Series.BHRA Fluid Engineering, 1984.
 <dt>Samoilenko,L.A.:</dt>
    <dd><b>Investigation of the hydraulic resistance of pipelines in the
        zone of transition from laminar into turbulent motion</b>.
        PhD thesis, Leningrad State University, 1968.</dd>
<dt>VDI:</dt> 
    <dd><b>VDI - W&auml;rmeatlas: Berechnungsbl&auml;tter f&uuml;r den W&auml;rme&uuml;bergang</b>. 
    Springer Verlag, 9th edition, 2002.</dd>
</dl>
</html>
"));
end dp_edgedOverall_MFLOW;
