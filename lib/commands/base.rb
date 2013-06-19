class OgreIsland::Commands::Base
  class << self
    attr_accessor :key
    attr_accessor :formats

    def register key, options={}
      @key = key
      @formats ||= {}
      mode = options[:mode]
      mode = [mode] unless mode.respond_to? :each
      mode.each do |mode|
        @formats[mode] = OgreIsland::CommandFormat.new
        yield @formats[mode] if block_given?
        @formats[mode].fields.each do |field|
          define_method field[:name] do
            attributes[field[:name]]
          end
          define_method "#{field[:name]}=" do |value|
            attributes[field[:name]] = value
          end
        end
        OgreIsland::Commands.commands ||= {}
        OgreIsland::Commands.commands[mode] ||= {}
        OgreIsland::Commands.commands[mode][@key.downcase] = self
      end
    end

    def parse data, options={}
      key = data.shift
      if OgreIsland::Commands.commands and OgreIsland::Commands.commands[options[:mode]] and klass = OgreIsland::Commands.commands[options[:mode]][key.downcase]
        klass.new.tap do |command|
          command.class.formats[options[:mode]].fields.each do |field|
            break if data.empty?
            command.attributes[field[:name]] = field[:type].parse(data.shift)
          end
        end
      else
        OgreIsland::Commands::Base.new(*data).tap do |command|
          command.key = key
        end
      end
    end
  end

  attr_accessor :attributes
  attr_accessor :key

  def initialize *attributes
    if attributes.first.is_a? Hash
      @attributes = attributes.first
    elsif self.class.formats
      @attributes = {}
    else
      @attributes = attributes
    end
  end

  def to_a options={}
    key = [@key ? @key : self.class.key]
    return key if @attributes.empty?
    if @attributes.is_a? Hash
      self.class.formats[options[:mode]].fields.each_with_object key do |field, data|
        break data unless @attributes[field[:name]]
        data << field[:type].encode(@attributes[field[:name]])
      end
    else
      key + attributes
    end
  end
end
