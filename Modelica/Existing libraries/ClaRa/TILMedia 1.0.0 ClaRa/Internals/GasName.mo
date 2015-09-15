within TILMedia.Internals;
type GasName "Gas name"
  extends String;
  annotation(choices(
    choice="TILMedia.DryAir",
    choice="TILMedia.ExhaustGas_Lambda_1",
 choice="VDIWA.Xenon",
 choice="VDIWA.Krypton",
 choice="VDIWA.Argon",
 choice="VDIWA.Neon",
 choice="VDIWA.Helium",
 choice="VDIWA.DryAir",
 choice="VDIWA.Hydrogen",
 choice="VDIWA.Nitrogen",
 choice="VDIWA.Oxygen",
 choice="VDIWA.Sulfur",
 choice="VDIWA.Fluorine",
 choice="VDIWA.Chlorine",
 choice="VDIWA.Bromine",
 choice="VDIWA.Iodine",
 choice="VDIWA.Hydrogen fluoride",
 choice="VDIWA.Hydrogen chloride",
 choice="VDIWA.Hydrogen bromide",
 choice="VDIWA.Hydrogen Iodide",
 choice="VDIWA.Hydrogen cyanide",
 choice="VDIWA.Water",
 choice="VDIWA.Hydrogen sulfide",
 choice="VDIWA.Ammonia",
 choice="VDIWA.Nitric oxide",
 choice="VDIWA.Nitrogen dioxide",
 choice="VDIWA.Nitrous oxide",
 choice="VDIWA.Dinitrogen tetroxide",
 choice="VDIWA.Cyanogen",
 choice="VDIWA.Cyanogen fluoride",
 choice="VDIWA.Cyanogen chloride",
 choice="VDIWA.Cyanogen bromide",
 choice="VDIWA.Iodine cyanide",
 choice="VDIWA.carbon monoxide",
 choice="VDIWA.carbon dioxide",
 choice="VDIWA.carbon suboxide",
 choice="VDIWA.carbonyl sulfide",
 choice="VDIWA.phosgene",
 choice="VDIWA.carbon disulfide",
 choice="VDIWA.sulfur dioxide",
 choice="VDIWA.sulfur trioxide",
 choice="VDIWA.sulfury chloride",
 choice="VDIWA.sulfur hexafluoride",
 choice="VDIWA.methanethiol",
 choice="VDIWA.ethanethiol",
 choice="VDIWA.dimethyl sulfide",
 choice="VDIWA.diethyl sulfide",
 choice="VDIWA.thiophene",
 choice="VDIWA.fluoromethane",
 choice="VDIWA.difluoromethane",
 choice="VDIWA.trifluoromethane/fluoroform",
 choice="VDIWA.tetrafluoromethane",
 choice="VDIWA.chloromethane",
 choice="VDIWA.dichloromethane",
 choice="VDIWA.methane trichloride/chloroform",
 choice="VDIWA.carbon tetrachloride",
 choice="VDIWA.bromomethane",
 choice="VDIWA.dibromomethane",
 choice="VDIWA.tribromomethane/bromoform",
 choice="VDIWA.tetrabromomethane",
 choice="VDIWA.chlorodifluoromethane",
 choice="VDIWA.dichlorodifluoromethane",
 choice="VDIWA.chlorotrifluoromethane",
 choice="VDIWA.dichlorodifluoromethane",
 choice="VDIWA.trichlorofluoromethane",
 choice="VDIWA.fluoroethane",
 choice="VDIWA.chloroethane",
 choice="VDIWA.bromoethane",
 choice="VDIWA.methane",
 choice="VDIWA.ethane",
 choice="VDIWA.propane",
 choice="VDIWA.butane",
 choice="VDIWA.pentane",
 choice="VDIWA.hexane",
 choice="VDIWA.heptane",
 choice="VDIWA.octane",
 choice="VDIWA.nonane",
 choice="VDIWA.decane",
 choice="VDIWA.undecane",
 choice="VDIWA.dodecane",
 choice="VDIWA.tridecane ",
 choice="VDIWA.tetradecane ",
 choice="VDIWA.pentadecane ",
 choice="VDIWA.hexadecane",
 choice="VDIWA.heptadecane",
 choice="VDIWA.octadecane",
 choice="VDIWA.nonadecane",
 choice="VDIWA.icosane"));
end GasName;
