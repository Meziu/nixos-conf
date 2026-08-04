{ config, pkgs, ...}:

{
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.214.101.10/24" ];
      dns = [ "10.214.101.1" ];
      privateKeyFile = "/etc/wireguard/wireguardvpn.key";

      peers = [
        {
          publicKey = "EP85eSyvxoRWRdzM/FGuQ8zZ/Vr43CBhvUq6bhZkG3Y=";
          presharedKeyFile = "/etc/wireguard/wireguardvpn.psk";
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = "meziu.ddns.net:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
