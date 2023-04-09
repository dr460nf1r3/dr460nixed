{ pkgs, ... }: {
  # Font configuration
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      fira
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
        ];
      })
      noto-fonts
      noto-fonts-cjk
    ];
    # My beloved Fira Sans & JetBrains Mono
    fontconfig = {
      cache32Bit = true;
      defaultFonts = {
        monospace = [ "JetBrains Mono Nerd Font" ];
        sansSerif = [ "Fira" ];
        serif = [ "Fira" ];
      };
    };
  };
}
