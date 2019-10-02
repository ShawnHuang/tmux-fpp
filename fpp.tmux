#!/usr/bin/env zsh

get_tmux_option() {
  local option=$1
  local default_value=$2
  local option_value=$(tmux show-option -gqv "$option")
  if [ -z $option_value ]; then
    echo $default_value
  else
    echo $option_value
  fi
}

readonly key="$(get_tmux_option "@fpp-key" "f")"

function precmd() {
  LAST="`cat /tmp/x`"; exec >/dev/tty; exec > >(tee /tmp/x)
}
add-zsh-hook precmd precmd

tmux bind-key "$key" capture-pane -J \\\; \
    save-buffer "${TMPDIR:-/tmp}/tmux-buffer" \\\; \
    delete-buffer \\\; \
    new-window -n fpp -c "#{pane_current_path}" "sh -c 'echo $LAST | fpp -c \"tmux send-keys\" ; rm \"${TMPDIR:-/tmp}/tmux-buffer\"'"
