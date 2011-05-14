class OgreIsland::Commands::FlipPage < OgreIsland::Commands::Base
  register 'FLIPPAGE', :mode => :client do |command|
    command.string :direction # TODO: check this
  end
end
