require 'spec_helper'

describe Group do
  describe '#users' do
    let(:group) { Group.create }
    let(:users) { [User.create(email: 'test@test.com'), User.create(email: 'test2@test.com')] }

    it 'has many users' do
      users.each do |user|
        user.groups << group
        user.save!
      end

      group.users.should include(*users)
    end
  end
end
