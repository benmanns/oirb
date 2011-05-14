class OgreIsland::Commands::ClickCreature < OgreIsland::Commands::Base
  register 'CLICKCreature', :mode => :client do |command|
    command.string :id
  end
end
