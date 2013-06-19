class OgreIsland::Protocol < EventMachine::Connection
  class HaltCallback < Exception; end

  class << self
    def register_callback event
      define_method "before_#{event}" do |&block|
        @callbacks ||= {}
        @callbacks[event] ||= []
        @callbacks[event].unshift block
      end

      define_method "after_#{event}" do |&block|
        @callbacks ||= {}
        @callbacks[event] ||= []
        @callbacks[event].push block
      end
    end
  end

  def run_callback event, *args
    @callbacks ||= {}
    @callbacks[event] ||= []
    @callbacks[event].each do |callback|
      begin
        callback.call *args
      rescue HaltCallback
        break
      end
    end
  end

  [:receive_packet, :unbind].each { |event| register_callback event }

  def post_init
    @buffer = BufferedTokenizer.new 0.chr
  end

  def receive_data data
    @buffer.extract(data).each do |packet|
      run_callback :receive_packet, packet
    end
  end

  def send_packet packet
    send_data packet
    send_data 0.chr
  end

  def unbind
    run_callback :unbind
  end
end
