{ config, ... }:

{
  # Walker
  services.elephant.enable = true;
  services.walker = {
    enable = true;
    enableElephantIntegration = config.services.elephant.enable;
    systemd.enable = true;
  };
}
