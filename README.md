# Easy VSel
Easy Visual Selection

## what it do
show count overlay after pressing e/b in visual mode, after that you can press digit key to repeat the motion.

ve3 behave the same as ve3e, you dont need to specify the motion after count.

info: v3e behave the same as the default.

https://github.com/user-attachments/assets/aeeae167-1916-4aae-aa56-efbc2c91a77b 

## install
lazy.nvim
```lua
return {
    "sevaaadev/easy-vsel.nvim"
    opts = {}
}
```

## limitation
the last command only get removed after changing mode, therefore after pressing 'vel', all of the count (1..9) will still repeat 'e' motion

## inspiration
[Meow-mode](https://github.com/meow-edit/meow) (best selection-first editing): this plugin is basically a copy of its repeat selection feature


