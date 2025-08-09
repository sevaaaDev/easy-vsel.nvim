# Easy VSel
Easy Visual Selection

## features
### show overlay for count motion

https://github.com/user-attachments/assets/aeeae167-1916-4aae-aa56-efbc2c91a77b

### pressing count after command will repeat the command
ve3 will behave the same as ve3e. saves 1 keystroke

info: v3e behave the same as it was

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


