# machine-specific config goes here
{ pkgs, ... }:
{
  # NOTE: remember to add at least one ssh key if you need ssh access
  nut.ssh.authorizedKeys = [
    "ssh-ed25519 ... user@machine"
  ];

  environment.systemPackages = with pkgs; [
    git
    neovim
  ];
}
