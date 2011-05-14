class OgreIsland::Commands::Handshake < OgreIsland::Commands::Base
  register 'HANDSHAKE', :mode => [:client, :server] do |command|
    command.string :sender
  end
end
