require 'spec_helper'
describe SlackScratcher::Loader::Base do
  subject { SlackScratcher::Loader::Base.new }
  let!(:error) { NotImplementedError }

  it { is_expected.to be_kind_of(SlackScratcher::Loader::Base) }

  specify 'each method is abstract' do
    expect { subject.each }.to raise_error(error)
  end
end
