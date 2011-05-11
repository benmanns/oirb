class OgreIsland::CommandFormat
  attr_reader :fields

  def initialize
    @fields = []
  end

  def field type, name
    @fields << { :type => type, :name => name }
  end
end
