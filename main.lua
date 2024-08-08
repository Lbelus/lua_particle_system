PARTICLE = {}

function PARTICLE:new(x, y, life, angle, velocity, color)
	local pcle
	pcle.position = {
		x = x,
		y = y
	}
	pcle.x = x
	pcle.y = y
	pcle.life = life
	local angle_radian = angle * math.pi / 180
	pcle.velocity = {
		x = velocity * math.cos(angle_radian),
		y = -velocity * math.sin(angle_radian)
	}
	pcle.color = color
	setmetatable(pcle, self)
	self.__index = self
	return pcle
end


function PARTICLE:update(delta)
	self.life = self.life - delta

	self.position.x = self.position.x + self.velocity * delta
	self.position.y = self.position.y + self.velocity * delta
end



-- function love.draw()
--    love.graphics.print("Hello World", 400, 300)
-- end


function main()
	local blue_spark = PARTICLE:new(1, 1, 60, 10, 'blue')
	print(blue_spark)
	for index = 1, 10 do
	
	end

end
