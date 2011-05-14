class OgreIsland::Commands::Login < OgreIsland::Commands::Base
  register 'LOGIN', :mode => :client do |command|
    command.string :id
    command.string :token
    command.string :client
  end
end
