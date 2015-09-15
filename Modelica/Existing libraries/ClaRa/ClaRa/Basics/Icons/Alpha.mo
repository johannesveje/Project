within ClaRa.Basics.Icons;
model Alpha

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Bitmap(
          extent={{-100,100},{100,-100}},
          imageSource=
              "iVBORw0KGgoAAAANSUhEUgAAAjAAAAIwCAIAAAAXk8Y4AAAABmJLR0QA/wD/AP+gvaeTAAAgAElEQVR4nO3d+Xsc5YHo++qu6up9VUtqrZYsL9jGNl5YjCFmCZCEEEKSCcmczNy5957n/EvnpzMnd+4zJ5ksE4YQIBAgLLYBL9gGG6/IlrW2pFbvXV1d1XV+EMdDDJiWVFX9tvT9/DBPYrrrfZ2x+Lqq3nrL86u+eyQAANrN2+4JAAAgSQQJACAIggQAEAJBAgAIgSABAIRAkAAAQiBIAAAhECQAgBAIEgBACAQJACAEggQAEAJBAgAIgSABAIRAkAAAQiBIAAAhECQAgBAIEgBACAQJACAEggQAEAJBAgAIgSABAISgrP0Q3Q/sj28ZXftxAAAdqnB1fP7902s8iA1BCg/0JffuXPtxAAAdyqhp82s+CJfsAABCIEgAACEQJACAEAgSAEAIBAkAIASCBAAQAkECAAiBIAEAhECQAABCIEgAACEQJACAEAgSAEAIBAkAIASCBAAQAkECAAiBIAEAhECQAABCIEgAACEQJACAEAgSAEAIBAkAIASCBAAQAkECAAiBIAEAhECQAABCIEgAACEQJACAEAgSAEAIBAkAIASCBAAQAkECAAiBIAEAhECQAABCIEgAACEQJACAEAgSAEAIBAkAIASCBAAQAkECAAiBIAEAhECQAABCIEgAACEQJACAEAgSAEAIBAkAIASCBAAQAkECAAiBIAEAhECQAABCIEgAACEQJACAEAgSAEAIBAkAIASCBAAQAkECAAiBIAEAhECQAABCIEgAACEQJACAEAgSAEAIBAkAIASCBAAQAkECAAiBIAEAhECQAABCIEgAACEQJACAEAgSAEAIBAkAIASCBAAQAkECAAiBIAEAhECQAABCIEgAACEQJACAEAgSAEAIBAkAIASCBAAQAkECAAiBIAEAhECQAABCIEgAACEQJACAEAgSAEAIBAkAIASCBAAQAkECAAiBIAEAhECQAABCIEgAACEQJACAEAgSAEAIBAkAIASCBAAQAkECAAiBIAEAhECQAABCIEgAACEQJACAEAgSAEAIBAkAIASCBAAQAkECAAiBIAEAhECQAABCIEgAACEQJACAEAgSAEAIBAkAIASCBAAQAkECAAiBIAEAhECQAABCIEgAACEQJACAEAgSAEAIBAkA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",
          fileName="modelica://ClaRa/figures/Components/Alpha.png")}));

end Alpha;
