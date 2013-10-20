class GroupsController < ApplicationController
  before_action :authorize
  before_action :set_group, only: [:show, :edit, :update, :join, :leave]
  before_action :authenticate, only: [:edit, :update]

  def index
    @groups = Group.all
  end

  def show
    @active_challenges = ChallengeDecorator.decorate_collection(@group.challenges.active.all)
    @inactive_challenges = ChallengeDecorator.decorate_collection(@group.challenges.inactive.all)
  end

  def new
    @group = Group.new(params[:group])
  end

  def create
    attributes = params[:group]
    attributes[:creator] = current_user
    @group = Group.create(attributes)

    # The creator of the group is automatically added to the group.
    @group.add_user(current_user)

    redirect_to groups_path, notice: 'Group successfully created.'
  end

  def edit
  end

  def update
    attributes = params[:group]
    attributes[:updater] = current_user
    @group.update_attributes(attributes)

    redirect_to @group, notice: 'Group successfully updated.'
  end

  def join
    @group.add_user(current_user)

    render layout: false
  end

  def leave
    current_user.groups = current_user.groups - [@group]

    current_user.save!

    render layout: false
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def authenticate
    unless @group.users.include?(current_user)
      redirect_to groups_path, alert: "You are not a group member."
    end
  end
end
