module Hob
  class PubSub

    Listener = Struct.new(:callback, :context)

    attr_reader :callbacks

    def before(event, callback, context)
      add_callback("before_#{event}", callback, context)
    end

    def on(event, callback, context)
      add_callback("on_#{event}", callback, context)
    end

    def after(event, callback, context)
      add_callback("after_#{event}", callback, context)
    end

    def dispatch(event)
      %W(before_#{event} on_#{event} after_#{event}).each do |ev|
        stack = callbacks[ev]

        next if stack.empty?

        stack.each do |listener|
          listener.context.run(listener.callback)
        end
      end
    end

  private

    def initialize
      @callbacks = Hash.new { |h, k| h[k] = [] }
    end

    def add_callback(name, callback, context)
      callbacks[name] << Listener.new(callback, context)
    end
  end
end
