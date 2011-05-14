class OgreIsland::Commands::MoveInventoryItem < OgreIsland::Commands::Base
  register 'MOVEINVENTORYITEM', :mode => :client do |command|
    command.string :name
  end
end
