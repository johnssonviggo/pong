require 'ruby2d'

set title: 'Pong_titlescreen'
set width: 800
set height: 600

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

  def update
    if Window.frames % 2 == 0
    @stars.each { |star| star.move }
    end
  end

end

 player_select_screen = PlayerSelectScreen.new

update do
  player_select_screen.update
end

show
