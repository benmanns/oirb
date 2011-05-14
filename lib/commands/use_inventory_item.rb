class OgreIsland::Commands::UseInventoryItem < OgreIsland::Commands::Base
  register 'USEINVENTORYITEM', :mode => :client do |command|
    command.string :name
  end
end
