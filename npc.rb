class NPC
    attr_accessor :name, :level, :inventory, :price_list
  
    def initialize(name, level = 0)
      @name = name
      @level = level
      
      @inventory = {
        # item => { item_str => stock }
        :sword => { "Sword" => 1 },
        :health_potion => { "Health Potion" => 5 }
      }

      @price_list = {
          :sword => 50,
          :health_potion => 15
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