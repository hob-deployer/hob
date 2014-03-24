require 'spec_helper'

describe Hob::World::Paths do
  let(:instance) { described_class.new(root) }

  let(:root) { Pathname.new('/tmp') }

  describe '#root' do
    subject { instance.root.to_s }

    it { expect(subject).to eql('/tmp') }
  end

  describe '#apps' do
    subject { instance.apps.to_s }

    it { expect(subject).to eql('/tmp/apps') }
  end

  describe '#recipes' do
    subject { instance.recipes.to_s }

    it { expect(subject).to eql('/tmp/recipes') }
  end

  describe '#app' do
    subject { instance.app(name).to_s }

    let(:name) { 'myapp' }

    it { expect(subject).to eql('/tmp/apps/myapp') }
  end

end
