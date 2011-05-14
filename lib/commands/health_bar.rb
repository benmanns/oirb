class OgreIsland::Commands::HealthBar < OgreIsland::Commands::Base
  register 'HB', :mode => :server do |command|
    command.string :id
    command.string :toggle
    command.string :value
    command.string :maximum
  end
end
