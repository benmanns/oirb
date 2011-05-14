class OgreIsland::Commands::Statistic < OgreIsland::Commands::Base
  register 'STAT', :mode => :server do |command|
    command.string :id
    command.string :attribute
    command.string :value
    command.string :maximum
  end
end
