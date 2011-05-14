class OgreIsland::Commands::AddCharacter < OgreIsland::Commands::Base
  register 'ADDCHAR', :mode => :server do |command|
    command.string :id
    command.string :name
    command.string :swf
    command.string :x
    command.string :y
    command.string :z
    command.string :level
    command.string :x_scale
    command.string :y_scale
    command.string :w_level
    command.string :z_sort
  end
end
