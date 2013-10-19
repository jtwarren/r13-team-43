require 'spec_helper'

describe Transaction do
  let(:user) { User.create!(email: 'test@test.de', points: 100) }
  let(:challenge) { Challenge.create!() }
  let(:points) { 5 }

  describe '#update_user_points' do
    it 'should update users total' do
      expect do
        Transaction.update_user_points(user, challenge, points)
        user.reload
      end.to change(user, :points).by(points)
    end

    it 'should create transaction record' do
      transaction = nil

      expect do
        transaction = Transaction.update_user_points(user, challenge, points)
      end.to change(Transaction, :count).by(1)

      expect(transaction.user).to eq(user)
      expect(transaction.challenge).to eq(challenge)
      expect(transaction.points).to eq(points)
      expect(transaction.total_points).to eq(user.points)

      expect(user.transactions).to be_present
      expect(user.transactions.count).to eq(1)
    end
  end
end