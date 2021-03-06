require 'spec_helper'

describe User do
  describe '#groups' do
    let(:user) { FactoryGirl.create(:user) }
    let(:groups) { FactoryGirl.create_list(:group, 2) }

    it 'has many groups' do
      user.groups += groups

      user.save!

      user.groups.should include(*groups)
    end

    it 'allows only unique groups' do
      user.groups << groups.first
      user.groups << groups.first

      user.save!

      user.groups.should eq([groups.first])
    end
  end
end
