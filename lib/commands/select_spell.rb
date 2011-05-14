class OgreIsland::Commands::SelectSpell < OgreIsland::Commands::Base
  register 'SELECTSPELL', :mode => :client do |command|
    command.string :name
  end
end
