within Grate;
connector MassPort
  flow SI.MassFlowRate m_flow;
  SI.Temperature T;
  stream SI.MassFraction Xi_outflow[nXi];
  Integer nXi;

end MassPort;
