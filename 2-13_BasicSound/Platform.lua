local vector = require "vector"
local love = love
local setmetatable = setmetatable

local Platform = {}

if setfenv then
   setfenv(1, Platform) -- for 5.1
else
   _ENV = Platform -- for 5.2
end

image = love.graphics.newImage( "img/800x600/platform.png" )
local platform_small_tile_width = 75
local platform_small_tile_height = 16
local platform_small_tile_x_pos = 0
local platform_small_tile_y_pos = 0
local platform_norm_tile_width = 108
local platform_norm_tile_height = 16
local platform_norm_tile_x_pos = 0
local platform_norm_tile_y_pos = 32
local platform_large_tile_width = 141
local platform_large_tile_height = 16
local platform_large_tile_x_pos = 0
local platform_large_tile_y_pos = 64
local platfrom_glued_x_pos_shift = 192
local tileset_width = 333
local tileset_height = 80

function Platform:new( o )
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.name = o.name or "platform"
   o.position = o.position or vector( 300, 500 )
   o.speed = o.speed or vector( 800, 0 )
   o.width = o.width or platform_norm_tile_width
   o.height = o.height or platform_norm_tile_height
   o.collider = o.collider or {}
   o.collider_shape = o.collider:rectangle( o.position.x,
					    o.position.y,
					    o.width,
					    o.height )
   o.collider_shape.game_object = o
   o.quad = o.quad or love.graphics.newQuad( platform_norm_tile_x_pos,
					     platform_norm_tile_y_pos,
					     platform_norm_tile_width,
					     platform_norm_tile_height,
					     tileset_width, tileset_height )
   return o
end

function Platform:update( dt )
   if love.keyboard.isDown("right") then
      self.position.x = self.position.x + self.speed.x * dt
   end
   if love.keyboard.isDown("left") then
      self.position.x = self.position.x - self.speed.x * dt
   end
   self.collider_shape:moveTo( self.position.x + self.width / 2,
			       self.position.y + self.height / 2 )
end

function Platform:draw()
   love.graphics.draw( self.image,
   		       self.quad, 
   		       self.position.x,
   		       self.position.y )
end

function Platform:react_on_wall_collision( another_shape, separating_vector )
   self.position = self.position + separating_vector
   self.collider_shape:moveTo( self.position.x + self.width / 2,
			       self.position.y + self.height / 2 )   
end

function Platform:destroy()
   self.collider_shape.game_object = nil
   self.collider:remove( self.collider_shape )
end

return Platform
