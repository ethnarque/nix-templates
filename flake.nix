{
  description = "pmlogist's flake templates";

  outputs = {self, ...}: {
    templates = {
      go = {
        path = ./go;
        description = "A go project starter";
      };

      wordpress = {
        path = ./wordpress;
        description = "A wordpress project starter";
      };
    };
  };
}
