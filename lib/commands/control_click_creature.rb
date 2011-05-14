class OgreIsland::Commands::ControlClickCreature < OgreIsland::Commands::Base
  register 'CTRLCLICKCreature', :mode => :client do |command|
    command.string :id
  end
end
