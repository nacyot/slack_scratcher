require 'spec_helper'

describe SlackScratcher::Loader::Api do
  let(:api) { SlackScratcher::Loader::Api.new }

  before(:each) do
    # users = { members: [{ id: 'U12345', name: 'nacyot' }] }
    # allow(Slack).to receive(:users).and_return(users)
  end

  describe '#initalize' do
    it "doesn't require any argument" do
      expect { api }.to_not raise_error
    end
  end

  describe '#each' do
    
  end
end
