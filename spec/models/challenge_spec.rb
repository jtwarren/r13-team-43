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
  let(:subject) { FactoryGirl.create(:challenge, challenge_params) }

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

  describe '#vote' do
    specify { subject.voted_users.should be_empty }

    it 'should add user to voted users' do
      expect do
        expect(subject.vote(user)).to eq(true)
      end.to change(subject.voted_users, :count).by(1)

      expect(subject.voted_users).to include(user)
    end

    it 'should not allow user to vote if he already did' do
      subject.vote(user)

      expect(subject.vote(user)).to eq(false)
    end
  end

  describe '#allow_vote?' do
    specify { expect(subject).to be_allow_vote(user) }

    it 'should not be allowed after user voted' do
      expect(subject.vote(user)).to be_true

      expect(subject.allow_vote?(user)).to be_false
    end
  end
end