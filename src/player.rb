# purpose, target audience, how the user is gonna interact

require_relative('./map.rb')
require('nokogiri')

class Player
  attr_accessor :name,
                :level,
                :hp,
                :gold,
                :base_damage,
                :map,
                :inventory,
                :location,
                :alive,
                :attack_list,
                :attack_multiplier,
                :attack_mana_cost

  def initialize(name)
    @name = name
    @level = 0
    @hp = 100
    @gold = 300
    @base_damage = 5
    @map = Map.new()
    @alive = true

    @inventory = {
      :sword => 1,
      :health_potion => 5
    }
    @location = map.locations[:hub]

    @attack_list = {
      :standard => "Standard",
      :strike => "Strike",
      :dark => "Dark",
      :thrust => "Thrust"
    }

    @attack_multiplier = {
      :miss => 0.0,
      :standard => 1.0,
      :strike => 1.5,
      :dark => 2.7,
      :thrust => 3.0
    }

    @attack_mana_cost = {
      :miss => 0.0,
      :standard => 0.0,
      :strike => 2.5,
      :dark => 4.5,
      :thrust => 5
    }
  end

  def take_damage(damage_amount)
    
    if(@hp - damage_amount > 0)
      @hp -= damage_amount
    else
      @alive = false
    end
  end

  def attack(attack_selection, npc)
    actual_attack = attack_selection
    n = Random.rand(0..1)
    case n
      when 0
        actual_attack = :miss
        p "missed"
        gets
      when 1
        dmg = @base_damage * @attack_multiplier[attack_selection]
        npc.take_damage(dmg)
    end

    if(actual_attack != :miss)
      puts "#{self.name} hit #{npc} with #{actual_attack} attack, dealing #{dmg} damage"
    else
      puts "#{self.name} missed an attack against #{npc}"
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