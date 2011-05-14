class OgreIsland::Commands::GetVariable < OgreIsland::Commands::Base
  register 'GV', :mode => :client do |command|
    command.string :variable
    command.string :value
  end
  register 'GV', :mode => :server do |command|
    command.string :response_key
    command.string :variable
  end
end
