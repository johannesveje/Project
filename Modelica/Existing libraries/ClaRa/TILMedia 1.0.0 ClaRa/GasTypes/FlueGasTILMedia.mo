within TILMedia.GasTypes;
record FlueGasTILMedia "Flue gas TILMedia"

  extends TILMedia.GasTypes.BaseGas(
    final fixedMixingRatio=false,
    final nc_propertyCalculation=10,
    final gasNames={"TILMedia.ASH","TILMEDIAXTR.CARBON_MONOXIDE","TILMEDIAXTR.CARBON_DIOXIDE","TILMEDIAXTR.SULFUR_DIOXIDE","TILMEDIAXTR.NITROGEN","TILMEDIAXTR.OXYGEN","TILMEDIAXTR.NITROUS_OXIDE","TILMEDIAXTR.WATER","TILMEDIAXTR.AMMONIA","TILMEDIAXTR.ARGON"},
    final condensingIndex=8,
    final mixingRatio_propertyCalculation={0.001,0.001,0.001,0.001,1,0.001,0.001,0.001,0.001,0.001});
end FlueGasTILMedia;
