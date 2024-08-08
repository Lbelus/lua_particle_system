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
	pcle.position = pd.position
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



EMITER = {}

function EMITER:new()
	local emiter = {}
	setmetatable(emiter, self)
	self.__index = self
	return emiter
end



function main()
	print("begin particle test")
	
	local blue_spark_pd = PARTICLE_DESCRIPTOR:new(1, 1, 60, 10, 100, 'blue')

	local blue_spark = PARTICLE:new(blue_spark_pd)  -- Add a velocity value
	for index = 1, 10 do
		blue_spark:update(1)  -- Simulate updating with delta time of 1
		blue_spark:print_pos()
	end
end


main()
