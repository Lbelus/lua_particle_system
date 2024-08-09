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
	pcle.position = {x = pd.position.x, y = pd.position.y}  -- Make a copy of the position table
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

function PARTICLE:update(delta)
	self.life = self.life - delta
	self.position.x = self.position.x + self.velocity.x * delta
	self.position.y = self.position.y + self.velocity.y * delta
end

function PARTICLE:print_pos()
	print("Particle position - x: " .. self.position.x .. ", y: " .. self.position.y)
end

EMITTER_CONFIG = {}

function EMITTER_CONFIG:new(total_particles)
	local config = {}
	config.total_particles = total_particles
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

function EMITTER:update(delta)
	local particle = table.remove(self.particle_pool)
	if particle then
		particle:update(delta)
		particle:print_pos()
		-- Reinsert the particle to the pool if it still has life
		if particle.life > 0 then
			self:emit(particle)
		end
	end
end

function main()
	print("begin emitter test")
	local config = EMITTER_CONFIG:new(10)
	local blue_spark_pd = PARTICLE_DESCRIPTOR:new(1, 1, 2, 60, 10, 'blue')
	local blue_spark_emitter = EMITTER:new(config, blue_spark_pd)
	for i = 1, 10 do
		blue_spark_emitter:update(1)
	end
end

main()

