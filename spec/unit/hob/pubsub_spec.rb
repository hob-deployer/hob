require 'spec_helper'

describe Hob::PubSub do
  let(:instance) { described_class.new }

  let(:context)  { double('context').as_null_object }
  let(:callback) { 'rake db:create' }

  describe '#on' do
    before(:each) do
      instance.on('hello', callback, context)
    end

    subject { instance.callbacks['on_hello'].first }

    it { expect(instance.callbacks).to have_key('on_hello') }

    it { expect(subject.callback).to equal(callback) }
    it { expect(subject.context).to  equal(context)  }
  end

  describe '#before' do
    before(:each) do
      instance.before('hello', callback, context)
    end

    subject { instance.callbacks['before_hello'].first }

    it { expect(instance.callbacks).to have_key('before_hello') }

    it { expect(subject.callback).to equal(callback) }
    it { expect(subject.context).to  equal(context)  }
  end

  describe '#after' do
    before(:each) do
      instance.after('hello', callback, context)
    end

    subject { instance.callbacks['after_hello'].first }

    it { expect(instance.callbacks).to have_key('after_hello') }

    it { expect(subject.callback).to equal(callback) }
    it { expect(subject.context).to  equal(context)  }
  end

  describe '#dispatch' do
    before(:each) do
      instance.on('hello', 'c1', context)
      instance.before('hello', 'c2', context)
      instance.after('hello', 'c3', context)
    end

    context 'when event exists' do
      before(:each) do
        instance.dispatch('hello')
      end

      it 'runs callbacks in the right order' do
        expect(context).to have_received(:run).with('c2').ordered
        expect(context).to have_received(:run).with('c1').ordered
        expect(context).to have_received(:run).with('c3').ordered
      end
    end

    context 'when event not exists' do
      before(:each) do
        instance.dispatch('bye')
      end

      it 'does not run anything' do
        expect(context).to_not have_received(:run)
      end
    end
  end

end
