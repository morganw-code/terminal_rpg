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
  attr_accessor :base_dmg, :location, :alive, :attack_list, :debuf
  def initialize(name, attack_list = {})
    @base_dmg = 3
    @alive = true
    @attack_list = attack_list
    # init parent class initializer with 
    super(name, 100)
    map = Map.new()
    location = map.locations[:arena]
  end

  def take_damage
  end

  def attack(player)
    arr = [:miss, :standard, :strike, :dark, :thrust]
    random_attack = arr.sample()
    dmg = @base_dmg * @attack_list[random_attack]
    player.take_damage(dmg)
    if(random_attack != :miss)
      puts "#{self.name} hit #{player} with #{random_attack} attack, dealing #{dmg} damage"
    else
      puts "#{self.name} missed an attack against #{player}"
    end
  end
end