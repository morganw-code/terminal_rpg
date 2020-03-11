# purpose, target audience, how the user is gonna interact

require_relative('./map.rb')
require('nokogiri')

class Player
  attr_accessor :name,
                :level,
                :hp,
                :gold,
                :damage,
                :map,
                :inventory,
                :location,
                :is_dead

  def initialize(name)
    @name = name
    @level = 0
    @hp = 100
    @gold = 100
    @damage = 10
    @map = Map.new()
    @inventory = {
      :sword => 1,
      :health_potion => 5
    }
    @location = map.locations[:hub]
  end

  def take_damage(damage_amount)
    if(@hp - damage_amount > 0)
      @hp -= damage_amount
    else
      @is_dead = true
    end
  end

  def write_save()
    file = File.open("save.xml", "w+") { |file|
      xml_builder = Nokogiri::XML::Builder.new() { |xml|
        xml.root {
          xml.profile {
            xml.name(@name)
            xml.level(@level)
            xml.hp(@hp)
            xml.gold(@gold)
          }

          xml.inventory {
            xml.sword(@inventory[:sword])
            xml.health_potion(@inventory[:health_potion])
          }
        }
      }
      file.write(xml_builder.to_xml())
    }
  end

  def load_save()
    if(File.file?("save.xml"))
      file = File.open("save.xml", "r") { |file|
        # todo
      }
      return true
    else
      return false
    end
  end

  def to_s()
    return "#{@name}"
  end
end

# npc = NPC.new("Innocent Shopkeeper")
player = Player.new("Morgan")
