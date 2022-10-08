Spaceship = {
  -- bullet pool
  bullets = {},

  -- position
  x = 60,
  y = 112,

  -- movement
  control = false,
  vx = 0,
  vy = 0,
  accel = 1.4,
  friction = 0.8,
  max_speed = 4,

  -- health
  max_health = 3,

  -- sprite
  dir = {
    left = 001,
    ahead = 002,
    right = 003,
  },

  sprite = 002
}

Spaceship.__index = Spaceship

-- new Spaceship
function Spaceship:new(o)
  return setmetatable(o, self)
end

-- init Spaceship
function Spaceship:init()
  local player = Spaceship:new({})

  for i = 1, 10 do
    add(player.bullets, Bullet:new())
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
    self.sprite = self.dir.left
    vx = vx > 0 and -accel or vx - accel
  elseif btn(1) then
    self.sprite = self.dir.right
    vx = vx < 0 and accel or vx + accel
  elseif vx != 0 then
    self.sprite = self.dir.ahead
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
  spr(self.sprite, self.x, self.y)
  self:draw_bullets()
end

Bullet = {
  vy = 0,
  max_speed = 6,
  accel = 0.4,
  entity = nil,
}

Bullet.__index = Bullet

-- new
function Bullet:new() 
  return setmetatable({active = false}, self)
end

-- init
function Bullet:init(entity)
  self.entity = entity
  self.x = self.entity.x
  self.y = self.entity.y
  self.active = true
  self.entity.fire_sfx()
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
  spr(033, self.x, self.y)
end

function _init()
  Screen = { background = 0 }
  Player = Spaceship:init()
end

function _update()
  cls(Screen.background)
  Player:update()
end

function _draw()
  Player:draw()
end
