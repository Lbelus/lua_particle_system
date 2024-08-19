MODIFIER = {}

function MODIFIER:new()
	local mod = {}
	setmetatable(mod, self)
	self.__index = self
	return mod
end

PARTICLE_DESCRIPTOR = {}

function PARTICLE_DESCRIPTOR:new(x, y, life, angle, velocity, color)
	local pd = {}
	pd.position = {
		x = x,
		y = y
	}
	pd.life = life
	pd.lifecycle = 0
	pd.angle = angle
	pd.velocity = velocity
	pd.color = color
	setmetatable(pd, self)
	self.__index = self
	return pd
end

PARTICLE = MODIFIER:new()

function PARTICLE:new(pd)
	local pcle = {}
	pcle.position = {x = pd.position.x, y = pd.position.y}
	pcle.life = pd.life
	local angle_radian = pd.angle * math.pi / 180
	pcle.velocity = {
		x = pd.velocity * math.cos(angle_radian),
		y = -pd.velocity * math.sin(angle_radian)
	}
	pcle.color = pd.color
	setmetatable(pcle, self)
	self.__index = self
	return pcle
end

function PARTICLE:update(delta, pixel_per_frame)
	self.life = self.life - delta
	self.position.x = self.position.x + self.velocity.x * (delta * pixel_per_frame)
	self.position.y = self.position.y + self.velocity.y * (delta * pixel_per_frame)
end

function PARTICLE:print_pos()
	print("Particle position - x: " .. self.position.x .. ", y: " .. self.position.y)
end

function PARTICLE:draw()
	love.graphics.setColor(self.color)
	love.graphics.circle("fill", self.position.x, self.position.y, 5)
end


EMITTER_CONFIG = {}

function EMITTER_CONFIG:new(total_particles, pixel_per_frame)
	local config = {}
	config.total_particles = total_particles
	config.pixel_per_frame = pixel_per_frame
	config.spacing = spacing
	setmetatable(config, self)
	self.__index = self
	return config
end

EMITTER = {}

function EMITTER:new(config, pd)
	local emitter = {}
	emitter.config = config
	emitter.particle_pool = {}
	for index = 1, config.total_particles do
		table.insert(emitter.particle_pool, PARTICLE:new(pd))
	end
	setmetatable(emitter, self)
	self.__index = self
	return emitter
end

function IS_EMPTY(table)
    return next(table) == nil
end

function EMITTER:emit(particle)
	table.insert(self.particle_pool, particle)
end

local function isEmpty(table)
    return next(table) == nil
end

-- not the spacing that i want
function EMITTER:update(delta, emit_count)
	local size =  math.min(emit_count, #self.particle_pool)
	local particle_stack = {}
	for index = 1, size do
		table.insert(particle_stack, table.remove(self.particle_pool))
	end
	local delay = 1 / #particle_stack
	while not isEmpty(particle_stack) do
		local particle = table.remove(particle_stack)
		if particle then
			particle:update((delta*delay), self.config.pixel_per_frame)
			if particle.life > 0 then
				self:emit(particle)
			end
		end
		delay = delay + delay
	end 
end

-- // delay effect
-- function EMITTER:update(delta, emit_count)
-- 	local size =  math.min(emit_count, #self.particle_pool)
-- 	local particle_stack = {}
-- 	for index = 1, size do
-- 		table.insert(particle_stack, table.remove(self.particle_pool))
-- 	end
-- 	local delay = 1 / #particle_stack
-- 	while not isEmpty(particle_stack) do
-- 		local particle = table.remove(particle_stack)
-- 		if particle then
-- 			particle:update((delta * delay), self.config.pixel_per_frame)
-- 			if particle.life > 0 then
-- 				self:emit(particle)
-- 			end
-- 		end
-- 		delay = delay + delay
-- 	end
-- end


function EMITTER:draw()
	for _, particle in ipairs(self.particle_pool) do
		particle:draw()
	end
end

-- function main()
-- 	print("begin emitter test")
-- 	local config = EMITTER_CONFIG:new(10)
-- 	local blue_spark_pd = PARTICLE_DESCRIPTOR:new(1, 1, 2, 60, 10, 'blue')
-- 	local blue_spark_emitter = EMITTER:new(config, blue_spark_pd)
-- 	for i = 1, 10 do
-- 		blue_spark_emitter:update(1)
-- 	end
-- end

-- main()

function love.load()
	local config = EMITTER_CONFIG:new(100, 1, 1)
	local blue_spark_pd = PARTICLE_DESCRIPTOR:new(400, 300, 5, 60, 100, {0, 0, 1})  -- Color as RGB values (0-1 range)
	blue_spark_emitter = EMITTER:new(config, blue_spark_pd)
end

function love.update(dt)
	blue_spark_emitter:update(dt, 5)
end

function love.draw()
	blue_spark_emitter:draw()
end