within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals;
record ICom_NTU_L3
  extends ClaRa.Basics.Icons.RecordIcon;

   input ClaRa.Basics.Units.Temperature T_123_o[6]
                                               annotation(Dialog);
   input ClaRa.Basics.Units.Temperature T_123_i[6]
                                               annotation(Dialog);
   input ClaRa.Basics.Units.Temperature T_in2out_o[6]
                                                  annotation(Dialog);
   input ClaRa.Basics.Units.Temperature T_in2out_i[6]
                                                  annotation(Dialog);

  input ClaRa.Basics.Units.EnthalpyMassSpecific h_i_inlet
                                                      annotation(Dialog);
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_o_inlet
                                                      annotation(Dialog);
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_i_in[3]
                                                      annotation(Dialog);
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_o_in[3]
                                                      annotation(Dialog);

   ClaRa.Basics.Units.EnthalpyMassSpecific h_i_out[3];
   ClaRa.Basics.Units.EnthalpyMassSpecific h_o_out[3];

  input ClaRa.Basics.Units.EnthalpyMassSpecific h_o_vap
                                                    annotation(Dialog);
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_o_bub
                                                    annotation(Dialog);
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_i_vap
                                                    annotation(Dialog);
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_i_bub
                                                    annotation(Dialog);

  ClaRa.Basics.Units.EnthalpyMassSpecific Delta_h_1ph;
  ClaRa.Basics.Units.EnthalpyMassSpecific Delta_h_2ph;

end ICom_NTU_L3;
