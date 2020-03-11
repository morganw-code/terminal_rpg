class NPC
    attr_accessor :name, :level, :hp, :inventory, :price_list
  
    def initialize(name, hp = 100, level = 0)
      @name = name
      @level = level
      @hp = hp
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
  attr_accessor :base_dmg, :location, :alive
  def initialize(name)
    @base_dmg = 3
    @alive = true
    # init parent class initializer with 
    super(name, 100)
    map = Map.new()
    location = map.locations[:arena]
  end
end