class GroupsController < ApplicationController
  before_action :authorize

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
  end

  def join
    @group = Group.find(params[:id])
    current_user.groups << @group

    current_user.save!

    render layout: false
  end

  def leave
    @group = Group.find(params[:id])
    current_user.groups = current_user.groups - [@group]

    current_user.save!

    render layout: false
  end
end
