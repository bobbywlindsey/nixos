{ config, pkgs, lib, ... }: {

  options = {
    security.enable = 
      lib.mkEnableOption "enables security module";

    security.devices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = lib.literalExample ''
          [
            "eth0"
            "wlan0"
          ]
        '';
      description = ''
          List of devices to include for MAC address spoofing.
        '';
    };
  };

  config = lib.mkIf config.security.enable {

    environment.systemPackages = with pkgs; [
      mullvad-vpn
      macchanger
      iproute2
      veracrypt
    ];

    # Spoof mac address
    # Can be run at any time with:
    # sudo systemctl start macchanger-wlan0.service
    systemd.services = lib.mkMerge (lib.forEach config.security.devices (x:
      {
        "macchanger-${x}" = {
          description = "Randomize MAC address of ${x}";
          wants = [ "network-pre.target" ];
          wantedBy = [ "multi-user.target" ];
          before = [ "network-pre.target" ];
          bindsTo = [ "sys-subsystem-net-devices-${x}.device" ];
          after = [ "sys-subsystem-net-devices-${x}.device" ];
          script = ''
            get_current_mac_of_nic() {
              local mac
              mac="$(${pkgs.macchanger}/bin/macchanger "''${1}" | sed -n "s/^Current\s*MAC:\s*\([0-9a-f:]\+\)\s.*$/\1/p" || :)"
              if echo "''${mac}:" | grep -q "^\([0-9a-fA-F]\{2\}:\)\{6\}$"; then
                echo "''${mac}"
              fi
            }

            OLD_MAC="$(get_current_mac_of_nic "${x}")"

            ${pkgs.iproute2}/bin/ip link set "${x}" down

            # There is a 1/2^24 chance macchanger will randomly pick the real MAC
            # address. We try to make it really unlikely by repeating it up to
            # three times. Theoretically speaking, this leaks information about the
            # real MAC address at each occasion but actually leaking the real MAC
            # address will be more serious in practice.
            for i in 1 2 3; do
              ${pkgs.macchanger}/bin/macchanger -e "${x}" || true
              NEW_MAC="$(get_current_mac_of_nic "${x}")"
              if [ "''${OLD_MAC}" != "''${NEW_MAC}" ]; then
                break
              fi
            done

            ${pkgs.iproute2}/bin/ip link set "${x}" up
            '';
          serviceConfig.Type = "oneshot";
        };
      }
    ));
  };

}
