require 'spec_helper'

describe Challenge do
  let(:user) { User.create!(email: 'test@test.com') }
  let(:group) { Group.create!(title: 'test group 2') }
  let(:challenge_params) do
    {
      owner: user,
      group: group,
      title: 'just a challenge'
    }
  end

  describe '#create' do
    it 'should add log entry' do
      challenge = nil

      expect do
        challenge = Challenge.create!(challenge_params)
      end.to change(Challenge, :count).by(1)

      expect(challenge.log_entries).to be_present
    end
  end

  describe '#complete_by_user' do
    before do
      @challenge = Challenge.create!(challenge_params)
    end

    it 'should add log entry' do
      expect do
        @challenge.complete_by_user(user)
      end.to change(@challenge.log_entries, :count).by(1)
    end
  end
end