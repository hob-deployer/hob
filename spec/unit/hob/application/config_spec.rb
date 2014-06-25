require 'spec_helper'

describe Hob::Application::Config do
  let(:instance) { described_class.new(path) }

  describe '.lookup' do
    subject { described_class.lookup(Specs.fixtures.join('apps', 'bar_app')) }

    it { expect(File.exist?(subject)).to be(true) }
  end

  describe '.read' do
    subject { described_class.read(Specs.fixtures.join('apps', 'bar_app', 'repo', 'deploy.yml')) }

    it 'reads config' do
      expect(subject['recipes']).to be_an(Array)
    end

    it 'process erb template' do
      expect(subject['events']['on_restart'][1]).to eql('resque work')
    end
  end

  shared_context 'application config' do
    let(:path)        { Pathname.new('/example/app') }
    let(:config_path) { Pathname.new('/example/app/deploy.yml') }

    before(:each) do
      allow(described_class).to receive(:lookup).with(path).and_return(config_path)
      allow(described_class).to receive(:read).with(config_path).and_return(config)
    end
  end

  describe '.new' do
    include_context 'application config'

    context 'when recipes is not an array' do
      let(:config) do
        { 'recipes' => {} }
      end

      it do
        expect { instance }.to raise_error(Hob::Application::Config::InvalidConfig, 'recipes must be an Array')
      end
    end

    context 'when events is not a hash' do
      let(:config) do
        { 'events' => '' }
      end

      it do
        expect { instance }.to raise_error(Hob::Application::Config::InvalidConfig, 'events must be a Hash')
      end
    end
  end

  describe '#recipes' do
    subject { instance.recipes }

    include_context 'application config'

    context 'when not defined' do
      let(:config) { {} }

      it { expect(subject).to eq([]) }
    end

    context 'when defined' do
      let(:config) do
        {
          'recipes' => [
            'git',
            {
              'nginx' => {
                'host' => 'example.com'
              }
            }
          ]
        }
      end

      it 'returns array of recipes' do
        subject.each do |rec|
          expect(rec).to respond_to(:name)
          expect(rec).to respond_to(:options)
        end
      end

      it 'has recipe without options' do
        expect(subject[0].name).to eql('git')
      end

      it 'has recipe with options' do
        expect(subject[1].name).to    eql('nginx')
        expect(subject[1].options).to eql({ 'host' => 'example.com' })
      end
    end
  end

  describe '#events' do
    subject { instance.events }

    include_context 'application config'

    context 'when not defined' do
      let(:config) { {} }

      it { expect(subject).to eq({}) }
    end

    context 'when defined' do
      let(:config) do
        {
          'events' => {
            'on_checkout' => 'git pull',
            'on_restart'  => 'rake services:restart'
          }
        }
      end

      it { expect(subject[:on_checkout]).to eql(['git pull']) }
    end
  end

end
