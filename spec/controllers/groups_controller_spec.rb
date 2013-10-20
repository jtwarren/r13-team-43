require 'spec_helper'

describe GroupsController do
  render_views

  describe '#create' do
    context 'with valid parameters' do
      let(:user) { FactoryGirl.create(:user) }

      let(:group_params) do
        {
          name: 'Test',
          description: 'Test Description',
        }
      end

      before do
        controller.stub(:authorize)
        controller.stub(:current_user) { user }
      end

      it 'should create a group, set creator and add user to the group' do
        expect(Group.count).to be(0)

        expect do
          post :create, group: group_params
        end.to change(Group, :count).by(1)

        user.reload

        group = Group.first
        expect(group.creator).to eq(user)
        expect(user.groups).to include(group)
      end
    end
  end
end
