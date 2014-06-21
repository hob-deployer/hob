require 'yaml'
require 'bundler/setup'

class Metrics < Thor
  desc 'all', 'Run all metrics'
  def all
    mutant
    lint
    smells
    coverage(nil, true)
  end

  desc 'coverage [TYPE]', 'Generate code coverage'
  def coverage(type=nil, cli=false)
    ENV['COVERAGE'] = 'true'
    system "rspec spec/#{type}"

    if !cli && system('which open')
      `open coverage/index.html`
    end
  end

  desc 'mutant [NAMESPACE]', 'Run mutation tests for NAMESPACE'
  def mutant(namespace=nil)
    begin
      require 'mutant'
    rescue LoadError, NotImplementedError => e
      puts e
      return false
    end

    config = config_for('mutant')

    namespaces = (namespace ? [namespace] : config['include'])

    score = config.has_key?('min_score') ? ['--score', config['min_score'].to_s] : []

    ignores = config.has_key?('exclude') ? config['exclude'].map { |n| "::#{n}" } : []
    ignores = ignores.map { |n| ['--ignore-subject', n] }.flatten

    Mutant::CLI.run([
      '--include', 'lib',
      '--require', 'hob',
      *score,
      *ignores,
      '--use', 'rspec',
      *namespaces
    ])
  end

  desc 'lint', 'Check with code style guide'
  def lint
    begin
      require 'rubocop'
    rescue LoadError, NotImplementedError => e
      puts e
      return false
    end

    config_file = path_to_config('rubocop')

    Rubocop::CLI.new.run(%W[--config #{config_file}])
  end

  desc 'smells', 'Detect code smells with Reek'
  def smells
    begin
      require 'reek/cli/application'
    rescue LoadError => e
      puts e
      return false
    end

    opts = ['--config', path_to_config('reek'), 'app', 'lib']

    Reek::Cli::Application.new(opts).execute
  end

private

  def config_for(tool)
    file = path_to_config(tool)
    YAML.load_file(file)
  end

  def path_to_config(tool)
    File.expand_path("../etc/metrics/#{tool}.yml", File.dirname(__FILE__))
  end
end
