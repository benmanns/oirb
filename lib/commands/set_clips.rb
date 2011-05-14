class OgreIsland::Commands::SetClips < OgreIsland::Commands::Base
  register 'SETCLIPS', :mode => :server do |command|
    command.string :id
    command.string :x_scale
    command.string :y_scale
    command.string :alpha
    command.string :mount
    command.string :head
    command.string :head_gear
    command.string :hair
    command.string :face_hair
    command.string :torso
    command.string :right_arm
    command.string :left_arm
    command.string :right_leg
    command.string :left_leg
    command.string :right_foot
    command.string :left_foot
    command.string :left_object
    command.string :right_object
    command.string :shirt_color
    command.string :pants_color
    command.string :left_object_effect
    command.string :right_object_effect
    command.string :cloak
    command.string :spell_effect
    command.string :icon_color
  end
end
