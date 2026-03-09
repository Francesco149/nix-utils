{
  assertions = [
    {
      assertion = false;
      message = ''
        =========================================================================
        please provide your machine's hosts/nixos/hardware-configuration.nix

        generate this with:
          nixos-generate-config --show-hardware-config > \
            hosts/nixos/hardware-configuration.nix
        or copy from /etc/nixos/hardware-configuration.nix on the target machine
        =========================================================================
      '';
    }
  ];
}
