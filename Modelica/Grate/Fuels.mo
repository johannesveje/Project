within Grate;
package Fuels
  extends Modelica.Icons.VariantsPackage;
  partial package PartialFuel
    extends Modelica.Icons.MaterialPropertiesPackage;

    // Constants to be set in Fuel
      constant String fuelName="unusablePartialFuel" "Name of the fuel";
    constant String substanceNames[:]={fuelName}
      "Names of the mixture substances. Set substanceNames={fuelName} if only one substance.";
  end PartialFuel;

  package Types "Types to be used in fuel models"
    extends Modelica.Icons.Package;
    type Density = SI.Density (
        min=0,
        max=1.e5,
        nominal=1,
        start=1) "Type for density with medium specific attributes";
    type MassFraction = Real (
        quantity="MassFraction",
        final unit="kg/kg",
        min=0,
        max=1,
        nominal=0.1) "Type for mass fraction with medium specific attributes";
    type MoleFraction = Real (
        quantity="MoleFraction",
        final unit="mol/mol",
        min=0,
        max=1,
        nominal=0.1) "Type for mole fraction with medium specific attributes";
    type MolarMass = SI.MolarMass (
        min=0.001,
        max=0.25,
        nominal=0.032) "Type for molar mass with medium specific attributes";
    type Temperature = SI.Temperature (
        min=1,
        max=1.e4,
        nominal=300,
        start=300) "Type for temperature with medium specific attributes";

  end Types;
end Fuels;
