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

    def hit_ball?(ball)
      ball.shape && [[ball.shape.x1, ball.shape.y1], [ball.shape.x2, ball.shape.y2],
      [ball.shape.x3, ball.shape.y3], [ball.shape.x4, ball.shape.y4]].any? do |coordinates|
        @shape.contains?(coordinates[0], coordinates[1])
      end
    end

    private

    def max_y
      Window.height - HEIGHT
    end
end

class Ball
  HEIGHT = 25

  attr_reader :shape

  def initialize(speed)
    @x = 400
    @y = 300
    @y_velocity = speed
    @x_velocity = -speed
  end

  def move
    if hit_bottom? || hit_top?
      @y_velocity = -@y_velocity
    end
    @x = @x + @x_velocity
    @y = @y + @y_velocity
  end

  def draw
    @shape = Square.new(x: @x, y: @y, size: HEIGHT, color: 'white')
  end

  def bounce
    @x_velocity = -@x_velocity
  end



  private

  def hit_bottom?
    @y + HEIGHT >= Window.height
  end

  def hit_top?
    @y <= 0
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
player_right = Player.new(:left, 5)
player_left = Player.new(:right, 5)
ball = Ball.new (4)

update do

  clear

  if player_left.hit_ball?(ball) || player_right.hit_ball?(ball)
    ball.bounce
  end

  star_manager.update
  star_manager.draw

  player_left.move
  player_left.draw

  player_right.move
  player_right.draw

  ball.move
  ball.draw
end

on :key_down do |event|
  if event.key == 'w'
    player_right.direction = :up
  elsif event.key == 's'
    player_right.direction = :down
  elsif event.key == 'up'
    player_left.direction = :up
  elsif event.key == 'down'
    player_left.direction = :down
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
