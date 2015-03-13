require 'spec_helper'

describe SlackScratcher::Loader::File do
  before :each do
    allow(File).to receive(:read) do
      '[{"id": "GEHJ8EK18","name": "nacyot"}]'
    end
  end

  describe 'Initialize object' do
    it 'requires dir argument - fail example' do
      target = '3279#@%y.,oud'
      expect do
        SlackScratcher::Loader::File.new(target)
      end.to raise_error(ArgumentError)
    end

    it 'requires dir argument - success example' do
      target = '/'
      expect do
        SlackScratcher::Loader::File.new(target)
      end.to_not raise_error
    end
  end

  describe 'File is Enumerable' do
    let(:file) { SlackScratcher::Loader::File.new('/') }

    before :each do
      allow(file).to receive(:files) do
        ["/general/2015-03-15.json", "/general/2015-03-16.json"]
      end

      # TODO: deprecated
      allow(file).to receive(:parse_log_file) do
        {
          user: 'U03O',
          type: 'message',
          text: '\uac15\uc81c \uc0ac\uc9c4 \uacf5\uac1c?',
          ts: '1421302869.000002'
        }
      end

      allow(file).to receive(:load_users) do
        { '1' => { name: 'name1' }, '2' => { 'name' => 'name2' } }
      end
    end

    it 'respond to each and map' do
      expect(file).to respond_to(:each, :map)
    end

    it 'can transform logs' do
      expect(file.map { |log| log[:user] }).to eq(%w(U03O U03O))
    end
  end
end
