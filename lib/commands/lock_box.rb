class OgreIsland::Commands::LockBox < OgreIsland::Commands::Base
  register 'LOCKBOX', :mode => :client do |command|
    command.string :id
  end
end
