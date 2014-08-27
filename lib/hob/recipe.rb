module Hob
  class Recipe
    def run(callback)
      if callback.is_a?(Symbol)
        self.send(callback)
      elsif callback.is_a?(String)
        Shell::Command.new(callback, { chdir: paths.current.to_s })
      else
        self.instance_exec(&callback)
      end
    end
  end
end
