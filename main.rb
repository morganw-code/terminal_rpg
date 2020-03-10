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
                :last_location,
                :is_dead

  def initialize(name)
    @name = name
    @level = 0
    @hp = 100
    @damage = 10
    @map = Map.new()
    @map.locations[:hub] = 1 # default location
    @inventory = {
      :sword => 1,
      :health_potion => 5
    }
    @last_location = :hub
  end

  def take_damage(damage_amount)
    if(@hp - damage_amount != 0)
      @hp -= damage_amount
    else
      @is_dead = true
    end
  end

  def to_s()
    # todo: to_s override method that will display stats
    return "#{@name}"
  end
end

npc = NPC.new("Innocent Shopkeeper")
player = Player.new("Morgan")
screen = Screen.new("Terminal RPG", player)
