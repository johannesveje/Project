within Grate;
model Evaporation
  outer Grate.CombustionSystem system "System wide properties";
  // package

  Fuels.BasePackage.fuelInput fuelInput annotation (Placement(transformation(
        extent={{-25,-23},{25,23}},
        rotation=90,
        origin={-93,-1}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-90,0})));
  Modelica.Fluid.Interfaces.FluidPort_a flueGas_in(redeclare package Medium =
        system.FlueGas) annotation (Placement(transformation(extent={{-10,-100},
            {10,-80}}), iconTransformation(extent={{-10,-100},{10,-80}})));
  Modelica.Fluid.Interfaces.FluidPort_b flueGas_out(redeclare package Medium =
        system.FlueGas) annotation (Placement(transformation(extent={{-40,80},{
            -20,100}}), iconTransformation(extent={{-40,80},{-20,100}})));
  Modelica.Fluid.Interfaces.HeatPorts_a heatPorts_a annotation (Placement(
        transformation(extent={{18,80},{38,100}}), iconTransformation(extent={{
            18,80},{38,100}})));
  Fuels.BasePackage.fuelOutput fuelOutput annotation (Placement(transformation(
          extent={{78,-12},{98,8}}), iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={90,0})));

equation
  // Mass balance
  0 = fuelInput.m_flow + flueGas_in.m_flow + flueGas_out.m_flow + fuelOutput.m_flow;
  // Energy balance
  0 = fuelInput.m_flow*fuelInput.heating_value + flueGas_in.m_flow*actualStream(
    flueGas_in.h_outflow) + flueGas_out.m_flow*actualStream(flueGas_out.h_outflow)
     + fuelOutput.m_flow*fuelOutput.heating_value + heatPorts_a.Q_flow;
  // Spicies balance
  zeros(6) = flueGas_in.Xi_outflow + flueGas_out.Xi_outflow;
  annotation (preferredView="text",Icon(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,100}}), graphics={Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid), Text(
          extent={{-76,76},{76,-76}},
          lineColor={85,255,255},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="Evaporation")}));
end Evaporation;
