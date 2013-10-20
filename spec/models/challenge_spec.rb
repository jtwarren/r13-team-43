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

    it 'should add log entry' do
      expect do
        subject.vote(user)
      end.to change(subject.log_entries, :count).by(1)
    end

    it 'should activate challenge if threshold is reached' do
      subject.stub(:activation_threshold) { 1 }

      expect do
        subject.vote(user)
      end.to change(subject, :status).to('active')

      expect(subject).to be_active
    end
  end

  describe '#allow_vote?' do
    specify { expect(subject).to be_allow_vote(user) }

    it 'should not be allowed after user voted' do
      expect(subject.vote(user)).to be_true

      expect(subject.allow_vote?(user)).to be_false
    end
  end

  describe '#activation_threshold' do
    before do
      group.stub_chain(:users, :count) { 90 }
    end

    it 'should set threshold based on user count' do
      # 20% of 90 = 18
      expect(subject.activation_threshold).to eq(18)
    end

    it 'should set threshold to at least 1' do
      group.stub_chain(:users, :count) { 0 }

      expect(subject.activation_threshold).to eq(1)
    end
  end
end