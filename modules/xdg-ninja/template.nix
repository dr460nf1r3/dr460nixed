system:
let
  # copy paste done right
  XDG_CACHE_HOME = "\$HOME/.cache";
  XDG_CONFIG_HOME = "\$HOME/.config";
  XDG_DATA_HOME = "\$HOME/.local/share";
  XDG_RUNTIME_DIR = "/run/user/\${UID}";
in
{
  glEnv = rec {
    PATH = [ "\${XDG_BIN_HOME}" ];
    XDG_BIN_HOME = "\${HOME}/.local/bin";
    XDG_CACHE_HOME = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_DATA_HOME = "\${HOME}/.local/share";
    XDG_STATE_HOME = "\${HOME}/.local/state";
  };
  sysEnv = {
    ANDROID_HOME = "${XDG_DATA_HOME}/android";
    CUDA_CACHE_PATH = "${XDG_CACHE_HOME}/nv";
    ERRFILE = "${XDG_CACHE_HOME}/X11/xsession-errors";
    GNUPGHOME = "${XDG_DATA_HOME}/gnupg";
    GRADLE_USER_HOME = "${XDG_DATA_HOME}/gradle";
    IPYTHONDIR = "${XDG_CONFIG_HOME}/ipython";
    JUPYTER_CONFIG_DIR = "${XDG_CONFIG_HOME}/jupyter";
    LESSHISTFILE = "${XDG_DATA_HOME}/less/history";
    NPM_CONFIG_CACHE = "${XDG_CACHE_HOME}/npm";
    NPM_CONFIG_TMP = "${XDG_RUNTIME_DIR}/npm";
    NPM_CONFIG_USERCONFIG = "${XDG_CONFIG_HOME}/npm/config";
    PYTHONSTARTUP =
      if system == "nixos"
      then "/etc/pythonrc"
      else "${XDG_CONFIG_HOME}/python/pythonrc";
    CARGO_HOME = "${XDG_DATA_HOME}/cargo";
    GOPATH = "${XDG_DATA_HOME}/go";
    INPUTRC = "${XDG_CONFIG_HOME}/readline/inputrc";
    NODE_REPL_HISTORY = "${XDG_DATA_HOME}/node_repl_history";
    PLATFORMIO_CORE_DIR = "${XDG_DATA_HOME}/platformio";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = [
      "\${HOME}/.steam/root/compatibilitytools.d"
    ];
    STEPPATH = "${XDG_DATA_HOME}/step";
    WAKATIME_HOME = "${XDG_DATA_HOME}/wakatime";
    WINEPREFIX = "${XDG_DATA_HOME}/wine";
    XCOMPOSECACHE = "${XDG_CACHE_HOME}/X11/xcompose";
  };

  npmrc.text = ''
    cache=''${XDG_CACHE_HOME}/npm
    init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
    prefix=''${XDG_DATA_HOME}/npm
    tmp=''${XDG_RUNTIME_DIR}/npm
  '';

  pythonrc.text = ''
    import os
    import atexit
    import readline
    history = os.path.join(os.environ['XDG_CACHE_HOME'], 'python_history')
    try:
        readline.read_history_file(history)
    except OSError:
        pass
    def write_history():
        try:
            readline.write_history_file(history)
        except OSError:
            pass
    atexit.register(write_history)
  '';
}
