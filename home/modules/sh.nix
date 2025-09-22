{
  config,
  lib,
  pkgs,
  ...
}: let
  myAliases = {
    mkdir = "mkdir -p";
    ssh-allow = "sudo systemctl start sshd";
    ssh-deny = "sudo systemctl stop sshd";
    l = "eza --icons";
    ls = "eza --icons";
    ping = "gping";
    lst = "ls -T -L=2";
    fl = "y";
    lf = "y";
    nivm = "nvim";
    open = "xdg-open";
    ll = "eza -lha --icons=auto --sort=name --group-directories-first";
    c = "z";
    lg = "ls | grep";
    ".." = "cd ..";
    "..." = "cd ../..";
    cd = "z";
    ci = "zi";
    b = "cd ..";
    gg = "lazygit";
    cadd = "zoxide add";
    cdadd = "zoxide add";
    t = "task";
    tt = "taskwarrior-tui";
    td = "task done"; #task wird als done markiert
    ta = "task add";
    tm = "task modify";
    tc = "task context";
    rm = "trash-put";
  };
in {
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.ssh.extraConfig = ''
    ServerAliveInterval 30
    ServerAliveCountMax 3
  '';
  # programs.stylix.targets.kitty.enable = true;
  programs.kitty = {
    enable = true;
    # themeFile = "Rosé Pine";
    themeFile = "Catppuccin-Mocha";
    settings = {
      enable_audio_bell = false;

      sync_to_monitor = "yes";
      font_family = lib.mkForce "JetBrainsMono Nerd Font"; # force our font
      # background_opacity = "0.9";
      background_blur = "12";
      cursor_trail = "3";
      cursor_trail_start_threshold = "2";
      confirm_os_window_close = "-1";
      cursor_trail_decay = "0.1 0.4";
      window_padding_width = "8";
      # window_padding_width = 8;
    };
    font = {
      name = lib.mkForce "JetBrainsMono Nerd Font";
      size = 12;
    };
    extraConfig = "padding 8";
    shellIntegration.enableZshIntegration = true;
  };

  programs.fzf.enable = true;

  programs.fish.enable = false;

  programs.zsh.initExtra = ''
               source ~/.p10k.zsh
             function fzf() {
               local selected_file
               selected_file=$(command fzf) || return
               xdg-open "$selected_file"
             }
               function y() {
               	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
               	yazi "$@" --cwd-file="$tmp"
               	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
               		builtin cd -- "$cwd"
               	fi
               	rm -f -- "$tmp"
               }

       # Show a chemistry fun fact at shell startup
      # misfortune science | cowsay -f tux | lolcat
    alias update="sudo nixos-rebuild switch --flake ~/nixos#$(hostname)"
  '';
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      save = 20000;
      size = 20000;
      share = true;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };

  home.file.".p10k.zsh".source = ./p10k-config/p10k.zsh;
  programs.zsh = {
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = "p10k.zsh";
      }
    ];

    oh-my-zsh = {
      enable = true;
    };
    shellAliases = myAliases;
  };

  home.packages = with pkgs; [
    # Fun / misc
    haskellPackages.misfortune # random fortune messages (misfortune quotes)
    cowsay # display messages as ASCII cows
    lolcat # rainbow-colorize terminal output
    neofetch # system info in terminal (with ASCII logo)
    # Task / time management
    taskwarrior3 # CLI task manager
    timewarrior # CLI time tracking
    taskwarrior-tui # ncurses interface for taskwarrior
    # Search / navigation
    fzf # fuzzy finder (search lists interactively)
    jq # process/manipulate JSON in terminal
    eza # modern replacement for ls
    ripgrep # fast grep-like search tool
    zoxide # smarter cd with directory jumping
    lf # terminal file manager
    gping # ping with graph output
    # System / utilities
    btop # resource monitor (CPU, RAM, GPU, etc.)
    wget # download files from web
    xclip # clipboard CLI for X11/Wayland
    kitty # GPU-accelerated terminal
    bat # modern replacement for cat (with syntax highlighting)
    trash-cli # move files to trash instead of rm
    yazi # fast TUI file manager (like lf but modern)
    # Build tools / dev utils
    gnumake # build automation (needed by many projects)
    cmake # cross-platform build system
    gcc # C/C++ compiler
  ];
}
