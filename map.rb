class Map
  def initialize()
    @locations = {
      :hub => 0, # 1 == unlocked location
      :arena => 0,
      :shop => 0
    }
  end

  def locations()
    return @locations
  end
end
