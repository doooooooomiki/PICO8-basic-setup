Spaceship = {}
Spaceship.__index = Spaceship

-- bullet pool
Spaceship.bullets = {}

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

-- health
Spaceship.max_health = 3

-- new Spaceship
function Spaceship:new(o)
  return setmetatable(o, self)
end

-- init Spaceship
function Spaceship:init()
  local player = Spaceship:new({})

  for i = 1, 8 do
    add(player.bullets, Bullet:new(0, 0))
  end

  return player
end

function Spaceship.fire_sfx()
  sfx(00)
end

function Spaceship:handle_input_left_right()
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

function Spaceship:prime_non_active_bullet()
  for bullet in all(self.bullets) do
    if not bullet.active then bullet:init(self) break end
  end
end

function Spaceship:handle_input_x()
  if btnp(5) then self:prime_non_active_bullet() end
end

function Spaceship:check_bounds()
  if(self.x < -8) then
    self.x = 127
  elseif (self.x > 128) then
    self.x = -7
  else 
    self.x = self.x + self.vx
  end
end

function Spaceship:update_bullets()
  for bullet in all(self.bullets) do
    if bullet.active then bullet:update() end
  end
end

-- update
function Spaceship:update()
  self:handle_input_left_right()
  self:check_bounds()
  self:handle_input_x()
  self:update_bullets()
end

function Spaceship:draw_bullets()
  for bullet in all(self.bullets) do
    if bullet.active then bullet:draw() end
  end
end

-- draw
function Spaceship:draw()
  spr(001, self.x, self.y)
  self:draw_bullets()
end


Bullet = {}
Bullet.__index = Bullet

-- speed
Bullet.vy = 0
Bullet.max_speed = 6
Bullet.accel = 0.4

-- new
function Bullet:new() 
  return setmetatable({active = false}, self)
end

-- init
function Bullet:init(entity)
  self.x = entity.x
  self.y = entity.y
  self.active = true
  entity.fire_sfx()
end

-- update
function Bullet:update()
  local vy = self.vy
  local accel = self.accel
  local max_speed = self.max_speed
  vy = vy - accel
  self.vy = max(-max_speed, vy)
  self.y = self.y + self.vy
  if self.y < 0 then self.active = false end
end

-- draw
function Bullet:draw()
  spr(002, self.x, self.y)
end


function _init()
  Screen = {}
  Screen.minX = 0
  Screen.maxX = 128
  Screen.background = 1
  cls(Screen.background)

  Player = Spaceship:init()
end

function _update()
  cls(Screen.background)
  Player:update()
end

function _draw()
  Player:draw()
end
