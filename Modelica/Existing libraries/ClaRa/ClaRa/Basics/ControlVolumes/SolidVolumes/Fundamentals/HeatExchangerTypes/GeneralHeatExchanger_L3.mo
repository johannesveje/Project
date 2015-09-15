within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes;
partial model GeneralHeatExchanger_L3

  import Modelica.Constants.eps;
  input Real NTU_1[3];
  input Real R_1[3];
  output Real CF_NTU[3];

  parameter Real a;
  parameter Real b;
  parameter Real c;
  parameter Real d;

  outer ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.ICom_NTU_L3 iCom;
  outer Boolean outerPhaseChange;
  outer Real yps_2ph;
  outer Real yps_1ph;

  Real yps[3];

  ClaRa.Basics.Units.EnthalpyMassSpecific h_i_in[3];
  ClaRa.Basics.Units.EnthalpyMassSpecific h_o_in[3];

  ClaRa.Basics.Units.Temperature T_in2out_o[6];
  ClaRa.Basics.Units.Temperature T_in2out_i[6];
  Real ff_i[3] "Mass Flow Fraction for the three zones at inner side";
  Real ff_o[3] "Mass Flow Fraction for the three zones at outer side";
  Real z_i[6] "Position of the zones at the inner side of the heat exchanger";
  Real z_o[6] "Position of the zones at the outer side of the heat exchanger";

equation
  CF_NTU = {1/(1+a*R_1[i]^(d*b)*max(eps,NTU_1[i])^b)^c for i in 1:3};

  annotation (Icon(graphics={        Polygon(
          points={{100,-34},{100,-36},{46,-24},{46,-24},{10,-46},{-40,6},{-48,
              16},{-22,36},{-20,38},{-100,56},{-100,56},{-100,-28},{-98,-26},{
              -72.8125,-12.4375},{-72,-14},{0,-102},{100,-34}},
          smooth=Smooth.Bezier,
          fillColor={153,205,211},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={0,6},
          rotation=180,
          lineColor={0,0,0}),        Polygon(
          points={{100,-34},{100,-36},{66,4},{66,4},{10,-46},{-40,6},{-48,16},{
              -22,36},{-20,38},{-100,56},{-100,56},{-100,-28},{-98,-26},{
              -72.8125,-12.4375},{-72,-14},{0,-102},{100,-34}},
          smooth=Smooth.Bezier,
          fillColor={51,156,186},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={0,-14},
          rotation=0,
          lineColor={0,0,0})}));
end GeneralHeatExchanger_L3;
