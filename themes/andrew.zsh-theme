# Awesome prompt.
function parse_git_dirty() {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

function parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

function git_info() {
    [[ -n $(git branch 2> /dev/null) ]] && echo "on %{$PURPLE%}$(parse_git_branch)%{$RESET%}"
}

function virtualenv_info() {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function battery_charge() {
    echo `~/.bin/batcharge.py` 2>/dev/null
}

# RPROMPT='$(battery_charge)'

PROMPT='%{$BOLD%}%{$MAGENTA%}%n%{$RESET%} at %{$ORANGE%}%m%{$RESET%} in %{$GREEN%}%~%{$RESET%} $(git_info)
%{$RESET%}$ '

