class OgreIsland::Commands::AddToBag < OgreIsland::Commands::Base
  register 'ADDTOBAG', :mode => :server do |command|
    command.string :name
    command.string :items
  end
end
