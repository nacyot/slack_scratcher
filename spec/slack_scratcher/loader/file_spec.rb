require 'spec_helper'

describe SlackScratcher::Loader::File do
  # Setup external data

  before(:each) do
    users_file = '[{"id": "UEHJ8EK18","name": "nacyot"}]'
    channels_file = '[{"id": "CEHJ8EK18","name": "general"}]'
    log_file = '[{ "user": "U03O" }, { "user": "U03O" }]'
    channel_dirs = ['/general/']
    log_files = ['/general/2015-03-15.json', '/general/2015-03-16.json']

    allow(File).to receive(:read).with(/users.json/) { users_file }
    allow(File).to receive(:read).with(/channels.json/) { channels_file }
    allow(File).to receive(:exist?).with(/json$/) { true }
    allow(File).to receive(:read).with(/2015-03/) { log_file }
    allow(Dir).to receive(:[]).with('/*/') { channel_dirs }
    allow(Dir).to receive(:[]).with(/\*\.json/) { log_files }
  end

  # Public methods

  describe '#initialize' do
    let(:wrong_dir) { '3279#@%y.,oud' }
    let(:dir) { '/' }

    it 'requires dir argument' do
      target = SlackScratcher::Loader::File
      error = ArgumentError

      expect { target.new(wrong_dir) }.to raise_error(error)
      expect { target.new(dir) }.to_not raise_error
    end
  end

  describe '#each' do
    # Mock up chats model
    before(:each) do
      chats_class = SlackScratcher::Model::Chats
      chats_mock = double('chats')
      refined_data = [{ 'text' => 'chat1', 'user' => 'U03O' }]
      allow(chats_class).to receive(:new).and_return(chats_mock)
      allow(chats_mock).to receive(:refined_data).and_return(refined_data)
      allow(chats_mock).to receive(:is_a?).and_return(true)
    end

    let(:file) { SlackScratcher::Loader::File.new('/') }

    it 'respond to each and map' do
      expect(file).to respond_to(:each, :map)
    end

    it 'can transform logs' do
      expect(file.map { |log| log[0]['user'] }).to eq(%w(U03O U03O))
    end

    it "retuns true when there isn't any problem" do
      expect(file.each {}).to eq(true)
    end
  end
end
