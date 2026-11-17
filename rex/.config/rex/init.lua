-- Rex configuration, migrated from WezTerm (~/.config/wezterm/wezterm.lua).
-- Herdr, Ghostty and iTerm2 contributed no bindings.

-- WezTerm leader ctrl+a: pass ctrl+a through to programs on ctrl+a ctrl+a
rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })

-- Splits (wezterm.lua:156-157)
rex.bind("ctrl+a>-", "pane.split", { direction = "down" })
rex.bind("ctrl+a>shift+\\", "pane.split", { direction = "right" })

-- Pane navigation (wezterm.lua:160-163)
rex.bind("ctrl+a>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+a>l", "pane.focus", { direction = "right" })
rex.bind("ctrl+a>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+a>j", "pane.focus", { direction = "down" })

-- Pane resize (wezterm.lua:166-169)
rex.bind("ctrl+a>left", "pane.resize", { direction = "left", amount = 5 })
rex.bind("ctrl+a>right", "pane.resize", { direction = "right", amount = 5 })
rex.bind("ctrl+a>up", "pane.resize", { direction = "up", amount = 5 })
rex.bind("ctrl+a>down", "pane.resize", { direction = "down", amount = 5 })

-- Close pane (wezterm.lua:172)
rex.bind("ctrl+a>x", "pane.close")

-- Tabs (wezterm.lua:175, 178-179)
rex.bind("ctrl+a>c", "client.tab.new")
rex.bind("ctrl+a>n", "client.tab.next")
rex.bind("ctrl+a>p", "client.tab.previous")

-- Search (wezterm.lua:182)
rex.bind("ctrl+a>f", "client.find.open")

-- Go to tab 1-9 (wezterm.lua:186-192)
for i = 1, 9 do
  rex.bind("ctrl+a>" .. i, "client.tab.goto", { index = i })
end
