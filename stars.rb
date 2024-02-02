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

# class Player
#   HEIGHT = 90
#   attr_writer :direction

#   def initialize(side, movement_speed)
#     @direction = nil
#     @movement_speed = movement_speed
#     @y = 200
#       if side == :left
#         @x = 60
#       else
#         @x = 720
#       end
#       @paddle = Rectangle.new(x: @x , y: @y,
#       width: 25 , height: HEIGHT,
#       color: 'white')
#       @x_speed = 0
#       @y_speed = 0
#   end

#   def move
#     if @direction == :up
#       @y = [@y - @movement_speed, 0].max
#     elsif @direction == :down
#       @y = [@y + @movement_speed, max_y].min
#     end

#   @paddle.y = @y
#   end


#   private

#   def max_y
#     Window.height - HEIGHT
#   end
# end

class Player
  HEIGHT = 90
  attr_writer :direction
  def initialize(side, movement_speed)
    @movement_speed = movement_speed
    @direction = nil
    @y = 200
      if side == :left
        @x = 60
      else
        @x = 720
      end
  end

    def move
      if @direction == :up
        @y = [@y - @movement_speed, 0].max
      elsif @direction == :down
        @y = [@y + @movement_speed, max_y].min
      end
    end

    def draw
      @shape = Rectangle.new(x: @x , y: @y, width: 25 , height: HEIGHT, color: 'white')
    end

    private

    def max_y
      Window.height - HEIGHT
    end
end

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

# class PlayerManager
#   # Correct the class name to match the instantiation later
#   def initialize
#     @players = [Player.new(:left, 5), Player.new(:right, 5)]
#   end

#   def update
#     @players.each(&:move)
#   end
# end

star_manager = StarManager.new
# player_manager = PlayerManager.new  # Corrected the variable name
player_left = Player.new(:left, 5)
player_right = Player.new(:right, 5)

update do

  clear

  star_manager.update
  star_manager.draw

  player_right.move
  player_right.draw

  player_left.move
  player_left.draw
end

on :key_down do |event|
  if event.key == 'w'
    player_left.direction = :up
  elsif event.key == 's'
    player_left.direction = :down
  elsif event.key == 'up'
    player_right.direction = :up
  elsif event.key == 'down'
    player_right.direction = :down
  end
end

on :key_up do |event|
  # Reset direction when the key is released
  if ['w', 's', 'up', 'down'].include?(event.key)
    player_left.direction = nil
    player_right.direction = nil
  end
end

show
