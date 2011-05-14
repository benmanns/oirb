class OgreIsland::Commands::TradeGold < OgreIsland::Commands::Base
  register 'TRADEGOLD', :mode => :client do |command|
    command.string :amount
  end
end
