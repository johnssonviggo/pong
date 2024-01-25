  require 'ruby2d'

  set title: 'Pong'
  set width: 800
  set height: 600


  class Racket
    HEIGHT = 150
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

    def move_racket
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

    def move_ball
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

  class Star

    def initialize
      @y_velocity = rand(1..4)
      @shape = Square.new(
        x: rand(Window.width),
        y: rand(Window.height),
        size: rand(3..5),
        color: 'random')
    end

    def move
      @shape.y = (@shape.y + @y_velocity) % Window.height
    end
  end

  class Player
      WIDTH = 223
      HEIGHT = 63
    def initialize(image, x, y)
      Sprite.new(
        image,
        width: WIDTH,
        height: HEIGHT,
        x: x,
        y: y
      )
    end
  end

  class PlayerSelectScreen
    def initialize
      @stars = Array.new(100).map { Star.new }

      title_text = Text.new('Pong', size: 100, y: 100)
      title_text.x = (Window.width - title_text.width) /2

      gamemode_text = Text.new('Gamemode Select', size: 50, y: 220)
      gamemode_text.x = (Window.width - gamemode_text.width) /2

      @players = [
        Player.new('better_player1_wb.png', Window.width * (1/4.0) - Player::WIDTH / 2, 375), #float på ena för annars tror ruby det är noll
        Player.new('player_2.png', Window.width * (3/4.0) - Player::WIDTH / 2, 375)
      ]
    end

    def update_stars
      if Window.frames % 2 == 0
        @stars.each { |star| star.move}
      end
    end
  end

  player_1 = Racket.new(:left, 5)
  player_2 = Racket.new(:right, 5)
  ball = Ball.new (4)
  star = Star.new

  player_select_screen = PlayerSelectScreen.new


  update do

    star.move
    player_select_screen.update_stars

    if player_1.hit_ball?(ball) || player_2.hit_ball?(ball)
      ball.bounce
    end

    star.move
    star.draw

    player_1.move_racket
    player_1.draw

    player_2.move_racket
    player_2.draw

    ball.move_ball
    ball.draw

  end

  on :key_down do |event|
    if event.key == 'up'
      player_2.direction = :up
    elsif event.key == 'down'
      player_2.direction = :down
    end
  end
  on :key_up do |event|
  end

  on :key_down do |event|
    if event.key == 'w'
      player_1.direction = :up
    elsif event.key == 's'
      player_1.direction = :down
    end
  end

  on :key_up do |event|
  end

  show
