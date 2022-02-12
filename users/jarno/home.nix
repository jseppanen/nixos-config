{ config, lib, pkgs, ... }: {
  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages = [
    pkgs.bat
    pkgs.conda
    pkgs.fd
    pkgs.firefox
    pkgs.fzf
    pkgs.git
    pkgs.git-crypt
    pkgs.glances
    pkgs.htop
    pkgs.jq
    pkgs.ripgrep
    pkgs.rofi
    pkgs.starship
    pkgs.tree
    pkgs.watch
    pkgs.zathura
    pkgs._1password
  ];

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "vim";
    PAGER = "less -FirSwX";
    MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
    LIBGL_ALWAYS_SOFTWARE = "1";  # virgl doesn't yet work with kitty
  };

  home.file.".inputrc".source = ./inputrc;

  # xdg.configFile."i3/config".text = builtins.readFile ./i3;
  # xdg.configFile."rofi/config.rasi".text = builtins.readFile ./rofi;

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  # enable command-not-found
  programs.nix-index =
  {
    enable = true;
    enableFishIntegration = true;
  };

  programs.gpg.enable = true;

  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = [ "ignoredups" "ignorespace" ];
    initExtra = builtins.readFile ./bashrc;

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";
      gt = "git tag";
    };
  };

  programs.direnv= {
    enable = true;

    config = {
      whitelist = {
        prefix= [
          "$HOME/code/go/src/github.com/hashicorp"
          "$HOME/code/go/src/github.com/mitchellh"
        ];

        exact = ["$HOME/.envrc"];
      };
    };
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.magit
    ];
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = lib.strings.concatStrings (lib.strings.intersperse "\n" [
      (builtins.readFile ./config.fish)
      "set -g SHELL ${pkgs.fish}/bin/fish"
    ]);

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";
      gt = "git tag";

      # Two decades of using a Mac has made this such a strong memory
      # that I'm just going to keep it consistent.
      pbcopy = "xclip";
      pbpaste = "xclip -o";
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "Jarno Seppänen";
    userEmail = "git@meit.si";
    aliases = {
      lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
      lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
      st = "status";
      undo = "reset HEAD^";
    };
    ignores = [
      ".pytest_cache"
      ".vscode"
      "__pycache__"
      "dist"
      "node_modules"
      "spark-warehouse"
    ];
    lfs.enable = true;
    delta.enable = true;
    extraConfig = {
      branch.autoSetupRebase = "always";
      color.ui = "true";
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store"; # want to make this more secure
      github.user = "jseppanen";
      # pull.rebase = "true";
      push.default = "simple";
      init.defaultBranch = "main";
    };
  };

  # programs.tmux = {
  #   enable = true;
  #   terminal = "xterm-256color";
  #   shortcut = "l";
  #   secureSocket = false;

  #   extraConfig = ''
  #     set -ga terminal-overrides ",*256col*:Tc"

  #     set -g @dracula-show-battery false
  #     set -g @dracula-show-network false
  #     set -g @dracula-show-weather false

  #     bind -n C-k send-keys "clear"\; send-keys "Enter"

  #     run-shell ${sources.tmux-pain-control}/pain_control.tmux
  #     run-shell ${sources.tmux-dracula}/dracula.tmux
  #   '';
  # };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty.conf;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      package.disabled = true;
      python.disabled = true;
    };
    enableFishIntegration = true;
  };

  # programs.i3status = {
  #   enable = true;

  #   general = {
  #     colors = true;
  #     color_good = "#8C9440";
  #     color_bad = "#A54242";
  #     color_degraded = "#DE935F";
  #   };

  #   modules = {
  #     ipv6.enable = false;
  #     "wireless _first_".enable = false;
  #     "battery all".enable = false;
  #   };
  # };

  # programs.neovim = {
  #   enable = true;
  #   package = pkgs.neovim-nightly;

  #   plugins = with pkgs; [
  #     customVim.vim-cue
  #     customVim.vim-fish
  #     customVim.vim-fugitive
  #     customVim.vim-misc
  #     customVim.vim-pgsql
  #     customVim.vim-tla
  #     customVim.vim-zig
  #     customVim.pigeon
  #     customVim.AfterColors

  #     customVim.vim-nord
  #     customVim.nvim-comment
  #     customVim.nvim-lspconfig
  #     customVim.nvim-plenary # required for telescope
  #     customVim.nvim-telescope
  #     customVim.nvim-treesitter
  #     customVim.nvim-treesitter-playground
  #     customVim.nvim-treesitter-textobjects

  #     vimPlugins.vim-airline
  #     vimPlugins.vim-airline-themes
  #     vimPlugins.vim-eunuch
  #     vimPlugins.vim-gitgutter

  #     vimPlugins.vim-markdown
  #     vimPlugins.vim-nix
  #     vimPlugins.typescript-vim
  #   ];

  #   extraConfig = (import ./vim-config.nix) { inherit sources; };
  # };

  # services.gpg-agent = {
  #   enable = true;
  #   pinentryFlavor = "tty";

  #   # cache the keys forever so we don't get asked for a password
  #   defaultCacheTtl = 31536000;
  #   maxCacheTtl = 31536000;
  # };

  xresources.extraConfig = builtins.readFile ./Xresources;

  # Make cursor not tiny on HiDPI screens
  xsession.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
  };
}
