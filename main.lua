Spaceship = {
  -- bullet pool
  bullets = {},

  name = 'Spaceship',

  bb = nil,

  x_was_pressed = false,

  -- position
  x = 42,
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

  -- sprites
  dir = {
    left = 001,
    ahead = 002,
    right = 003,
  },

  spr_spaceship = 002,

  -- flames
  flame_counter = 1,
  spr_flames = {016, 017, 018, 019},
}

Spaceship.__index = Spaceship

-- new Spaceship
function Spaceship:new(o)
  return setmetatable(o, self)
end

-- init Spaceship
function Spaceship:init()
  local spaceship = self:new({})

  for i = 1, 10 do
    add(spaceship.bullets, Bullet:new())
  end

  spaceship.bb = Star:init(spaceship)

  return spaceship
end

function Spaceship.fire_sfx()
  -- sfx(00)
end

function Spaceship:handle_input_left_right()
  local vx = self.vx
  local accel = self.accel
  local friction = self.friction
  local max_speed = self.max_speed

  if btn(0) then
    self.spr_spaceship = self.dir.left
    vx = vx > 0 and -accel or vx - accel
  elseif btn(1) then
    self.spr_spaceship = self.dir.right
    vx = vx < 0 and accel or vx + accel
  elseif vx != 0 then
    self.spr_spaceship = self.dir.ahead
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
  if btn(5) and self.x_was_pressed then
    self.bb:charge()
  elseif btn(5) and not self.x_was_pressed then
    self:prime_non_active_bullet()
    self.x_was_pressed = true
  else
    if self.bb:is_charged() then
      -- TODO: realease big boy
      self.bb:release()
    end
    self.bb:reset_counter()
    self.x_was_pressed = false
  end
end

function Spaceship:check_bounds()
  if self.x < -8 then
    self.x = 127
  elseif self.x > 128 then
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

function Spaceship:update_flames()
  self.flame_counter += 1
  if self.flame_counter > count(self.spr_flames) then
    self.flame_counter = 1
  end
end

-- update
function Spaceship:update()
  self:handle_input_left_right()
  self:check_bounds()
  self:handle_input_x()
  self:update_bullets()
  self:update_flames()
  if self.bb:is_active() then self.bb:update() end
end

function Spaceship:draw_bullets()
  for bullet in all(self.bullets) do
    if bullet.active then bullet:draw() end
  end
end

function Spaceship:draw_flames()
  spr(self.spr_flames[self.flame_counter], self.x, self.y + 8)
end

-- draw
function Spaceship:draw()
  spr(self.spr_spaceship, self.x, self.y)
  self:draw_bullets()
  self:draw_flames()
  if self.bb:is_active() then self.bb:draw() end
end

Bullet = {
  vy = 0,
  max_speed = 6,
  accel = 4,
  entity = nil,
  r = 2,
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
  circfill(self.x + 4, self.y, self.r, 12)
end

Star = {
  x = 85,
  y = 75,
  vy = 0,
  accel = 8,
  a = 0, --angle
  s = 4 + rnd(4), --size
  min_s = 2,
  entity = nil,
  counter = 0,
  counter_max = 24,
  _is_active = false,
  _is_charged = false,
  _is_released = false,
}

Star.__index = Star

function Star:new()
  return setmetatable({}, self)
end

function Star:init(entity)
  local star = self:new()
  star.entity = entity
  return star
end

function Star:update()
  self.s = self.min_s + rnd(2) --size
  self.a += 0.2
  self.x = self.entity.x + 4
  if self:is_released() then
    self.vy = self.vy - self.accel
  end
  self.y = self.entity.y + self.vy
  if self.y < 0 then self:reset() end
end

function Star:draw()
  circfill(self.x + sin(self.a) * 1, self.y, self.s, 7)
  circfill(self.x + sin(self.a) * 2, self.y - 1, self.s, 12)
end

function Star:charge()
  if self:is_charged() then return end
  self.counter += 1
  if self.counter > self.counter_max then
    self._is_charged = true
    self._is_active = true
  end
end

function Star:release() self._is_released = true end

function Star:is_released() return self._is_released end

function Star:is_charged() return self._is_charged end

function Star:is_active() return self._is_active end

function Star:reset_counter() self.counter = 0 end

function Star:reset()
  self:reset_counter()
  self._is_charged = false
  self._is_active = false
  self._is_released = false
  self.x = self.entity.x
  self.y = self.entity.y
  self.vy = 0
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
  print('charging:')
  local counter = Player.bb.counter
  if counter > Player.bb.counter_max then counter = Player.bb.counter_max end
  print(counter, 12)
end
