class OgreIsland::Commands::Buy < OgreIsland::Commands::Base
  register 'BUY', :mode => :client do |command|
    command.string :name
    command.string :quantity
  end
end
