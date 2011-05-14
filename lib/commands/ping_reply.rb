class OgreIsland::Commands::PingReply < OgreIsland::Commands::Base
  register 'PINGREPLY', :mode => :client do |command|
    command.string :who
    command.string :status
  end
end
