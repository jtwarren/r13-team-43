require 'spec_helper'

describe ChallengesController do
  render_views

  describe '#create' do
    context 'with valid parameters' do
      let(:user) { FactoryGirl.create(:user_with_group) }

      let(:challenge_params) do
        {
          title: 'Test',
          group_id: user.groups.first.id,
          _type: 'PersonalChallenge',
        }
      end

      before do
        controller.stub(:authorize)
        controller.stub(:current_user) { user }
      end

      it 'should create a challenge and set creator' do
        expect do
          post :create, challenge: challenge_params
        end.to change(Challenge, :count).by(1)

        challenge = Challenge.last
        expect(challenge.creator).to eq(user)
      end
    end
  end

  describe '#vote' do
    before do
      @current_user = FactoryGirl.create(:user_with_group)
      @challenge = FactoryGirl.create(:challenge, group: @current_user.groups.first)

      controller.stub(:authorize)
      controller.stub(:current_user) { @current_user }
    end

    it 'should increase votes of challenge' do
      expect do
        put :vote, challenge_id: @challenge.id, format: :js
        @challenge.reload

        expect(response).to be_success
      end.to change(@challenge, :votes).by(1)
    end
  end
end