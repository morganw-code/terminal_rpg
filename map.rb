class Map
  def initialize()
    @locations = {
      :hub => "Hub",
      :arena => "Arena",
      :shop => "Shop"
    }
  end

  # getter
  def locations()
    return @locations
  end

  #setter
  def locations=(override)
    @locations = override
  end
end
