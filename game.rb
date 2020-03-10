require_relative './screen.rb'

class Game
  attr_accessor :title
  def initialize(title)
    @title = title
    screen = Screen.new(title)
  end
end

game = Game.new("RPG terminal")
