class OgreIsland::Commands::BattleTextMiscellaneous < OgreIsland::Commands::Base
  register 'BTMISC', :mode => :server do |command|
    command.string :type
    command.string :text
    command.string :uri
  end
end
