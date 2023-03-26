{
  lib,
  pkgs,
  ...
}: {
  # My git repos
  imports = [
    ./git-sync.nix
    ./spicetify.nix
  ];

  # These need to be configured individually
  dconf.settings = {
    "org/gnome/shell/extensions/gsconnect" = {
      devices = ["a81d0073-3760-45a8-93af-7933d83f748c" "c9b46110e36de16a"];
      enabled = true;
      id = "a4f40bf4-47db-47b6-9fda-a4c71d9f2893";
      name = "Slim Nixed";
    };
    "org/gnome/shell/extensions/gsconnect/device/a81d0073-3760-45a8-93af-7933d83f748c" = {
      certificate-pem = "-----BEGIN CERTIFICATE-----\nMIIFpTCCA42gAwIBAgIUW9A2brBFK6VNrfoUayvwkEzMAXwwDQYJKoZIhvcNAQEL\nBQAwYjEdMBsGA1UECgwUYW5keWhvbG1lcy5naXRodWIuaW8xEjAQBgNVBAsMCUdT\nQ29ubmVjdDEtMCsGA1UEAwwkYTgxZDAwNzMtMzc2MC00NWE4LTkzYWYtNzkzM2Q4\nM2Y3NDhjMB4XDTIzMDMxODE2MzY1M1oXDTMzMDMxNTE2MzY1M1owYjEdMBsGA1UE\nCgwUYW5keWhvbG1lcy5naXRodWIuaW8xEjAQBgNVBAsMCUdTQ29ubmVjdDEtMCsG\nA1UEAwwkYTgxZDAwNzMtMzc2MC00NWE4LTkzYWYtNzkzM2Q4M2Y3NDhjMIICIjAN\nBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEArA70VJAERdMtFUK/cNB4PXvA3Z7Q\n696rTL6wjNiYjBXDl7xxia0X7gbvzAPrmFPBJPmpywnk3i512ZUQvjjpuEo1FL7H\n6wJQwnzuCGrnRTRvKlzMx0Glfbe+lZrJpChO3IN7PXv3qeXW8a5wrMqWN3ZSyJ4q\nAvKnmEv1PG27moSvLwvLQyUhzrcKu9RoTTtLy6gyXq8qduvwkN8v5hTdD06oiHOU\nx1zUIo/QpiDU966AV0dBC5M2Wc3zIomJb4gm5H37yWOYevhVlXxQcReuijOBcsx2\nI6pvTq/BhSlu2CamGiMYEHNfsrnYANmeH1n4L5jo3ogyeP2MnWQuGPT5jdPRiDKZ\naB1BOiy1yC+0MIr3MiX1RZ2xCf636pnAeAjyxodJj8wL42gHeVPq4pZoChSz6SG8\npzlq/LLSF4G2AB3xp/c0sR2951I2p5R1zCFscsUWRxvFCArSRungmOsnENjFj4zO\nHWqJxuzeKMbCPC4LC41Nvirr+/H5DaXBjr0/+UQ11uXJ6j8arWO6G8APfRs4oqz5\nBmG8XPGsgXe+C0jb9ttKehy9JdmheR29r6EJfaFGgu7cBv7Eokkt71kTfw3P/GJ4\nmQsAiJidfwL45u420AMPib1KLzpEjfoS/zSc0HHrvi1s5vjsvsxWXQ6qPwO5we4I\nbxd0mYpETrv8u58CAwEAAaNTMFEwHQYDVR0OBBYEFIk8Lrc35ZpiJ4VFbZbU1veQ\nE37oMB8GA1UdIwQYMBaAFIk8Lrc35ZpiJ4VFbZbU1veQE37oMA8GA1UdEwEB/wQF\nMAMBAf8wDQYJKoZIhvcNAQELBQADggIBADPbvptPTQ9hPSiVEXBML8IaJH/i5Wbq\n/XKcvFAEmWKKRWwxGNNT+yQ8yUfds57JhPL1t6q/ERUyRreQihdFrYDrSPqr+qcZ\nhBjEko8Sw9B1hQmMzU4r9S+iw+mLiFHcu3V8DHVz2xkID1gZZxOfIBpThVlWo2yL\nMJFwBNvLf5A7mzr5OEVAmH4oGv3nDATvTQ0vX4NebS1GFntq4VBk/KPtQnA8nq2l\nY1Vr4JK/vI3AkFaNeEbOmPt7phBpVdc90tNqXSRCD6R5JN/YrqJTeZrdCVofKSBn\nB0rPjMhC4F+ap2U0KvYYB4J9nYccd0Wc7Pkz5nqNtop0xucWDRHj5F+xManqqeya\nrElLaM+bsj3UQkel81SOyxPxOqQ2qERSX4iAy7nzgo2VUNQdVKNOQVibcUiEaOu/\nYiYSSMM1JZBvidt9juQDUWVUTUa8aJw4KUzpm7UnplfD+/NC9EW1USdXaDFDN7HB\ntr6Q81rhz9VGoZWDm5Apxn7G5FcPtB0G1h2U5I/ly84fi729A996r8E8m5bLCfJc\nQrdWysS8x5noJxGF8nv9NjTSB/MUpfIsr7fFNTEMuZWwGt7kBxB0IKG/uqPclE88\nT8uSJAGliuDy6F1VJiTbShOm7mojGpRLUlg+UWq/XGIntuQ4RhFJY/MfaoTbsbH4\nuw+3QtEF2+7r\n-----END CERTIFICATE-----\n";
      incoming-capabilities = ["kdeconnect.battery" "kdeconnect.battery.request" "kdeconnect.clipboard" "kdeconnect.clipboard.connect" "kdeconnect.connectivity_report" "kdeconnect.contacts.response_uids_timestamps" "kdeconnect.contacts.response_vcards" "kdeconnect.findmyphone.request" "kdeconnect.mousepad.echo" "kdeconnect.mousepad.keyboardstate" "kdeconnect.mousepad.request" "kdeconnect.mpris" "kdeconnect.mpris.request" "kdeconnect.notification" "kdeconnect.notification.request" "kdeconnect.photo" "kdeconnect.photo.request" "kdeconnect.ping" "kdeconnect.presenter" "kdeconnect.runcommand" "kdeconnect.runcommand.request" "kdeconnect.sftp" "kdeconnect.share.request" "kdeconnect.sms.messages" "kdeconnect.systemvolume.request" "kdeconnect.telephony"];
      name = "TV NixOS";
      outgoing-capabilities = ["kdeconnect.battery" "kdeconnect.battery.request" "kdeconnect.clipboard" "kdeconnect.clipboard.connect" "kdeconnect.connectivity_report.request" "kdeconnect.contacts.request_all_uids_timestamps" "kdeconnect.contacts.request_vcards_by_uid" "kdeconnect.findmyphone.request" "kdeconnect.mousepad.echo" "kdeconnect.mousepad.keyboardstate" "kdeconnect.mousepad.request" "kdeconnect.mpris" "kdeconnect.mpris.request" "kdeconnect.notification" "kdeconnect.notification.action" "kdeconnect.notification.reply" "kdeconnect.notification.request" "kdeconnect.photo" "kdeconnect.photo.request" "kdeconnect.ping" "kdeconnect.runcommand" "kdeconnect.runcommand.request" "kdeconnect.sftp.request" "kdeconnect.share.request" "kdeconnect.sms.request" "kdeconnect.sms.request_conversation" "kdeconnect.sms.request_conversations" "kdeconnect.systemvolume" "kdeconnect.telephony.request" "kdeconnect.telephony.request_mute"];
      paired = true;
      supported-plugins = ["battery" "clipboard" "findmyphone" "mousepad" "mpris" "notification" "photo" "ping" "runcommand" "share"];
      type = "laptop";
    };
    "org/gnome/shell/extensions/gsconnect/device/a81d0073-3760-45a8-93af-7933d83f748c/plugin/notification" = {
      applications = ''
        {"Power":{"iconName":"org.gnome.Settings-power-symbolic","enabled":true},"Lutris":{"iconName":"lutris","enabled":true},"Software":{"iconName":"org.gnome.Software","enabled":true},"Clocks":{"iconName":"org.gnome.clocks","enabled":true},"Color":{"iconName":"org.gnome.Settings-color-symbolic","enabled":true},"Archive Manager":{"iconName":"org.gnome.FileRoller","enabled":true},"PulseEffects":{"iconName":"pulseeffects","enabled":true},"Printers":{"iconName":"org.gnome.Settings-printers-symbolic","enabled":true},"Telegram Desktop":{"iconName":"telegram","enabled":true},"Files":{"iconName":"org.gnome.Nautilus","enabled":true},"Disk Usage Analyzer":{"iconName":"org.gnome.baobab","enabled":true},"Disks":{"iconName":"org.gnome.DiskUtility","enabled":true},"Evolution Alarm Notify":{"iconName":"appointment-soon","enabled":true},"Date & Time":{"iconName":"org.gnome.Settings-time-symbolic","enabled":true}}
      '';
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
}
