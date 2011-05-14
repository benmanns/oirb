class OgreIsland::Commands::RemoveObject < OgreIsland::Commands::Base
  register 'REMOVEOBJECT', :mode => :client do |command|
    command.string :id
  end
  register 'REMOBJ', :mode => :server do |command|
    command.string :id
  end
end
