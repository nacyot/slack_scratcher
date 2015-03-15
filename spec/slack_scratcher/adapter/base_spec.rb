require 'spec_helper'

describe SlackScratcher::Adapter::Base do
  subject { SlackScratcher::Adapter::Base.new }
  let!(:error) { NotImplementedError }

  it { is_expected.to be_kind_of(SlackScratcher::Adapter::Base) }

  specify 'store method is abstract' do
    expect { subject.store }.to raise_error(error)
  end

  specify 'ready_index method is abstract' do
    expect { subject.ready_index }.to raise_error(error)
  end

  specify 'timestamp_of_last_channel_log method is abstract' do
    expect { subject.timestamp_of_last_channel_log }.to raise_error(error)
  end
end
