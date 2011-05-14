class OgreIsland::Commands::ControlClickPlayer < OgreIsland::Commands::Base
  register 'CTRLCLICKPlayer', :mode => :client do |command|
    command.string :id
  end
end
