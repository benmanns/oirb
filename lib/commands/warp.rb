class OgreIsland::Commands::Warp < OgreIsland::Commands::Base
  register 'WARP', :mode => :server do |command|
    command.string :id
    command.string :x
    command.string :y
    command.string :z
    command.string :w_level
    command.string :z_sort
  end
end
