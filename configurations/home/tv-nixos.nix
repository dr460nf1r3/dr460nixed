{lib, ...}: {
  # I use Spotify on this machine
  imports = [./spicetify.nix];

  # These need to be configured individually
  dconf.settings = {
    "org/gnome/shell/extensions/gsconnect" = {
      devices = ["c9b46110e36de16a" "b7e645a0-b149-48a0-8fd8-81ab6bc5ef11"];
      enabled = true;
      id = "a4f40eab-47db-47b6-9fda-a4c71d9f2893";
      name = "TV NixOS";
    };
    "org/gnome/desktop/remote-desktop/rdp" = {
      enable = true;
      tls-cert = "/home/nico/.local/share/gnome-remote-desktop/rdp-tls.crt";
      tls-key = "/home/nico/.local/share/gnome-remote-desktop/rdp-tls.key";
      view-only = false;
    };
    "org/gnome/shell/extensions/gsconnect/device/b7e645a0-b149-48a0-8fd8-81ab6bc5ef11" = {
      certificate-pem = "-----BEGIN CERTIFICATE-----\nMIIFpTCCA42gAwIBAgIUcvRMlpmA6RnVCiKvTuiBH2oExb4wDQYJKoZIhvcNAQEL\nBQAwYjEdMBsGA1UECgwUYW5keWhvbG1lcy5naXRodWIuaW8xEjAQBgNVBAsMCUdT\nQ29ubmVjdDEtMCsGA1UEAwwkYjdlNjQ1YTAtYjE0OS00OGEwLThmZDgtODFhYjZi\nYzVlZjExMB4XDTIzMDMwNzE5NDYzN1oXDTMzMDMwNDE5NDYzN1owYjEdMBsGA1UE\nCgwUYW5keWhvbG1lcy5naXRodWIuaW8xEjAQBgNVBAsMCUdTQ29ubmVjdDEtMCsG\nA1UEAwwkYjdlNjQ1YTAtYjE0OS00OGEwLThmZDgtODFhYjZiYzVlZjExMIICIjAN\nBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAxaBBOfKvLcZ/5sZM6bi3u5g1HbrY\ndR6zulol8q0XhH4NUrFilKG7le+47QBG9AJQk4/nlok/W1d7cCy23Sd3FYyIlIjh\nWCa1ecUL8C3JskqyVMuAx3VuxfyXBmM+6UCbaa3sHmxKxVm4KUeOGC8UIBg/AiCo\n5IOny3G/uopcop7zn2twmxcmURZPUgcrA+eRifAw9Q66oa3BVDSE8x+kL3JKDMQz\nkcTer9wUyqsdMtMpvy/vNfWfJrl2HGfTjQW5iPzJgZZLEzExtlDbuuUnmA/9WD0a\nyIcf+B1xregbTF2uefCG40RqYYaj9rqeskCuBU9D6DuLHZyiAcu/wbcbMKSojoqh\nNL4PkBGhWfFsDNTawSC8pJRVbRDQODHtw2TkaKJianw+gjFqnJYs416rTCZCjnRm\nUkHyqqgCE5govKQ3/BMpEqyFWhE4hRPnFanuh8b7FCd+K1FCbMnLv08gK8WBnqOK\nOp1aS4RzxMx6zszBv4nA7vKOql0OUEHpX2dLN0heD72SEVHIGdfCQ4FgOgh5VQ4H\n28JjKQUlf4ZCsm+zfmSHerkk7lEIG/1nyJH5wsQONqMV6tJLUqeExAwZUqFRyQuQ\nZMhRyRQ2sVa9TBg2ZACZKFyD/t9IT/bUqfsT4VM/KcD8AxN/sHdbkvB/PT4JNhYK\n5q3mTxlCKisX18cCAwEAAaNTMFEwHQYDVR0OBBYEFJMZUaWmNfJgFvXfNQj2uL4l\nu+S5MB8GA1UdIwQYMBaAFJMZUaWmNfJgFvXfNQj2uL4lu+S5MA8GA1UdEwEB/wQF\nMAMBAf8wDQYJKoZIhvcNAQELBQADggIBAAHvqE1sRJai6/wgNpVKhzS6/D6eJTWX\n9doypcWv3N2eIPJVqOxbSACNrTAbnz6OjkGCfR8mjWd6olg3/t7eGjO7vpXD8anj\na0de3124h4DNz7hjbGICZM7Tt2paInTS3cne3Kev5ajxbtDWWfLVBcqrtIp6w8fv\nXcb7NKqyfAKacpjn2cDP5VzOM+ql85bWERV6cDS0FyFWXUHn0EUALp5PqPcyCu8p\niY50wYsDm1OhqshxXa8kWTyJ8D84fk7A+7zcwc/gb6zcpD1fAj5pJW0tzljiwUzI\nUjuauOTWJ4euEafAgqntaPJTYfxztFpP5IAM/yDMctlhQfYLpAIohTR4JUaivzra\ncy14GQjo47o+wuPPJwijF+Tx/D96OOU4zIqkXv9FmYUOV+DjZgL5lehP5CNe/XP6\nkdAHjf0kWJzdOAbCgLNxTg5qcxHvMVR+OoJraP6MNIB34TzFFvAZTUsooPKARDuj\nZT7ktUW9lROCXQBQIagl2tRfS/BWccxAs3kV6w9UKXSFxgt3Tx/pDKfSlB7py6aN\nbySbVqUGtijtpgzGOx5dxjXGnLiJer99FcmYFQxS/lCrAKtJkl+0OB9D5YfluOcI\naAqWKIaXtlYZI8Ph6J/FNsE4mDVXCVCst59aeKhPdvLK9JOf93y2UUpbmD2MtK0z\n75h46brgIObg\n-----END CERTIFICATE-----\n";
      incoming-capabilities = ["kdeconnect.battery" "kdeconnect.battery.request" "kdeconnect.clipboard" "kdeconnect.clipboard.connect" "kdeconnect.connectivity_report" "kdeconnect.contacts.response_uids_timestamps" "kdeconnect.contacts.response_vcards" "kdeconnect.findmyphone.request" "kdeconnect.mousepad.echo" "kdeconnect.mousepad.keyboardstate" "kdeconnect.mousepad.request" "kdeconnect.mpris" "kdeconnect.mpris.request" "kdeconnect.notification" "kdeconnect.notification.request" "kdeconnect.photo" "kdeconnect.photo.request" "kdeconnect.ping" "kdeconnect.presenter" "kdeconnect.runcommand" "kdeconnect.runcommand.request" "kdeconnect.sftp" "kdeconnect.share.request" "kdeconnect.sms.messages" "kdeconnect.systemvolume.request" "kdeconnect.telephony"];
      name = "Slim Nixed";
      outgoing-capabilities = ["kdeconnect.battery" "kdeconnect.battery.request" "kdeconnect.clipboard" "kdeconnect.clipboard.connect" "kdeconnect.connectivity_report.request" "kdeconnect.contacts.request_all_uids_timestamps" "kdeconnect.contacts.request_vcards_by_uid" "kdeconnect.findmyphone.request" "kdeconnect.mousepad.echo" "kdeconnect.mousepad.keyboardstate" "kdeconnect.mousepad.request" "kdeconnect.mpris" "kdeconnect.mpris.request" "kdeconnect.notification" "kdeconnect.notification.action" "kdeconnect.notification.reply" "kdeconnect.notification.request" "kdeconnect.photo" "kdeconnect.photo.request" "kdeconnect.ping" "kdeconnect.runcommand" "kdeconnect.runcommand.request" "kdeconnect.sftp.request" "kdeconnect.share.request" "kdeconnect.sms.request" "kdeconnect.sms.request_conversation" "kdeconnect.sms.request_conversations" "kdeconnect.systemvolume" "kdeconnect.telephony.request" "kdeconnect.telephony.request_mute"];
      paired = true;
      supported-plugins = ["battery" "clipboard" "findmyphone" "mousepad" "mpris" "notification" "photo" "ping" "runcommand" "share"];
      type = "laptop";
    };
    "org/gnome/shell/extensions/gsconnect/device/b7e645a0-b149-48a0-8fd8-81ab6bc5ef11/plugin/battery" = {
      custom-battery-notification = true;
      custom-battery-notification-value = lib.hm.gvariant.mkUint32 85;
      full-battery-notification = true;
    };
    "org/gnome/shell/extensions/gsconnect/device/b7e645a0-b149-48a0-8fd8-81ab6bc5ef11/plugin/clipboard" = {
      receive-content = true;
      send-content = true;
    };
    "org/gnome/shell/extensions/gsconnect/device/b7e645a0-b149-48a0-8fd8-81ab6bc5ef11/plugin/notification" = {
      applications = ''
        {"Power":{"iconName":"org.gnome.Settings-power-symbolic","enabled":true},"Lutris":{"iconName":"lutris","enabled":true},"Software":{"iconName":"org.gnome.Software","enabled":true},"Clocks":{"iconName":"org.gnome.clocks","enabled":true},"Color":{"iconName":"org.gnome.Settings-color-symbolic","enabled":true},"Archive Manager":{"iconName":"org.gnome.FileRoller","enabled":true},"PulseEffects":{"iconName":"pulseeffects","enabled":true},"Printers":{"iconName":"org.gnome.Settings-printers-symbolic","enabled":true},"Telegram Desktop":{"iconName":"telegram","enabled":true},"Files":{"iconName":"org.gnome.Nautilus","enabled":true},"Disk Usage Analyzer":{"iconName":"org.gnome.baobab","enabled":true},"Disks":{"iconName":"org.gnome.DiskUtility","enabled":true},"Evolution Alarm Notify":{"iconName":"appointment-soon","enabled":true},"Date & Time":{"iconName":"org.gnome.Settings-time-symbolic","enabled":true}}
      '';
    };
    "org/gnome/shell/extensions/gsconnect/device/b7e645a0-b149-48a0-8fd8-81ab6bc5ef11/plugin/share" = {
      receive-directory = "/home/nico/Downloads";
    };
    "org/gnome/shell/extensions/gsconnect/device/c9b46110e36de16a" = {
      certificate-pem = "-----BEGIN CERTIFICATE-----\nMIIC9zCCAd+gAwIBAgIBATANBgkqhkiG9w0BAQsFADA/MRkwFwYDVQQDDBBjOWI0\nNjExMGUzNmRlMTZhMRQwEgYDVQQLDAtLREUgQ29ubmVjdDEMMAoGA1UECgwDS0RF\nMB4XDTIxMTIzMTIzMDAwMFoXDTMxMTIzMTIzMDAwMFowPzEZMBcGA1UEAwwQYzli\nNDYxMTBlMzZkZTE2YTEUMBIGA1UECwwLS0RFIENvbm5lY3QxDDAKBgNVBAoMA0tE\nRTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMnPph3GhrOXIBrSry6i\nt3I7v9Jy51Cq3izAxh3VNaUCNjkDCCK02hYkKkbMlkixzEIWDGQhvj3nEGp/MWE5\no5A7eE+6n70dKwTa23pJpNy2Vw5B+Kzv6WEslt4XsPhavlC/hvEQRsGPFuW1H02m\nLshuwGT42wbtDVYoSjlETpOTmTHnhEVblXhUoScvYqBocPEVIG55lYXB6ghyyJMX\n/inI4cYdx2K+mirdOqNNNXUOHDkxX8SqBor8czgKGs6rETRC/WP/mUeY3Co+SwlS\nnTkq0VnB8G27VMOlyDd5vXePKxUS7XczaAsNv4D3G8d2S/Z+pDQAEXZF/3qqophT\nPFECAwEAATANBgkqhkiG9w0BAQsFAAOCAQEABX3p3gFU1uWa/oxBveAnBdxZAdTR\n/Z3EqJTKM8NQBgGgEZ4HPPPZF6le0/yqoaSU8Tdo8Q8atNrtKK7o9RWsOl3aG4MY\nIXTOorKqw6EaBZ4++GPTPwf8wgkwjmfgGvVKzYEaDxMsjvYgKhD3DKTmX2iHFuq8\njNZ+Twnv5clHFI7/4sqPmkEBSsS+sGAwgBwTVl4nTk+Rl7qwz485dmZ1tZQxqZaW\nLzKFpr2rDkBtSRyEr9uzyH/UkWaL2LeFkMqkZEgAtRURcorh0CTnO8mGpHFzyfqL\nZSgjp6Mw7RMXlvZAcoME6cdQPURJZhF99Xqz7wvzmC+mx6NnO+juq71IZg==\n-----END CERTIFICATE-----\n";
      incoming-capabilities = ["kdeconnect.battery" "kdeconnect.battery.request" "kdeconnect.bigscreen.stt" "kdeconnect.clipboard" "kdeconnect.clipboard.connect" "kdeconnect.connectivity_report.request" "kdeconnect.contacts.request_all_uids_timestamps" "kdeconnect.contacts.request_vcards_by_uid" "kdeconnect.findmyphone.request" "kdeconnect.mousepad.keyboardstate" "kdeconnect.mousepad.request" "kdeconnect.mpris" "kdeconnect.mpris.request" "kdeconnect.notification" "kdeconnect.notification.action" "kdeconnect.notification.reply" "kdeconnect.notification.request" "kdeconnect.photo.request" "kdeconnect.ping" "kdeconnect.runcommand" "kdeconnect.sftp.request" "kdeconnect.share.request" "kdeconnect.share.request.update" "kdeconnect.sms.request" "kdeconnect.sms.request_attachment" "kdeconnect.sms.request_conversation" "kdeconnect.sms.request_conversations" "kdeconnect.systemvolume" "kdeconnect.telephony.request" "kdeconnect.telephony.request_mute"];
      name = "Pixel 6";
      outgoing-capabilities = ["kdeconnect.battery" "kdeconnect.battery.request" "kdeconnect.bigscreen.stt" "kdeconnect.clipboard" "kdeconnect.clipboard.connect" "kdeconnect.connectivity_report" "kdeconnect.contacts.response_uids_timestamps" "kdeconnect.contacts.response_vcards" "kdeconnect.findmyphone.request" "kdeconnect.mousepad.echo" "kdeconnect.mousepad.keyboardstate" "kdeconnect.mousepad.request" "kdeconnect.mpris" "kdeconnect.mpris.request" "kdeconnect.notification" "kdeconnect.notification.request" "kdeconnect.photo" "kdeconnect.ping" "kdeconnect.presenter" "kdeconnect.runcommand.request" "kdeconnect.sftp" "kdeconnect.share.request" "kdeconnect.sms.attachment_file" "kdeconnect.sms.messages" "kdeconnect.systemvolume.request" "kdeconnect.telephony"];
      paired = true;
      supported-plugins = ["battery" "clipboard" "connectivity_report" "contacts" "findmyphone" "mousepad" "mpris" "notification" "photo" "ping" "presenter" "runcommand" "sftp" "share" "sms" "systemvolume" "telephony"];
      type = "phone";
    };
    "org/gnome/shell/extensions/gsconnect/device/c9b46110e36de16a/plugin/battery" = {
      custom-battery-notification = true;
      custom-battery-notification-value = lib.hm.gvariant.mkUint32 85;
      full-battery-notification = true;
    };
    "org/gnome/shell/extensions/gsconnect/device/c9b46110e36de16a/plugin/clipboard" = {
      receive-content = true;
      send-content = true;
    };
    "org/gnome/shell/extensions/gsconnect/device/c9b46110e36de16a/plugin/notification" = {
      applications = ''
        {"Power":{"iconName":"org.gnome.Settings-power-symbolic","enabled":true},"Lutris":{"iconName":"lutris","enabled":true},"Software":{"iconName":"org.gnome.Software","enabled":true},"Clocks":{"iconName":"org.gnome.clocks","enabled":true},"Color":{"iconName":"org.gnome.Settings-color-symbolic","enabled":true},"Archive Manager":{"iconName":"org.gnome.FileRoller","enabled":true},"PulseEffects":{"iconName":"pulseeffects","enabled":true},"Printers":{"iconName":"org.gnome.Settings-printers-symbolic","enabled":true},"Telegram Desktop":{"iconName":"telegram","enabled":true},"Files":{"iconName":"org.gnome.Nautilus","enabled":true},"Disk Usage Analyzer":{"iconName":"org.gnome.baobab","enabled":true},"Disks":{"iconName":"org.gnome.DiskUtility","enabled":true},"Evolution Alarm Notify":{"iconName":"appointment-soon","enabled":true},"Date & Time":{"iconName":"org.gnome.Settings-time-symbolic","enabled":true}}
      '';
    };
    "org/gnome/shell/extensions/gsconnect/device/c9b46110e36de16a/plugin/runcommand" = {
      command-list = "{'86550fa8-da62-4a0a-b9d2-e4229821be8a': <{'name': 'Lock screen', 'command': 'systemctl lock'}>, '1961e22c-d0a4-4784-a14c-cf5409ae0ec7': <{'name': 'Unlock screen', 'command': 'loginctl unlock-session 1'}>, '8f508b73-be83-444f-bfb6-c408636d48e4': <{'name': 'Shutdown', 'command': 'systemctl poweroff'}>}";
    };
  };

  # We want Kodi on this machine
  programs.kodi = {
    enable = true;
  };
}
