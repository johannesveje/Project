within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Functions;
function KepplerMean "Apply Keppler's (or Simpson's) rule"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                        //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright � 2013-2015, DYNCAP research team.                                   //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  extends GeneralMean;

algorithm
  Out := -100;//1/6*(A_o_in.cp+4*TILMedia.VLEFluidFunctions.specificIsobaricHeatCapacity_pTxi(TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),(p_o,(A_o_in.T+B_o_in.T)/2)+B_o_in.cp);
end KepplerMean;
