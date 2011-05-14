class OgreIsland::Commands::ClickInventory < OgreIsland::Commands::Base
  register 'CLICKINVENTORY', :mode => :client do |command|
    command.string :name
  end
end
