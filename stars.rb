require 'ruby2d'

set width: 800
set height: 600

class Star
  def initialize
    @shape = Square.new(
      x: rand(Window.width),
      y: rand(Window.height),
      size: rand(3..5),
      color: 'random')
    @y_velocity = rand(1..3)
  end

  def move
    @shape.y = (@shape.y + @y_velocity) % Window.height
  end

  def draw
    @shape.add
  end
end

class Player
  HEIGHT = 90
  attr_writer :direction
  def initialize(side, movement_speed)
    @direction = nil
    @movement_speed = movement_speed
    @y = 200
      if side == :left
        @x = 60
      else
        @x = 720
      end
      @paddle = Rectangle.new(x: @x , y: @y,
      width: 25 , height: HEIGHT,
      color: 'white')
      @x_speed = 0
      @y_speed = 0
  end

  def draw
    @shape.add
  end

  def move
    if @direction == :up
      @y = [@y - @movement_speed, 0].max
    elsif @direction == :down
      @y = [@y + @movement_speed, max_y].min
    end
  end

  private

  def max_y
    Window.height - HEIGHT
  end
end

# class Player
#   def initialize
#     @shape = Square.new(
#       x: Window.width / 2,
#       y: Window.height - 50,
#       size: 20,
#       color: 'white')
#     @x_velocity = 1
#   end

#   def move_left
#     @shape.x -= @x_velocity if @shape.x - @x_velocity >= 0
#   end

#   def move_right
#     @shape.x += @x_velocity if @shape.x + @x_velocity + @shape.size <= Window.width
#   end

#   def draw
#     @shape.add
#   end
# end

class StarManager
  def initialize
    @stars = Array.new(100).map { Star.new }
  end

  def draw
    @stars.each(&:draw)
  end

  def update
    @stars.each(&:move)
  end
end

star_manager = StarManager.new
player_left = Player.new(:left, 5)
player_right = Player.new(:right, 5)

update do

  star_manager.update
  star_manager.draw

  player_left.move
  player_right.move
end

on :key_down do |event|
  if event.key == 'w'
    @direction = :up
  elsif event.key == 's'
    @direction = :down
  end
end

on :key_down do |event|
  if event.key == 'up'
    @direction = :up
  elsif event.key == 'down'
    @direction = :down
  end
end

show
