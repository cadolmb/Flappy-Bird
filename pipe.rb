class Pipe
  def initialize(x, y)
    @x = x
    @y = y
    @end_img = Gosu::Image.new('bin/pipe_end.png')
    @body_img = Gosu::Image.new('bin/pipe_body.png')

    @top_pipe = @y - GAP / 2 - @end_img.height
    @bottom_pipe = @y + GAP / 2
    @num_of_pipes = HEIGHT / @body_img.height
  end

  def update
    @x -= SCROLL_SPEED

    @ends = []
    @bodies = []

    @ends.push([@x, @top_pipe], [@x, @bottom_pipe]) # End Pipes

    @num_of_pipes.times do |i| # Top Body Pipes
      @bodies.push([@x + 2, @top_pipe - @body_img.height * (i + 1)])
    end

    @num_of_pipes.times do |i| # Bottom Body Pipes
      @bodies.push([@x + 2, @bottom_pipe + @end_img.height + @body_img.height * i])
    end
  end

  def draw
    @ends.each_index do |i|
      @end_img.draw(@ends[i][0], @ends[i][1], Z::PIPE)
    end

    @bodies.each_index do |i|
      @body_img.draw(@bodies[i][0], @bodies[i][1], Z::PIPE)
    end
  end

  def offscreen?
    if @x <= 0 - @end_img.width
      return true
    else
      return false
    end
  end

  def collision?(x, y)
    if x >= @x && x <= @x + @end_img.width
      if y <= @top_pipe + @end_img.height || y >= @bottom_pipe
        return true
      end
    end
    return false
  end

  def x; @x end
  def y; @y end
  def width; @end_img.width end
end
