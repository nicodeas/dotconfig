-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.colors = require("themes.kanagawa")

-- still figuring out how to set neovim color scheme to match this transparency
-- config.window_background_opacity = 0.8

-- windows
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE" -- this cant be none as it won't allow resizing

--I dont see myself using tabs when i have tmux for this
config.enable_tab_bar = false

config.window_background_opacity = 0.97

-- and finally, return the configuration to wezterm
return config
