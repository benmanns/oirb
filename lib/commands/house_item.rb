class OgreIsland::Commands::HouseItem < OgreIsland::Commands::Base
  register 'HOUSEITEM', :mode => :client do |command|
    command.string :id
    command.string :action
    command.string :x
    command.string :y
  end
end
