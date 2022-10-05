function _init()
  Screen = {}
  Screen.minX = 0
  Screen.maxX = 128
  Screen.background = 1

  Ship = {

    -- position
    x = 60,
    y = 112,

    -- movement
    control = false,
    vx = 0,
    vy = 0,
    accel = 0.25,
    friction = 0.1,
    max_speed = 2.5,

    -- health
    max_health = 3,

    -- projectile
    projectile_speed = -4,
    projectile_kickback = 1.4,

    handle_input = function(self)
      local vx, accel, friction, max_speed = self.vx, self.accel, self.friction, self.max_speed
      if btn(0) then
        vx = vx > 0 and -accel or vx - accel
      elseif btn(1) then
        vx = vx < 0 and accel or vx + accel
      elseif vx != 0 then
        vx += min(abs(vx), friction) * -sgn(vx)
      end

      self.vx = mid(-max_speed, vx, max_speed)

    end,

    update = function(self)
      self:handle_input()
      if(self.x < -8) then
        self.x = 127
      elseif (self.x > 128) then
        self.x = -7
      else 
        self.x = self.x + self.vx
      end
    end,

    draw = function(self)
      spr(001, self.x, self.y)
    end

  }

  cls(Screen.background)
end

function _update()
  cls(Screen.background)

  Ship:update()

end

function _draw()
  Ship:draw()
end
