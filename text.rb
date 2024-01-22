require 'ruby2d'
set width: 800
set height: 600

@players = [

    Sprite.new(
      y: 300,
      'player_1.png',
      clip_width: 32,
      width: 50 * 2,
      height: 50 * 2

    )
]


show
