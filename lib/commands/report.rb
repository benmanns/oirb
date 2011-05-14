class OgreIsland::Commands::FlipPage < OgreIsland::Commands::Base
  register 'REPORT', :mode => :client do |command|
    command.string :type
    command.string :name_description
    command.string :description_category
    command.string :other
    # REPORT, BUG, bugdesc, category
    # REPORT, PLAYER, playername, problemdesc, "other"
    # REPORT, IDEA, ideadesc, category
  end
end
