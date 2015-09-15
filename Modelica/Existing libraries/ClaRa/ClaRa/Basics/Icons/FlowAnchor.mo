within ClaRa.Basics.Icons;
model FlowAnchor

  annotation (Diagram(coordinateSystem(extent={{-100,-50},{100,50}}, preserveAspectRatio=false)), Icon(coordinateSystem(extent={{-100,-50},{100,50}}, preserveAspectRatio=false), graphics={Bitmap(
          extent={{-100,50},{100,-50}},
          imageSource=
              "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",
          fileName="modelica://ClaRa/figures/Components/FlowAnchor.png")}));

end FlowAnchor;
