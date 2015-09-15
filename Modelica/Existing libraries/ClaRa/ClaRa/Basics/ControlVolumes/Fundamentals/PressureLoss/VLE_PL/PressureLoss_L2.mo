within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL;
partial model PressureLoss_L2
extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2;
  outer ClaRa.Basics.Records.IComVLE_L2 iCom;
    outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;
end PressureLoss_L2;
