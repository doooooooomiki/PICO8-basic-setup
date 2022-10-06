Spaceship = {}
Spaceship.__index = Spaceship

-- new
function Spaceship:new(o)
  return setmetatable(o, self)
end

-- position
Spaceship.x = 60
Spaceship.y = 112

-- movement
Spaceship.control = false
Spaceship.vx = 0
Spaceship.vy = 0
Spaceship.accel = 0.25
Spaceship.friction = 0.1
Spaceship.max_speed = 2.5

function Spaceship:handle_movement()
  local vx = self.vx
  local accel = self.accel
  local friction = self.friction
  local max_speed = self.max_speed
    
  if btn(0) then
    vx = vx > 0 and -accel or vx - accel
  elseif btn(1) then
    vx = vx < 0 and accel or vx + accel
  elseif vx != 0 then
    vx += min(abs(vx), friction) * -sgn(vx)
  end

  self.vx = mid(-max_speed, vx, max_speed)
end

-- health
Spaceship.max_health = 3

-- update
function Spaceship:update()
  self:handle_movement()
  if(self.x < -8) then
    self.x = 127
  elseif (self.x > 128) then
    self.x = -7
  else 
    self.x = self.x + self.vx
  end
end

-- draw
function Spaceship:draw()
  spr(001, self.x, self.y)
end



function _init()
  Screen = {}
  Screen.minX = 0
  Screen.maxX = 128
  Screen.background = 1

  Player = Spaceship:new({})

  cls(Screen.background)
end

function _update()
  cls(Screen.background)
  Player:update()
end

function _draw()
  Player:draw()
  spr(2, 60, 60)
end
