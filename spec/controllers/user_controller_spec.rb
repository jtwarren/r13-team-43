require 'spec_helper'

describe UsersController do
  render_views

  describe '#create' do
    context 'with invalid parameters' do
      let(:user_params) do
        {
          email: 'badtest@example.com',
          password: 'some_password',
          password_confirmation: 'some_other_password'
        }
      end

      it 'should redirect to root url' do
        # usually this spec should fail but in JUDGE_MODE we will
        # allow signups with any password
        post :create, :user => user_params
        response.should redirect_to(root_url)
      end

      it 'should allow registration without password' do
        post :create, user: user_params.slice(:email)
        response.should redirect_to(root_url)
      end

      it 'should not allow registration without email' do
        post :create, user: { email: ''}
        response.should render_template('new')
      end
    end

    context 'with valid parameters' do
      let(:user_params) do
        {
          email: 'goodtest@example.com',
          password: 'same_password',
          password_confirmation: 'same_password'
        }
      end

      it 'should create new user' do
        post :create, :user => user_params
        created_user = User.find_by_email(user_params[:email])
        created_user.should be_present
      end

      it 'should redirect to root_url' do
        post :create, :user => user_params
        response.should redirect_to(root_url)
      end
    end
  end

  describe '#destroy' do
    let(:user_params) do
      {
        email: 'test@test.de',
      }
    end

    before do
      @current_user = User.create!(user_params)

      controller.stub(:authorize)
      controller.stub(:current_user) { @current_user }
    end

    it 'should delete current user' do
      post :destroy, id: @current_user.id

      response.should redirect_to(root_url)
      expect{ @current_user.reload }.to raise_error(MongoMapper::DocumentNotFound)
    end

    it 'should not delete other users' do
      other_user = User.create!({ email: 'user2@internet.net' })

      post :destroy, id: other_user.id
      response.should redirect_to(root_url)
      expect{ other_user.reload }.not_to raise_error
    end
  end
end

