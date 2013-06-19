class OgreIsland::CommandFormat
  attr_reader :fields

  def initialize
    @fields = []
  end

  def field type, name
    @fields << { :type => type, :name => name }
  end

  def integer name
    field OgreIsland::Fields::Integer, name
  end

  def item name
    field OgreIsland::Fields::Item, name
  end

  def string name
    field OgreIsland::Fields::String, name
  end
end
