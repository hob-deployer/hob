require 'spec_helper'

describe Hob::World do
  let(:instance) { described_class.new(root) }

  let(:root) { Pathname.new(__FILE__) }

  describe '#root' do
    subject { instance.root }

    it { expect(subject).to equal(root) }
  end

  describe '#paths' do
    subject { instance.root }

    let(:paths) { class_double('Hob::World::Paths') }

    before do
      stub_const('Hob::World::Paths', paths)
    end

    it 'instantiate paths' do
      expect(paths).to receive(:new).with(root)
      instance
    end
  end

end
