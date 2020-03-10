# purpose, target audience, how the user is gonna interact

require_relative('./screen.rb')
require_relative('./map.rb')

class NPC
  attr_accessor :name,
                :level

  def initialize(name, level = 0)
    @name = name
    @level = level
    @inventory = {
      :sword => 1,
      :health_potion => 5
    }
  end
end

class Boss < NPC
  attr_accessor :base_dmg
  def initialize(name)
    super(name)
    @base_dmg = 10 * @level
    map = Map.new()
    map.locations[:arena]
  end
end

class Player
  attr_accessor :name,
                :level,
                :hp,
                :damage,
                :map,
                :inventory,
                :last_location

  def initialize(name)
    @name = name
    @map = Map.new()
    @map.locations[:hub] = 1 # default location
    @inventory = {
      :sword => 1,
      :health_potion => 5
    }
    @last_location = :hub
  end
end

npc = NPC.new("Big John")
player = Player.new("Mike")
screen = Screen.new("Terminal RPG", player)
