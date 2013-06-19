class OgreIsland::Fields::Integer < OgreIsland::Fields::Base
  class << self
    def parse string, options={}
      super.to_i
    end
  
    def encode value, options={}
      super.to_s
    end
  end
end
