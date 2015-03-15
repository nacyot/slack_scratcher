require 'spec_helper'

describe SlackScratcher::Adapter::Elasticsearch do
  let(:metadata) { { index: 'index', type: 'type' } }

  let(:client) do
    mock = double('Elasticsearch Client')
    allow(mock).to receive(:bulk) { {} }
    mock
  end

  let(:adapter) do
    adapter = SlackScratcher::Adapter::Elasticsearch.new([], metadata)
    allow(adapter).to receive(:client).and_return(client)
    adapter
  end

  # Public methods

  describe '#initalize' do
    it 'requires host and metadata arguments' do
      target = SlackScratcher::Adapter::Elasticsearch
      error = ArgumentError

      expect { target.new }.to raise_error(error)
      expect { target.new([], {}) }.to raise_error(error)
      expect { target.new([], metadata) }.not_to raise_error
    end
  end

  describe '#store' do
    it 'returns client response when there are data' do
      expect(adapter.store(%w(data))).to be_kind_of(Hash)
    end

    it 'returns false when data is empty' do
      expect(adapter.store([])).to be_falsey
    end

    it "returns false when client's bulk method fail" do
      allow(client).to receive(:bulk) do
        fail Elasticsearch::Transport::Transport::Errors::BadRequest
      end

      expect(adapter.store(%w(data))).to be_falsey
    end
  end

  describe '#ready_index' do
    it 'create index and returns true when there is not index' do
      allow(client).to receive_message_chain(:indices, :exists) { false }
      allow(client).to receive_message_chain(:indices, :create) { true }
      allow(client).to receive_message_chain(:indices, :put_mapping) { true }

      expect(adapter).to receive(:create_index).and_call_original
      expect(adapter).to receive(:put_mapping).and_call_original
      expect(adapter.ready_index).to be_truthy
    end

    it 'just reutrns true when there is already index' do
      allow(client).to receive_message_chain(:indices, :exists) { true }

      expect(adapter).not_to receive(:create_index)
      expect(adapter).not_to receive(:put_mapping)
      expect(adapter.ready_index).to be_truthy
    end
  end

  describe '#timestamp_of_last_channel_log' do
    it 'returns zero when any log found' do
      allow(client).to receive(:search) { { 'hits' => { 'total' => 0 } } }
      expect(adapter.timestamp_of_last_channel_log('general')).to eq('0')
    end

    it 'returns timestamp when log founded' do
      time = Time.now.to_i
      response = { 'hits' => { 'hits' => [{ '_source' => { 'ts' => time } }] } }
      allow(client).to receive(:search) { response }

      expect(adapter.timestamp_of_last_channel_log('general')).not_to eq('0')
    end
  end
end
