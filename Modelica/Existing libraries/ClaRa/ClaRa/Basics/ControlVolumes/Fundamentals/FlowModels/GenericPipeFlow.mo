within ClaRa.Basics.ControlVolumes.Fundamentals.FlowModels;
partial model GenericPipeFlow

  annotation (Icon(graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={43,141,13}),
        Text(
          extent={{100,-20},{-100,20}},
          lineColor={0,0,255},
          textString="fm"),
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255}),
        Line(
          points={{-60,-60},{60,-60}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{20,-40},{58,-60},{20,-80}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=0.5)}));
end GenericPipeFlow;
