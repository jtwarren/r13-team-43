require 'spec_helper'

describe Challenge do
  let(:user) { FactoryGirl.create(:user_with_group) }
  let(:group) { user.groups.first }
  let(:challenge_params) do
    {
      creator: user,
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

  describe '#complete' do
    let(:subject) { FactoryGirl.create(:challenge_active, challenge_params) }

    it 'should add log entry' do
      expect do
        subject.complete(user)
      end.to change(subject.log_entries, :count).by(1)
    end

    it 'should add user to participants' do
      subject.complete(user)

      subject.reload
      expect(subject).to be_participant(user)
    end
  end

  describe '#vote' do
    let(:voter) { FactoryGirl.create(:user, groups: [group]) }

    specify { expect(subject.voted_users).to be_empty }
    specify { expect(subject).to be_inactive }
    specify { expect(subject).to be_allow_vote(voter) }

    it 'should add user to voted users' do
      expect do
        expect(subject.vote(voter)).to eq(true)
      end.to change(subject.voted_users, :count).by(1)

      expect(subject.voted_users).to include(voter)
    end

    it 'should not allow user to vote if he already did' do
      subject.vote(voter)

      expect(subject.vote(voter)).to eq(false)
      expect(subject.allow_vote?(voter)).to be_false
    end

    it 'should not allow user to vote if he created the challenge' do
      subject.stub(:creator) { voter }

      expect(subject).not_to be_allow_vote(voter)
      expect(subject.vote(voter)).to eq(false)
    end

    it 'should add log entry' do
      expect(subject).to be_allow_vote(voter)

      expect do
        subject.vote(voter)
      end.to change(subject.log_entries, :count).by(1)
    end

    it 'should activate challenge if threshold is reached' do
      subject.stub(:activation_threshold) { 1 }

      expect do
        subject.vote(voter)
      end.to change(subject, :status).to('active')

      expect(subject).to be_active
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

  describe '#accept' do
    let(:acceptor) { FactoryGirl.create(:user_with_group) }
    let(:subject) { FactoryGirl.create(:challenge_completed, group: acceptor.groups.first) }
    let(:creator) { subject.participants.first.creator }

    it 'should add a log entry' do
      expect(subject).to be_allow_accept(acceptor, creator)

      expect do
        subject.accept(acceptor, creator)
      end.to change(subject.log_entries, :count).by(1)
    end

    it 'should not allow accepting twice' do
      expect(subject).to be_allow_accept(acceptor, creator)

      subject.accept(acceptor, creator)

      expect(subject).not_to be_allow_accept(acceptor, creator)
    end
  end

  describe '#reject' do
    let(:rejector) { FactoryGirl.create(:user_with_group) }
    let(:subject) { FactoryGirl.create(:challenge_completed, group: rejector.groups.first) }
    let(:creator) { subject.participants.first.creator }

    it 'should add a log entry' do
      expect(subject).to be_allow_reject(rejector, creator)

      expect do
        subject.reject(rejector, creator)
      end.to change(subject.log_entries, :count).by(1)
    end

    it 'should not allow rejecting twice' do
      expect(subject).to be_allow_reject(rejector, creator)

      subject.reject(rejector, creator)

      expect(subject).not_to be_allow_reject(rejector, creator)
    end
  end
end