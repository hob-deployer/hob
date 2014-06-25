module Hob
  class Application
    class Config

      ##
      # Exception which will be raised when config is invalid
      #
      InvalidConfig = Class.new(StandardError)

      ##
      # Class: recipe structure
      #
      Recipe = Struct.new(:name, :options)

      class << self

        ##
        # Static: lookup for config file
        #
        # Params:
        # - path {Pathname} path to directory which contains config file
        #
        # Returns: {Pathname} full real path to config file
        #
        def lookup(path)
          Dir[path.join('**', 'deploy.yml')].first
        end

        ##
        # Static: read configuration file
        # Read file, apply ERB tags and convert from YAML
        #
        # Params:
        # - file {Pathname} real path to configuration file
        #
        # Returns: {Hash} configuration
        #
        def read(file)
          plain   = File.read(file)
          content = ERB.new(plain).result

          YAML.load(content)
        end
      end

      ##
      # Config retrieved from the file
      #
      # Returns: {Hash}
      #
      def raw_config
        @config
      end

      ##
      # List of used recipes
      #
      # Returns: {Array(Hob::Application::Config::Recipe)}
      #
      attr_reader :recipes

      ##
      # Inline event handlers
      #
      # Returns: {Hash}
      #
      attr_reader :events

    private

      ##
      # Constructor:
      #
      # Params:
      # - path {Pathname} path to directory where config file should be placed
      #
      def initialize(path)
        @file    = self.class.lookup(path)
        @config  = self.class.read(@file)
        @recipes = []
        @events  = {}

        validate_config

        read_recipes
        read_events
      end

      ##
      # Private: validate config
      #
      # Raises: {Hob::Application::Config::InvalidConfig}
      #
      def validate_config
        if @config.has_key?('recipes')
          fail InvalidConfig, 'recipes must be an Array' unless @config['recipes'].kind_of?(Array)
        end

        if @config.has_key?('events')
          fail InvalidConfig, 'events must be a Hash' unless @config['events'].kind_of?(Hash)
        end
      end

      ##
      # Private: read and normalize recipes data and options
      #
      # It iterates over recipes array and make a Recipe structs.
      # If array member is a string – it creates recipe with only name
      # and empty hash for options. If array member is a {Hash} – it
      # iterates over keys and values, each key will be a recipe name
      # and values will be a recipe options.
      #
      def read_recipes
        return unless @config.has_key?('recipes')

        @config['recipes'].each do |recipe|
          if recipe.is_a?(String)
            @recipes << Recipe.new(recipe, {})
          elsif recipe.is_a?(Hash)
            recipe.each_pair { |k, v| @recipes << Recipe.new(k, v) }
          end
        end
      end

      ##
      # Private: read and normalize events data
      #
      # Events data keys must be a symbols and values must be
      # an Arrays of strings
      #
      def read_events
        return unless @config.has_key?('events')

        @config['events'].each_pair do |event, actions|
          @events[event.to_sym] = Array(actions)
        end
      end

    end
  end
end
