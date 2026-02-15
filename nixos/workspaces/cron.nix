{ pkgs, ... }:
{
  services.cron.enable = true;

  environment.systemPackages = with pkgs; [
    lsof
    moreutils
  ];
}
