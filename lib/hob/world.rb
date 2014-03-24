require 'hob/world/paths'

module Hob

  ##
  # Class: World
  #
  # Contains information about deploy environment
  #
  class World

    ##
    # Root path
    #
    # Returns: {Pathname}
    #
    attr_reader :root

    ##
    # Paths object
    #
    # Returns: {Hob::World::Paths}
    #
    attr_reader :paths

    ##
    # Return list of deployed applications
    #
    # Returns: {Array} of application names
    #
    def apps
      Pathname.glob(paths.apps.join('*/')).map{ |dir| dir.basename.to_s.to_sym }
    end

  private

    def initialize(root_path)
      @root  = root_path
      @paths = Paths.new(root)
    end
  end
end
