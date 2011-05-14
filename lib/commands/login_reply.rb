class OgreIsland::Commands::LoginReply < OgreIsland::Commands::Base
  register 'LOGINREPLY', :mode => :server do |command|
    command.string :status
    command.string :name
    command.string :id
    command.string :message
  end
end
