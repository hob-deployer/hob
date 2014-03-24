module Hob
  class World

    ##
    # Class: World paths
    #
    # Paths to main deployment folders
    #
    class Paths
      ##
      # Root folder
      #
      # Returns: {Pathname} path to the deploy folder
      #
      attr_reader :root

      ##
      # Apps folder
      #
      # Returns: {Pathname} path to the apps folder
      #
      attr_reader :apps

      ##
      # Recipes folder
      #
      # Returns: {Pathname} path to the folder with custom recipes
      #
      attr_reader :recipes

      ##
      # Get path to application by name
      #
      # Params:
      # - app_name {String|Symbol} application name
      #
      # Returns: {Pathname} path to application
      #
      def app(app_name)
        apps.join(app_name.to_s)
      end

    private

      def initialize(root_path)
        @root    = root_path
        @apps    = root_path.join('apps')
        @recipes = root_path.join('recipes')

        freeze
      end

    end
  end
end
