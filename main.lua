function _init()
  Screen = {}
  Screen.minX = 0
  Screen.maxX = 128
  Screen.background = 1

  Ship = {}
  Ship.x = 60
  Ship.y = 112
  Ship.speed = 3

  cls(Screen.background)
end

function _update()
  cls(Screen.background)

  if btn(0) then
    Ship.x = Ship.x - Ship.speed
  end

  if btn(1) then
    Ship.x = Ship.x + Ship.speed
  end

  if Ship.x >= Screen.maxX - 8 then
    Ship.x = 120
  end

  if Ship.x <= Screen.minX then
    Ship.x = 0
  end

end

function _draw()
  spr(001, Ship.x, Ship.y)
end
