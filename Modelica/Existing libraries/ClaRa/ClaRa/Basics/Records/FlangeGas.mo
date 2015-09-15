within ClaRa.Basics.Records;
record FlangeGas "A summary record for gas flanges"

    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.MassFlowRate m_flow "Mass flow rate"
      annotation (Dialog);
    input ClaRa.Basics.Units.Temperature T "Temperature" annotation (Dialog);
    input ClaRa.Basics.Units.Pressure p "Pressure" annotation (Dialog);
    input ClaRa.Basics.Units.EnthalpyMassSpecific h "Specific enthalpy"
      annotation (Dialog);
    input ClaRa.Basics.Units.Power H_flow "Enthalpy flow rate" annotation(Dialog);

end FlangeGas;
