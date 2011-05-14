class OgreIsland::Commands::Z < OgreIsland::Commands::Base
  register 'Z', :mode => :client do |command|
    command.string :z
  end
end
