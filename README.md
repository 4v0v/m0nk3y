# lua_monkeypatch


## What is it ?
Inspired by https://github.com/bartbes/Meta

Add syntax sugar to lua:

  - ++
  - +=
  - -=
  - *=
  - /=
  - ^=
  - %=
  - ..=
  - &&
  - ||
  - !=
  - !
  - fn()

## How ?
https://pgl.yoyo.org/luai/i/require

https://pgl.yoyo.org/luai/i/package.loaders

Everytime 'require()' is called, modify some tokens with others

## Warning
Currently only work with the Love2d framework, you need to replace the ''love.filesystem.read(name)'' function with your own to make it work with vanilla lua.


## Exemple
main.lua
```lua
  require('monkeypatch')
  require('script')
```

script.lua
```lua
  local var1 = 10
  var1++
  
  local var2 = 100
  var2 *= var1
  var2 -= 5
  
  local my_function = fn(a, b)
    if !false && var1 != var2 then 
      print(var1, var2)
    end
    print(a, b)
  end
  
  my_function('hello', 'sailor')
  
```
