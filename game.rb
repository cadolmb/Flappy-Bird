require 'gosu'
require './bird.rb'
require './pipe.rb'

WIDTH = 490
HEIGHT = 750
FLOOR = 605
GAP = 175
SCROLL_SPEED = 4
TITLE = "Flappy Bird"

class GameWindow < Gosu::Window
  def initialize
    super WIDTH, HEIGHT
    self.caption = TITLE

    # Background
    @bg = Gosu::Image.new('bin/background.jpg')
    @font = Gosu::Font.new(25)
    @bg_x = 0

    @bird = Bird.new
    @pipes = []
    @pipes.push(Pipe.new(WIDTH * 3, HEIGHT / 2))

    @point_sound = Gosu::Sample.new('bin/sfx_point.wav')
    @jump_sound = Gosu::Sample.new('bin/sfx_wing.wav')
    @hit_sound = Gosu::Sample.new('bin/sfx_hit.wav')
    @die_sound = Gosu::Sample.new('bin/sfx_die.wav')

    @score = 0
    @dead = false
  end

  def button_down(id)
    case id
    when Gosu::KB_SPACE
      if !@dead
        @bird.jump
        @jump_sound.play
      end
    when Gosu::KB_F1 # CHEAT
      @dead = false
    when Gosu::KB_ESCAPE
      close
    else
      super
    end
  end

  def update
    @bird.update
    if @dead then return end
    @pipes.each { |pipe| pipe.update }
    @pipes.reject! { |pipe| pipe.offscreen? }

    # Collision
    if @bird.y >= FLOOR - @bird.img.height / 2
      @dead = true
      @hit_sound.play
    end

    @pipes.each_index do |i|
      if @pipes[i].collision?(@bird.HitBox[:x], @bird.HitBox[:y]) ||
         @pipes[i].collision?(@bird.HitBox[:x] + @bird.HitBox[:width], @bird.HitBox[:y]) ||
         @pipes[i].collision?(@bird.HitBox[:x], @bird.HitBox[:y] + @bird.HitBox[:height]) ||
         @pipes[i].collision?(@bird.HitBox[:x] + @bird.HitBox[:width], @bird.HitBox[:y] + @bird.HitBox[:height])
            @dead = true
            @hit_sound.play
            @die_sound.play
      end

      # Score
      if @bird.x - @pipes[i].x <= 3 && @bird.x - @pipes[i].x >= 0
        @score += 1
        @point_sound.play
      end
    end

    @bg_x -= SCROLL_SPEED
    @bg_x %= -WIDTH

    if button_down? Gosu::KB_F1; @dead = false end # CHEAT
  end

  def draw
    @bg.draw(@bg_x, 0, Z::BG)
    @bg.draw(@bg_x + WIDTH, 0, Z::BG)
    @font.draw_rel(@score, WIDTH / 2, HEIGHT / 6, Z::UI, 0.5, 0.5, 5, 5, Gosu::Color::WHITE)

    @bird.draw
    @pipes.each { |pipe| pipe.draw }

    @pipes.each_index do |i|
      if @pipes[i].x < WIDTH / 2 - @pipes[i].width && @pipes.length < 2
        @pipes.push(Pipe.new(WIDTH, rand(FLOOR - GAP / 2)))
      end
    end

    # HIT BOX
    #draw_rect(@bird.HitBox[:x], @bird.HitBox[:y], @bird.HitBox[:width], @bird.HitBox[:height], Gosu::Color.new(100, 255, 0, 0), 3)
  end
end

module Z
  BG, PIPE, BIRD, UI = *0..3
end

window = GameWindow.new
window.show
