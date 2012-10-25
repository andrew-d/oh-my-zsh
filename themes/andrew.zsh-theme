# Awesome prompt.

# This function parses the output of "git status" to determine some stuff.
function get_git_status() {
  local st="$(git status 2>/dev/null)"
  if [[ -n "$st" ]]; then
      local -a arr
      arr=(${(f)st})

      if [[ $arr[2] =~ 'Your branch is' ]]; then
          if [[ $arr[2] =~ 'ahead' ]]; then
              __GIT_STATUS_CHARS='↑'
          elif [[ $arr[2] =~ 'diverged' ]]; then
              __GIT_STATUS_CHARS='↕'
          else
              __GIT_STATUS_CHARS='↓'
          fi
      fi

      if [[ ! $st =~ 'nothing to commit' ]]; then
          __GIT_STATUS_CHARS=$__GIT_STATUS_CHARS"⚡"
      fi
      echo $__GIT_STATUS_CHARS
  fi
}

# This is the old parse function that just outputs a star on dirty.
function parse_git_dirty() {
  [[ -z $(git status 2> /dev/null | tail -n1 | grep 'nothing to commit[ ,(]*working directory clean.*') ]] && echo "*"
}

function parse_git_branch() {
  # git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(get_git_status)/"
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

