class OgreIsland::Commands::Say < OgreIsland::Commands::Base
  register 'SAY', :mode => :server do |command|
    command.string :name
    command.string :text
    command.string :channel
  end

  register 'SAY', :mode => :client do |command|
    command.string :text
  end
end
