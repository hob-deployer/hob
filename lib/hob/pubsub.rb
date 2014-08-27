module Hob

  ##
  # Class: Event bus for recipes
  #
  class PubSub

    ##
    # Class: Event listener structure
    #
    Listener = Struct.new(:callback, :context)

    attr_reader :callbacks

    ##
    # Add before callback
    #
    # Params:
    # - event    {String} name of the event
    # - callback          callback to run
    # - context           context for execution, normally `Recipe`
    #
    def before(event, callback, context)
      add_callback("before_#{event}", callback, context)
    end

    ##
    # Add callback
    #
    # Params:
    # - event    {String} name of the event
    # - callback          callback to run
    # - context           context for execution, normally `Recipe`
    #
    def on(event, callback, context)
      add_callback("on_#{event}", callback, context)
    end

    ##
    # Add after callback
    #
    # Params:
    # - event    {String} name of the event
    # - callback          callback to run
    # - context           context for execution, normally `Recipe`
    #
    def after(event, callback, context)
      add_callback("after_#{event}", callback, context)
    end

    ##
    # Dispatch events
    #
    # Params:
    # - event {String} name of event
    #
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

    ##
    # Constructor:
    #
    def initialize
      @callbacks = Hash.new { |h, k| h[k] = [] }
    end

    ##
    # Add callback backend
    #
    # Params:
    # - event    {String} name of the event with the prefix on_*/before_*/after_*
    # - callback          callback to run
    # - context           context for execution, normally `Recipe`
    #
    def add_callback(name, callback, context)
      callbacks[name] << Listener.new(callback, context)
    end
  end
end
