class OgreIsland::Commands::TradePlatinum < OgreIsland::Commands::Base
  register 'TRADEPLAT', :mode => :client do |command|
    command.string :amount
  end
end
