class OgreIsland::Commands::SetVariable < OgreIsland::Commands::Base
  register 'SV', :mode => :server do |command|
    command.string :variable
    command.string :value
  end
end
