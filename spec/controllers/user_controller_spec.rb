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

      it 'should render new' do
        post :create, :user => user_params
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

end

