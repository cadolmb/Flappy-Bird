class Bird
  def initialize
    # Movement
    @x = WIDTH / 5
    @y = HEIGHT / 4
    @angle = 0.0
    @spin = 0.0
    @velocity = 0.0
    # Modifiers
    @gravity = 0.5
    @jump_height = -10
    @jump_angle = -30
    @fall_angle = 90
    @spin_acceleration = 0.075

    @img = Gosu::Image.new('bin/bird.png')
  end

  def jump
    @velocity = @jump_height
    @angle = @jump_angle
    @spin = 0
  end

  def HitBox
    x = (@x - @img.width / 2) + @img.width * 0.1
    y = (@y - @img.height / 2) + @img.height * 0.05
    width = @img.width * 0.8
    height = @img.height * 0.95
    return {x: x, y: y, width: width, height: height}
  end

  def update
    @velocity += @gravity
    @y += @velocity
    if @y >= FLOOR - @img.height / 2
      @y = FLOOR - @img.height / 2
      @angle = @fall_angle
    end

    @spin += @spin_acceleration
    @angle += @spin
    if @angle >= @fall_angle then @angle = @fall_angle end
  end

  def draw
    @img.draw_rot(@x, @y, Z::BIRD, @angle)
  end

  def x; @x end
  def y; @y end
  def img; @img end
end
