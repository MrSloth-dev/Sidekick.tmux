default_sidekick_keybind="F3"

set_binding() { # Function to be called in main
	local key_bindings=$(get_tmux_option "@sidekick_keybind" "$default_sidekick_keybind")
	local key
	for key in $key_bindings; do
		echo "Do Stuff with $key"
	done
}
