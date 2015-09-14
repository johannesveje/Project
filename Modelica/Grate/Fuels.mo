within Grate;
package Fuels
  extends Modelica.Icons.VariantsPackage;

  package BasePackage

    expandable connector fuelInput
      extends Modelica.Icons.SignalBus;

      SI.MassFlowRate m_flow annotation ();
      SI.SpecificEnergy heating_value annotation ();
      SI.Density rho annotation ();
      SI.Temperature T;
      SI.MassFraction prox[3] annotation ();
      SI.MassFraction ulti[5] annotation ();
      SI.MassFraction spicies[1] annotation ();
      SI.MolarMass MM;

      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
                -100,-100},{100,100}})));
    end fuelInput;

    expandable connector fuelOutput
      extends Modelica.Icons.SignalBus;

      SI.MassFlowRate m_flow annotation ();
      SI.SpecificEnergy heating_value annotation ();
      SI.Density rho annotation ();
      SI.Temperature T;
      SI.MassFraction prox[3] annotation ();
      SI.MassFraction ulti[5] annotation ();
      SI.MassFraction spicies[1] annotation ();
      SI.MolarMass MM;

      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
                -100,-100},{100,100}})));
    end fuelOutput;
  end BasePackage;

  block FuelSource
    package FuelData = Grate.Fuels.FuelData;

    parameter SI.MassFlowRate m_flow=1 "Mass flow of the fuel";
    parameter SI.SpecificEnergy heating_value(displayUnit="MJ/kg") = 15e6
      "Heating Value of the fuel at temperature T" annotation (Evaluate=true);
    parameter SI.Density rho=1 "Density of the fuel";
    parameter SI.Temperature T(displayUnit="degC") = 298.15
      "Temperature of the fuel";
    parameter SI.MassFraction prox_moi=1 "Mass fraction of Moisture"
      annotation (Dialog(group="Proximate Analysis (As recieved)"));
    parameter SI.MassFraction prox_com=1 "Mass fraction of Combustibles"
      annotation (Dialog(group="Proximate Analysis (As recieved)"));
    parameter SI.MassFraction prox_ash=1 "Mass fraction of Ash"
      annotation (Dialog(group="Proximate Analysis (As recieved)"));

    parameter Boolean use_ultimate=true "Use ultimate analasis data"
      annotation (
      Dialog(group="Ultimate Analysis (dry)"),
      Evaluate=true,
      HideResult=true,
      choices(checkBox=true));
    parameter SI.MassFraction ulti_C=1 "Mass fraction of Carbon (C)"
      annotation (Dialog(group="Ultimate Analysis (dry)", enable=use_ultimate));
    parameter SI.MassFraction ulti_H=1 "Mass fraction of Hydrogen (H)"
      annotation (Dialog(group="Ultimate Analysis (dry)", enable=use_ultimate));
    parameter SI.MassFraction ulti_O=1 "Mass fraction of Oxygen (O)"
      annotation (Dialog(group="Ultimate Analysis (dry)", enable=use_ultimate));
    parameter SI.MassFraction ulti_N=1 "Mass fraction of Nitrogen (N)"
      annotation (Dialog(group="Ultimate Analysis (dry)", enable=use_ultimate));
    parameter SI.MassFraction ulti_S=1 "Mass fraction of Sulfur (S)"
      annotation (Dialog(group="Ultimate Analysis (dry)", enable=use_ultimate));

    parameter Boolean use_spicies=false "Use spicies analasis data" annotation
      (
      Dialog(group="Spicies Analysis (As recieved)"),
      Evaluate=true,
      HideResult=true,
      choices(checkBox=true));
    parameter SI.MassFraction spicies_CO2=1 "Mass fraction of CO2" annotation (
        Dialog(group="Spicies Analysis (As recieved)", enable=use_spicies));

  protected
    parameter SI.MassFraction prox[:];
    parameter SI.MassFraction ulti[:];
    parameter SI.MassFraction spicies[:];
    parameter String prox_names[:];
    parameter String ulti_names[:];
    parameter String spicies_names[:];
    // parameter SI.MassFraction prox_uni[:];
    // parameter SI.MassFraction ulti_uni[:];
    // parameter SI.MassFraction prox_uni[:];
    parameter SI.MolarMass M;

  public
    output BasePackage.fuelOutput fuelOutput1 annotation (Placement(
          transformation(
          extent={{-11,-10},{11,10}},
          rotation=90,
          origin={97,0}), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={90,0})));

  algorithm
    // Proximate index //
    prox[FuelData.Index.Proximate.Ash] := prox_ash;
    prox_names[FuelData.Index.Proximate.Ash] := "Ash";
    prox[FuelData.Index.Proximate.Combustibles] := prox_com;
    prox_names[FuelData.Index.Proximate.Combustibles] := "Combustibles";
    prox[FuelData.Index.Proximate.Moisture] := prox_moi;
    prox_names[FuelData.Index.Proximate.Moisture] := "Moisture";
    prox := prox/sum(prox);

    // Ultimate index //
    ulti[FuelData.Index.Ultimate.Carbon] := ulti_C;
    ulti_names[FuelData.Index.Ultimate.Carbon] := "Carbon";
    ulti[FuelData.Index.Ultimate.Hydrogen] := ulti_H;
    ulti_names[FuelData.Index.Ultimate.Hydrogen] := "Hydrogen";
    ulti[FuelData.Index.Ultimate.Nitrogen] := ulti_N;
    ulti_names[FuelData.Index.Ultimate.Nitrogen] := "Nitrogen";
    ulti[FuelData.Index.Ultimate.Oxygen] := ulti_O;
    ulti_names[FuelData.Index.Ultimate.Oxygen] := "Oxygen";
    ulti[FuelData.Index.Ultimate.Sulfur] := ulti_S;
    ulti_names[FuelData.Index.Ultimate.Sulfur] := "Sulfur";
    ulti := ulti/sum(ulti);

    // Spicies index //
    spicies[FuelData.Index.Spicies.CO2] := spicies_CO2;
    spicies_names[FuelData.Index.Spicies.CO2] := "CO2";
    spicies := spicies/sum(spicies);

    // Molar Mass //
    M := (ulti[FuelData.Index.Ultimate.Carbon]/Modelica.Media.IdealGases.Common.SingleGasesData.C.MM
       + ulti[FuelData.Index.Ultimate.Hydrogen]/Modelica.Media.IdealGases.Common.SingleGasesData.H.MM
       + ulti[FuelData.Index.Ultimate.Oxygen]/Modelica.Media.IdealGases.Common.SingleGasesData.O.MM
       + ulti[FuelData.Index.Ultimate.Nitrogen]/Modelica.Media.IdealGases.Common.SingleGasesData.N.MM
       + ulti[FuelData.Index.Ultimate.Sulfur]/Modelica.Media.IdealGases.Common.SingleGasesData.S.MM)
      ^(-1);

    // Writing to output //
    fuelOutput1.m_flow := m_flow;
    fuelOutput1.heating_value := heating_value;
    fuelOutput1.rho := rho;
    fuelOutput1.T := T;
    fuelOutput1.prox := prox;
    fuelOutput1.ulti := ulti;
    fuelOutput1.spicies := spicies;
    fuelOutput1.MM := M;

    Modelica.Media.IdealGases.Common.Functions.cp_T(Modelica.Media.IdealGases.Common.SingleGasesData.C,
      T);

    annotation (preferredView="text", Icon(coordinateSystem(preserveAspectRatio
            =false, extent={{-100,-100},{100,100}}), graphics={Rectangle(
            extent={{-80,80},{80,-80}},
            lineColor={28,108,200},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid), Text(
            extent={{-78,78},{78,-78}},
            lineColor={128,255,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="Fuel")}));
  end FuelSource;

  package FlueGas
    extends Modelica.Media.IdealGases.MixtureGases.FlueGasSixComponents;
    constant Integer components=size(substanceNames, 1);

  end FlueGas;

  package FuelData
    package Index
      package Proximate
        constant Integer Moisture=1;
        constant Integer Combustibles=2;
        constant Integer Ash=3;
      end Proximate;

      package Ultimate
        constant Integer Carbon=1;
        constant Integer Hydrogen=2;
        constant Integer Oxygen=3;
        constant Integer Nitrogen=4;
        constant Integer Sulfur=5;
      end Ultimate;

      package Spicies
        constant Integer CO2=1;
      end Spicies;
    end Index;

  end FuelData;
end Fuels;
