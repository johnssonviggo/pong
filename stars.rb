  require 'ruby2d' # Använder Ruby2D-biblioteket för dess funktioner

  # Inställningar för fönstret
  set title: 'PONG' # Titel
  set width: 800 # Bredd på fönstret i pixlar
  set height: 600 # Höjd på fönstret i pixlar


  # Klass för stjärnor i bakgrunden
  class Star
    def initialize
      # Skapar en fyrkant med slumpmässiga egenskaper
      @shape = Square.new(
        x: rand(Window.width),  # Slumpmässig x-position inom fönstrets bredd
        y: rand(Window.height), # Slumpmässig y-position inom fönstrets höjd
        size: rand(3..5), # Slumpmässig storlek på fyrkant
        color: 'random')  # Slumpmässig färg på fyrkant
      @y_velocity = rand(1..3)
    end

    # Funktion som gör att stjärnorna åker ner
    def move
      # Flyttar stjärnan vertikalt och i fönstrets gränser
      @shape.y = (@shape.y + @y_velocity) % Window.height
    end

    # Funktion för att rita stjärnan
    def draw
      @shape.add  # Lägger till stjärnan på fönstret för att visas
    end
  end

  # Spelar klassen
  class Player
    HEIGHT = 90 # Höjd för spelare
    attr_writer :direction  # Tillåter att ändra riktningen för spelaren

    def initialize(side, movement_speed)
      @direction = nil  # Riktningen för spelaren
      @movement_speed = movement_speed  # Hastighet för spelaren
      @y = 200  # Startposition
        if side == :left
          @x = 60 # Vänster spelare
        else
          @x = 720  # Höger spelare
        end
        # Skapar rektangulär paddel med givna egenskaper
        @paddle = Rectangle.new(x: @x , y: @y,
        width: 25 , height: HEIGHT,
        color: 'white')
    end

    # Funktion för att flytta spelaren
    def move
      if @direction == :up
        @y = [@y - @movement_speed, 0].max
      elsif @direction == :down
        @y = [@y + @movement_speed, max_y].min
      end

    @paddle.y = @y
    end

    # Funktion som kollar om spelaren träffar bollen
    def hit_ball?(ball_manager)
      ball_manager.shape && [
        [ball_manager.shape.x1, ball_manager.shape.y1],
        [ball_manager.shape.x2, ball_manager.shape.y2],
        [ball_manager.shape.x3, ball_manager.shape.y3],
        [ball_manager.shape.x4, ball_manager.shape.y4]
        ].any? do |coordinates|
       @shape.contains?(coordinates[0], coordinates[1])
     end
   end

    private

    # Funktion för att beräkna maximala y-koordinaten för att hålla
    # paddeln inom fönstret
    def max_y
      Window.height - HEIGHT
    end
  end


  class Ball
    HEIGHT = 25 # Bollens storlek

    attr_reader :shape  # Läser formen på bollen

    def initialize(speed)
      @x = 400
      @y = 300
      @y_velocity = speed
      @x_velocity = -speed

      @ball = Square.new(
        x: @x, y: @y,
        size: HEIGHT,
        color: 'white')
    end


    # För att flytta bollen
    def move
      if hit_bottom? || hit_top?
        @y_velocity = -@y_velocity
      end
      @x = @x + @x_velocity
      @y = @y + @y_velocity
      @ball.x = @x
      @ball.y = @y
    end

    # Funktion till att bollen studsar
    def bounce
      @x_velocity = -@x_velocity
    end

    private

    # Ifall bollen träffar botten av skärmen
    def hit_bottom?
      @y + HEIGHT >= Window.height
    end

    # Ifall bollen träffar toppen
    def hit_top?
      @y <= 0
    end

  end

  # Hantering av bollen
  class BallManager
    attr_reader :shape

    def initialize
      @ball = [Ball.new(4)]
    end

    def update
      @ball.each(&:move)
    end

  end


  # Hantering av stjärnorna
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
  player_right = Player.new(:left, 5)
  player_left = Player.new(:right, 5)
  ball_manager = BallManager.new



  update do

    if player_left.hit_ball?(ball_manager) || player_right.hit_ball?(ball_manager)
      ball.bounce
    end

    player_left.move
    player_right.move

    star_manager.update
    ball_manager.update

  end

  # Så att spelaren kan flytta sig upp och ner
  on :key_down do |event|
    if event.key == 'up'
      player_left.direction = :up
    elsif event.key == 'down'
      player_left.direction = :down
    end

    if event.key == 'w'
      player_right.direction = :up
    elsif event.key == 's'
      player_right.direction = :down
    end
  end

  # Så att spelaren slutar röra sig om man inte trycker på knapparna
  on :key_up do |event|
    if ['up', 'down'].include?(event.key)
      player_left.direction = nil
    end

    if ['s', 'w'].include?(event.key)
      player_right.direction = nil
    end
  end


  # Sist men inte minst det som gör så att programmet visar skärmen
  show

  # Kod som kan vara bra att ha:

  # Hantering av spelare
  # class PlayerManager
  #   def initialize
  #     @players = [Player.new(:left, 5), Player.new(:right, 5)]
  #   end

  #   def update
  #     @players.each(&:move)
  #   end
  # end

  # ball.move

  #player_manager.update
