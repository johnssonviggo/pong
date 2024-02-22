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

class Player_select
  WIDTH = 200
  def initialize(image, x, y)
    Sprite.new(
        image,
        width: WIDTH,
        height: 200,
        x: x,
        y: y
      )
  end
end

class StarManager
  def initialize
    @stars = Array.new(100).map { Star.new }

    title_text = Text.new('PONG', size: 80, y: 30)
    title_text.x = (Window.width - title_text.width) / 2

    gamemode_select_text = Text.new('GAMEMODE SELECT', size: 60, y: 150)
    gamemode_select_text.x = (Window.width - gamemode_select_text.width) / 2

    exit_text = Text.new('EXIT', size: 55, y: 500)
    exit_text.x = (Window.width - exit_text.width) / 2

    player_1_text = Text.new('SINGEL SPELARE', size: 50, y: 400)


    @player = [
      Player_select.new('player_1.png', Window.width * (1/4.0) - Player_select::WIDTH / 2, 240),
      Player_select.new('player_2.png', Window.width * (3/4.0) - Player_select::WIDTH / 2, 240)

    ]
  end

  def draw
    @stars.each(&:draw)
  end

  def update
    @stars.each(&:move)
  end
end


star_manager = StarManager.new

update do

  star_manager.update
  star_manager.draw

end

show
