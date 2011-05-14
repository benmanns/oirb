class OgreIsland::Commands::AddObject < OgreIsland::Commands::Base
  register 'ADDOBJ', :mode => :server do |command|
    command.string :id
    command.string :name
    command.string :x
    command.string :y
    command.string :z
    command.string :clip
    command.string :frame
    command.string :x_scale
    command.string :y_scale
    command.string :sort_depth
    command.string :alpha
    command.string :rotation
    command.string :subclips
    command.string :w_level
    command.string :animated
  end
end
