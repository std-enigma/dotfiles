hl.config({
	dwindle = {
		preserve_split = true,
	},
	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},
	misc = {
		enable_swallow = true,
		swallow_regex = "(kitty|ghostty|[Kk]onsole|Alacritty|gnome-terminal|xfce[0-9]?-terminal)",
	},
	xwayland = {
		force_zero_scaling = true,
	},
})
