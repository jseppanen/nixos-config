#-------------------------------------------------------------------------------
# Conda
#-------------------------------------------------------------------------------
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# eval /opt/mambaforge/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

#-------------------------------------------------------------------------------
# SSH Agent
#-------------------------------------------------------------------------------
function __ssh_agent_is_started -d "check if ssh agent is already started"
	if begin; test -f $SSH_ENV; and test -z "$SSH_AGENT_PID"; end
		source $SSH_ENV > /dev/null
	end

	if test -z "$SSH_AGENT_PID"
		return 1
	end

	ssh-add -l > /dev/null 2>&1
	if test $status -eq 2
		return 1
	end
end

function __ssh_agent_start -d "start a new ssh agent"
  ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
  chmod 600 $SSH_ENV
  source $SSH_ENV > /dev/null
  ssh-add
end

if not test -d $HOME/.ssh
    mkdir -p $HOME/.ssh
    chmod 0700 $HOME/.ssh
end

if test -d $HOME/.gnupg
    chmod 0700 $HOME/.gnupg
end

if test -z "$SSH_ENV"
    set -xg SSH_ENV $HOME/.ssh/environment
end

if not __ssh_agent_is_started
    __ssh_agent_start
end

#-------------------------------------------------------------------------------
# Kitty Shell Integration
#-------------------------------------------------------------------------------
if set -q KITTY_INSTALLATION_DIR
    set --global KITTY_SHELL_INTEGRATION enabled
    source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
    set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
end

#-------------------------------------------------------------------------------
# Vim
#-------------------------------------------------------------------------------
# We should move this somewhere else but it works for now
mkdir -p $HOME/.vim/{backup,swap,undo}

#-------------------------------------------------------------------------------
# Prompt
#-------------------------------------------------------------------------------
# disable greeting message
set -U fish_greeting

# set prompt (overriding any conda prompts)
# starship init fish | source

#-------------------------------------------------------------------------------
# Theme
#-------------------------------------------------------------------------------
set -U fish_color_autosuggestion 585858
set -U fish_color_cancel \x2dr
set -U fish_color_command a1b56c
set -U fish_color_comment f7ca88
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_end ba8baf
set -U fish_color_error ab4642
set -U fish_color_escape 86c1b9
set -U fish_color_history_current \x2d\x2dbold
set -U fish_color_host normal
set -U fish_color_host_remote yellow
set -U fish_color_match 7cafc2
set -U fish_color_normal normal
set -U fish_color_operator 7cafc2
set -U fish_color_param d8d8d8
set -U fish_color_quote f7ca88
set -U fish_color_redirection d8d8d8
set -U fish_color_search_match bryellow\x1e\x2d\x2dbackground\x3dbrblack
set -U fish_color_selection white\x1e\x2d\x2dbold\x1e\x2d\x2dbackground\x3dbrblack
set -U fish_color_status red
set -U fish_color_user brgreen
set -U fish_color_valid_path \x2d\x2dunderline
set -U fish_pager_color_completion normal
set -U fish_pager_color_description B3A06D\x1eyellow
set -U fish_pager_color_prefix normal\x1e\x2d\x2dbold\x1e\x2d\x2dunderline
set -U fish_pager_color_progress brwhite\x1e\x2d\x2dbackground\x3dcyan

#-------------------------------------------------------------------------------
# Vars
#-------------------------------------------------------------------------------
# add ~/bin to path
contains $HOME/bin $fish_user_paths; or set -Ua fish_user_paths $HOME/bin

# Exported variables
if isatty
    set -x GPG_TTY (tty)
end

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------
# Shortcut to setup a nix-shell with fish. This lets you do something like
# `fnix -p go` to get an environment with Go but use the fish shell along
# with it.
alias fnix "nix-shell --run fish"
