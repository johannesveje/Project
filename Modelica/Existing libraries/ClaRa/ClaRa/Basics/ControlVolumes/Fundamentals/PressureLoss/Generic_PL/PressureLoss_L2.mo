within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL;
partial model PressureLoss_L2
extends ClaRa.Basics.Icons.Delta_p;
  SI.Pressure Delta_p;
  outer parameter Boolean useHomotopy;

  annotation (Icon(graphics));

end PressureLoss_L2;
