require 'spec_helper'

describe Hob::Application::Paths do
  let(:instance) { described_class.new(root) }

  let(:root) { Pathname.new('/apps/myapp') }

  describe '#root' do
    subject { instance.root.to_s }

    it { expect(subject).to eql('/apps/myapp') }
  end

  describe '#repo' do
    subject { instance.repo.to_s }

    it { expect(subject).to eql('/apps/myapp/repo') }
  end

  describe '#shared' do
    subject { instance.shared.to_s }

    it { expect(subject).to eql('/apps/myapp/shared') }
  end

  describe '#releases' do
    subject { instance.releases.to_s }

    it { expect(subject).to eql('/apps/myapp/releases') }
  end

  describe '#current' do
    subject { instance.current.to_s }

    it { expect(subject).to eql('/apps/myapp/current') }
  end

  describe '#current_release' do
    subject { instance.current_release.to_s }

    before(:each) do
      allow(Dir).to receive(:entries).with(Pathname.new('/apps/myapp/releases')).and_return(ls)
    end

    context 'when no releases' do
      let(:ls) { %w(. ..) }

      it { expect(subject).to eql('/apps/myapp/releases/0') }
    end

    context 'when releases exists' do
      let(:ls) { %w(. .. 6 8 9 10) }

      it { expect(subject).to eql('/apps/myapp/releases/10') }
    end
  end

  describe '#next_release' do
    subject { instance.next_release.to_s }

    before(:each) do
      allow(Dir).to receive(:entries).with(Pathname.new('/apps/myapp/releases')).and_return(ls)
    end

    context 'when no releases' do
      let(:ls) { %w(. ..) }

      it { expect(subject).to eql('/apps/myapp/releases/1') }
    end

    context 'when releases exists' do
      let(:ls) { %w(. .. 6 8 9 10) }

      it { expect(subject).to eql('/apps/myapp/releases/11') }
    end
  end

  describe '#prev_release' do
    subject { instance.prev_release.to_s }

    before(:each) do
      allow(Dir).to receive(:entries).with(Pathname.new('/apps/myapp/releases')).and_return(ls)
    end

    context 'when no releases' do
      let(:ls) { %w(. ..) }

      it { expect(subject).to eql('/apps/myapp/releases/0') }
    end

    context 'when releases exists' do
      let(:ls) { %w(. .. 6 8 9 10) }

      it { expect(subject).to eql('/apps/myapp/releases/9') }
    end

    context 'when prev release was deleted' do
      let(:ls) { %w(. .. 6 8 10) }

      it { expect(subject).to eql('/apps/myapp/releases/8') }
    end
  end

end
