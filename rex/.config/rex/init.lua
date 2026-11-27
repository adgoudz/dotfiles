--
-- Key Bindings
--

local focus_keys = { h = "left", j = "down", k = "up", l = "right" }
for key, direction in pairs(focus_keys) do
  rex.bind("cmd+" .. key, "pane.focus", { direction = direction })
end

rex.bind("cmd+n", "client.tab.next")
rex.bind("cmd+p", "client.tab.previous")

rex.bind("ctrl+space>t", "client.tab.rename")
rex.bind("ctrl+space>z", "pane.zoom")

--
-- Resize mode
--

rex.mode("resize", { exclusive = true })
rex.bind("cmd+r", "client.mode.enter", { name = "resize" })

rex.bind("resize/left", "pane.resize", { direction = "left" })
rex.bind("resize/right", "pane.resize", { direction = "right" })
rex.bind("resize/up", "pane.resize", { direction = "up" })
rex.bind("resize/down", "pane.resize", { direction = "down" })

rex.bind("resize/shift+left", "pane.resize", { direction = "left", amount = 15 })
rex.bind("resize/shift+right", "pane.resize", { direction = "right", amount = 15 })

rex.bind("resize/=", "pane.balance")
rex.bind("resize/enter", "client.mode.exit")

