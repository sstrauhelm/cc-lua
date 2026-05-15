require "Matrix"
require "PID"
require "Vector"

Stabilizer = {}
Stabilizer.__index = Stabilizer

-- Motor configs are in the following configuration
-- 1 = rf
-- 2 = rb
-- 3 = lf
-- 4 = lb
--  _       _
-- /3\     /1\
-- ---_   _---
--     | |
--      |
--     | |
--    -   -
-- ---     ---
-- \4/     \2/
--  -       -

function Stabilizer:new(rf, rb, lf, lb, min, max)
    local c = setmetatable({}, Stabilizer)
    c.motors = {rf, rb, lf, lb}
    c.motor_mixer = Matrix:from_table({
        {-1, 1},
        {1, -1},
        {1, 1},
        {-1, -1}
    })
    c.roll_pid = PID:new(1, 0.1, 0.05)
    c.pitch_pid = PID:new(1, 0.1, 0.05)
    return c
end

function Stabilizer:tick(roll, pitch, delta_t)
    local p = sublevel.getLogicalPose()
    local m_roll, m_yaw, m_pitch = p["orientation"]:toEuler()

    local c_roll = self.roll_pid:tick(roll, delta_t, m_roll)
    local c_pitch = self.pitch_pid:tick(pitch, delta_t, m_pitch)

    local input = Vector:from_table({c_roll, c_pitch})
    local pwm = self.motor_mixer:mul_vec(input)
    for i=1, #pwm do
        self.motors[i].setTargetSpeed(pwm[i])
    end
end

function wrapMotor(num)
    return peripheral.wrap(string.format("Create_RotationSpeedController_%d", num))
end

local s = Stabilizer:new(wrapMotor(0), wrapMotor(1), wrapMotor(2), wrapMotor(3))
s:tick(1, 0, 0.1)
