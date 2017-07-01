#!/bin/zsh

typeset -AHg SOLARIZED FG BG

SOLARIZED=(
    000 "base02"  008 "base03"
    002 "green"   010 "base01"
    001 "red"     009 "orange"
    003 "yellow"  011 "base00"
    004 "blue"    012 "base0"
    005 "magenta" 013 "violet"
    006 "cyan"    014 "base1"
    007 "base2"   015 "base3"
)

for color in {000..255}; do
    FG[$color]="%{[38;5;${color}m%}"
    BG[$color]="%{[48;5;${color}m%}"
done


ZSH_SPECTRUM_TEXT=${ZSH_SPECTRUM_TEXT:-Arma virumque cano Troiae qui primus ab oris}

# Show 16 colors with solarized names
function spectrum_solarized() {
  for code in ${(k)SOLARIZED}; do
    print -P -- "$SOLARIZED[$code]: %{$BG[$code]%}%{$FG[015]%}$ZSH_SPECTRUM_TEXT%{$reset_color%}"
  done
}

alias solarized='spectrum_solarized | sort'
