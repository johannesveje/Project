within ClaRa.Basics.Media;
model CreateInterpolatedMedium
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                        //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright © 2013-2015, DYNCAP research team.                                   //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;

  TILMedia.VLEFluid_ph refrigerant(redeclare TILMedia.VLEFluidTypes.BaseVLEFluid
                                          vleFluidType(
      fixedMixingRatio=false,
      nc_propertyCalculation=1,
      mixingRatio_propertyCalculation={1},
      VLEFluidNames={
          "Interpolation.createlinear(mediumname=TILMedia.WATER,p=[613:350e5:500],h=[50e3:4200e3:500],filename=Water.dat)"}),
      p=1e5,
      h=1e6,
      computeTransportProperties=true)
    annotation (Placement(transformation(extent={{-30,16},{-10,36}})));

 TILMedia.VLEFluid_ph refrigerant2(redeclare TILMedia.VLEFluidTypes.BaseVLEFluid
                                          vleFluidType(
      fixedMixingRatio=false,
      nc_propertyCalculation=1,
      mixingRatio_propertyCalculation={1},
      VLEFluidNames={
          "Interpolation.createspline(mediumname=TILMedia.WATER,p=[613:350e5:200],h=[10e3:4200e3:200],nStepSat=300,filename=Water_Spline.dat)"}),
      p=1e5,
      h=1e6,
      computeTransportProperties=true)
    annotation (Placement(transformation(extent={{-30,16},{-10,36}})));

  annotation (Icon(graphics));
end CreateInterpolatedMedium;
