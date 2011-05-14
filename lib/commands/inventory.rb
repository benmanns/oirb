class OgreIsland::Commands::Inventory < OgreIsland::Commands::Base
  register 'INV', :mode => :server do |command|
    command.string :item
  end
end
