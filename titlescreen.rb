require 'ruby2d'

set title: 'Pong_titlescreen'
set width: 1920
set height: 1080

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

class PlayerSelectScreen
  def initialize
    @stars = Array.new(100).map { Star.new }

    title_text = Text.new('Pong', size: 100, y: 100)
    title_text.x = (Window.width - title_text.width) /2

    gamemode_text = Text.new('Gamemode Select', size: 50, y: 220)
    gamemode_text.x = (Window.width - gamemode_text.width) /2
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
