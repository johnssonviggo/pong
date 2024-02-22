require 'ruby2d'

# Define a square shape.
@square = Square.new(x: 10, y: 200, size: 25, color: 'red')

# Define the initial speed (and direction).
@x_speed = 0
@y_speed = 0

# Define what happens when a specific key is pressed.
# Each keypress influences on the  movement along the x and y axis.
on :key_down do |event|
  if event.key == 'a'
    @x_speed = -20
    @y_speed = 0
  elsif event.key == 'd'
    @x_speed = 20
    @y_speed = 0
  elsif event.key == 'w'
    @x_speed = 0
    @y_speed = -20
  elsif event.key == 's'
    @x_speed = 0
    @y_speed = 20
  end
end

update do
  @square.x += @x_speed
  @square.y += @y_speed
end

show
