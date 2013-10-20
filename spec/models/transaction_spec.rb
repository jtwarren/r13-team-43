require 'spec_helper'

describe Transaction do
  let(:user) { FactoryGirl.create :user }
  let(:challenge) { FactoryGirl.create :challenge, creator: user }
  let(:points) { 5 }

  describe '#update_user_points' do
    it 'should update users total' do
      old_points = user.points(challenge.group)

      Transaction.update_user_points(user, challenge, points)
      user.reload

      expect(user.points(challenge.group)).to be(old_points + points)
    end

    it 'should create transaction record' do
      transaction = nil

      expect do
        transaction = Transaction.update_user_points(user, challenge, points)
      end.to change(Transaction, :count).by(1)

      expect(transaction.user).to eq(user)
      expect(transaction.challenge).to eq(challenge)
      expect(transaction.points).to eq(points)

      expect(user.transactions).to be_present
      expect(user.transactions.count).to eq(1)
    end
  end
end
