require 'spec_helper'

describe Challenge do
  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }
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

    it 'should be inactive' do
      expect(Challenge.create!(challenge_params)).to be_inactive
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