require 'spec_helper'

describe Group do
  describe '#users' do
    let(:group) { FactoryGirl.create :group }
    let(:users) { FactoryGirl.create_list(:user, 2) }

    it 'has many users' do
      users.each do |user|
        user.groups << group
        user.save!
      end

      group.users.should include(*users)
    end
  end
end
