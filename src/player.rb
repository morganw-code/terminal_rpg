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
                :attack_mana_cost,
                :in_battle

  def initialize(name)
    @name = name
    @level = 0
    @hp = 100
    @gold = 300
    @base_damage = 5
    @map = Map.new()
    @alive = true
    @in_battle = false
    
    @inventory = {
      :sword => 1,
      :health_potion => 2,
      :mana_potion => 5,
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
    # if the damage amount doesn't kill the player, player takes damage
    if(@hp - damage_amount > 0)
      @hp -= damage_amount
    else
      @alive = false
    end
  end

  def attack(attack_selection, npc)
    actual_attack = attack_selection
    # determine if the attack was successful or not
    n = Random.rand(0..1)
    case n
      when 0
        # miss attack
        actual_attack = :miss

      when 1
        # deal damage to npc
        dmg = @base_damage * @attack_multiplier[attack_selection]
        npc.take_damage(dmg)
    end

    if(actual_attack != :miss)
      puts "#{self.name} hit #{npc.name} with #{actual_attack} attack, dealing #{dmg} damage"
    else
      puts "#{self.name} missed an attack against #{npc.name}"
    end
  end

  def write_save()
    # open file for writing with read / write perms
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

      # write to the file
      file.write(xml_builder.to_xml())
    }
  end

  def load_save()
    # check if file exists
    if(File.file?("save.xml"))
      begin
        # if the file is in use, we want to be able to catch that error
        file = File.open("save.xml", "r") { |file|
          doc = Nokogiri(file)
          query_stats = doc.at_xpath("//profile")
          query_inventory = doc.at_xpath("//inventory")
  
          @name = query_stats.at_xpath("//name").content
          @level = query_stats.at_xpath("//level").content
          @gold = query_stats.at_xpath("//gold").content
  
          @inventory[:sword] = query_inventory.at_xpath("//gold").content
          @inventory[:health_potion] = query_inventory.at_xpath("//health_potion").content
  
          puts "Loaded save: #{query_stats.at_xpath("//name").content}"
          return true
        }
      rescue => exception
        puts "#{exception}"
        return false
      end
    else
      return false
    end
  end
end