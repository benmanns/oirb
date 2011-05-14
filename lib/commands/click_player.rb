class OgreIsland::Commands::ClickPlayer < OgreIsland::Commands::Base
  register 'CLICKPlayer', :mode => :client do |command|
    command.string :id
  end
end
