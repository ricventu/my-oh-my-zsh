# ricventu.zsh-theme
# Professional two-line prompt, AI-tool friendly (ASCII-only, no precmd hooks)

### Git Status Symbols
# | Symbol | Meaning | Color |
# |--------|---------|-------|
# | `*` | Dirty (after branch name) | Orange |
# | `+` | Added files | Green |
# | `!` | Modified files | Yellow |
# | `-` | Deleted files | Red |
# | `?` | Untracked files | Cyan |
# | `^` | Ahead of remote | Green |
# | `v` | Behind remote | Red |
# | `Y` | Diverged | Magenta |
# | `$` | Stashed changes | Blue |


_rv_git_prompt() {
  local info="$(git_prompt_info)"
  [[ -z "$info" ]] && return
  echo "${info}$(git_prompt_status)${FG[075]})"
}

# OMZ git_prompt_* is async; auto-registration scans PS1 for literal
# $(git_prompt_info). Our helper hides that, so register handlers manually.
(( $+functions[_omz_register_handler] )) && {
  _omz_register_handler _omz_git_prompt_info
  _omz_register_handler _omz_git_prompt_status
}

PS1='${FG[032]}%~$(_rv_git_prompt)%{$reset_color%}
${FG[105]}%(!.#.>)%{$reset_color%} '
PS2='%{$fg[red]%}\ %{$reset_color%}'

# git branch display
ZSH_THEME_GIT_PROMPT_PREFIX=" ${FG[075]}(${FG[078]}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" ${FG[214]}*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# git detailed status
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}!"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}-"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}#"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}?"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[green]%}^"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[red]%}v"
ZSH_THEME_GIT_PROMPT_DIVERGED="%{$fg[magenta]%}Y"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%}$"
