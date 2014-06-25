require 'hob/application/paths'
require 'hob/application/config'

module Hob
  ##
  # Class: Application settings
  #
  class Application

    ##
    # Application name
    #
    # Returns: {Symbol}
    #
    attr_reader :name

    ##
    # Application root folder
    #
    # Returns: {Pathname}
    #
    attr_reader :root

    ##
    # Application paths
    #
    # Returns: {Hob::Application::Paths}
    #
    attr_reader :paths

    ##
    # Application configuration
    #
    # Returns: {Hob::Application::Config}
    #
    def config
      Config.new(paths.repo)
    end

  private

    ##
    # Constructor
    #
    # Params:
    # - name {String|Symbol} application name
    #
    def initialize(name)
      @name  = name.to_sym
      @root  = Hob.world.paths.app(name)
      @paths = Paths.new(root)
    end

  end
end
