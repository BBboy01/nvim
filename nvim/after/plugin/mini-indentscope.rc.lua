local status, mini = pcall(require, 'mini.indentscope')
if (not status) then return end

mini.setup {
  draw = {
    delay = 0,
    animation = require("mini.indentscope").gen_animation.none(),
  },
}
