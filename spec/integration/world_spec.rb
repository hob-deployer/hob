require 'spec_helper'

describe Hob::World do
  subject { described_class.new(root) }

  let(:root) { Specs.root.join('fixtures') }

  it 'should list available apps' do
    expect(subject.apps).to contain_exactly(:bar_app, :foo_app)
  end

  it 'should build paths' do
    expect(subject.paths).to be_instance_of(Hob::World::Paths)
    expect(File.exist?(subject.paths.apps)).to be(true)
  end
end
