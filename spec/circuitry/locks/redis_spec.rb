require 'spec_helper'

RSpec.describe Circuitry::Locks::Redis, type: :model do
  subject { described_class.new(soft_ttl: soft_ttl, hard_ttl: hard_ttl, client: client) }

  let(:soft_ttl) { 30 }
  let(:hard_ttl) { 60 }
  let(:client) { MockRedis.new }

  before do
    client.flushdb
  end

  it_behaves_like 'a lock'

  describe '.new' do
    subject { described_class }

    describe 'when client is provided' do
      let(:options) { { soft_ttl: soft_ttl, hard_ttl: hard_ttl, client: client } }

      it 'does not create a new client' do
        expect(Redis).to_not receive(:new)
        subject.new(options)
      end
    end

    describe 'when client is not provided' do
      let(:options) { { soft_ttl: soft_ttl, hard_ttl: hard_ttl } }

      it 'creates a new client' do
        expect(Redis).to receive(:new).with(options)
        subject.new(options)
      end
    end
  end
end
