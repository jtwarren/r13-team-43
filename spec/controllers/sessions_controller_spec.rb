require 'spec_helper'

describe SessionsController do
  render_views

  describe '#create' do
    context 'with present user' do
      let(:user_params) do
        {
          email: 'badtest@example.com',
        }
      end

      before do
        FactoryGirl.create(:user, user_params)
      end

      it 'should redirect to root url' do
        # usually this spec should fail but in JUDGE_MODE we will
        # allow signups with any password
        post :create, user_params
        response.should redirect_to(root_url)
      end

      it 'should allow login without password' do
        post :create, user_params.slice(:email)
        response.should redirect_to(root_url)
      end

      it 'should not allow login without email' do
        post :create, { email: '' }
        response.should_not be_redirect
        response.should render_template('new')
      end
    end

    context 'without registration' do
      let(:user_params) do
        {
          email: 'goodtest@example.com',
        }
      end

      it 'should create new user' do
        post :create, user_params
        created_user = User.find_by_email(user_params[:email])
        created_user.should be_present
      end

      it 'should redirect to root_url' do
        post :create, user_params
        response.should redirect_to(root_url)
      end
    end
  end

end

