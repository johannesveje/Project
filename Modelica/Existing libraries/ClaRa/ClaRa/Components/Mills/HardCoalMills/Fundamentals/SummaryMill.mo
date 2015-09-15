within ClaRa.Components.Mills.HardCoalMills.Fundamentals;
record SummaryMill "A summary record for a roller bowl mill"

extends ClaRa.Basics.Icons.RecordIcon;
  input Modelica.SIunits.MassFlowRate m_flow_coal_in "Coal mass flow entering the mill"
                                       annotation(Dialog);
  input Modelica.SIunits.MassFlowRate m_flow_coal_out "Coal mass flow leaving the mill"
                                     annotation(Dialog);
  input Modelica.SIunits.MassFlowRate m_flow_air_in "Coal mass flow entering the mill"
                                       annotation(Dialog);
  input Modelica.SIunits.MassFlowRate m_flow_air_out "Coal mass flow leaving the mill"
                                     annotation(Dialog);
  input Modelica.SIunits.MassFlowRate m_flow_tot_in "Total mass flow entering the mill"
                                       annotation(Dialog);
  input Modelica.SIunits.MassFlowRate m_flow_tot_out "Total mass flow leaving the mill"
                                     annotation(Dialog);

  input Modelica.SIunits.Temperature T_out "Classifier temperature" annotation(Dialog);
  input Modelica.SIunits.Temperature T_coal_in "Coal inlet temperature" annotation(Dialog);
  input Modelica.SIunits.Temperature T_air_in "Primary air inlet temperature" annotation(Dialog);
  input Modelica.SIunits.Frequency rpm_classifier "Classifier speed" annotation(Dialog);
  input Modelica.SIunits.Power P_grind "Power consumed for grinding" annotation(Dialog);
  input Modelica.SIunits.Mass mass_coal "Total coal mass in the mill" annotation(Dialog);

end SummaryMill;
