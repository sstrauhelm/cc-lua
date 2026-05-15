PID = {}
PID.__index = PID

function PID:new(prop_gain, int_gain, drv_gain, min, max)
    c = setmetatable({}, PID)
    c.prev_err = 0
    c.integral = 0

    c.prop_gain = prop_gain
    c.int_gain = int_gain
    c.drv_gain = drv_gain

    c.min = min
    c.max = max
    return c
end

function PID:reset()
    self.integral = 0
    self.prev_err = 0
    self.prev_val = 0
end

function PID:tick(setpoint, delta_t, measured_val)
    local err = setpoint - measured_val
    self.integral = self.integral + err * delta_t
    local drv = (err - self.prev_err) / delta_t
    local control = self.prop_gain * err + self.int_gain * self.integral + self.drv_gain * drv
    self.prev_err = err

    if self.min then
        control = max(control, self.min)
    end
    if self.max then
        control = min(control, self.max)
    end
    
    return control
end