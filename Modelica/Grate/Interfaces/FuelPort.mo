within Grate.Interfaces;
connector FuelPort
  flow SI.MassFlowRate m_flow;
  SI.Pressure p;
  stream SI.Enthalpy h_outflow;
  stream SI.MassFraction Xi_outflow[:];

end FuelPort;
