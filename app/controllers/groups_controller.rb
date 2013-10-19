class GroupsController < ApplicationController
  before_action :authorize

  def show
    @group = Group.find(params[:id])
  end
end
