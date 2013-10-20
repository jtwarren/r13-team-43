class ChallengesController < ApplicationController
  before_action :authorize

  def new
    @challenge = Challenge.new(challenge_params)
  end

  def create
    challenge_type = challenge_params[:_type]
    challenge_type = challenge_type.safe_constantize

    unless challenge_type.ancestors.include?(Challenge)
      raise 'Invalid challenge type selected.'
    end

    challenge = challenge_type.new(challenge_params)

    if challenge.valid?
      challenge.save!

      redirect_to group_path(challenge.group)
    else
      redirect_to group_path(challenge.group), alert: 'Challenge invalid!'
    end
  end

  def vote
    challenge = Challenge.find(params[:id])

    challenge.vote(current_user)
  end

  # user signals that he completed the challenge
  def complete
    challenge = Challenge.find(params[:id])

    challenge.complete(current_user)
  end

  # user signals that someone completed the challenge
  def accept
    @challenge = Challenge.find(params[:id])
    @creator = User.find(params[:user_id])

    if @challenge.allow_accept?(current_user, @creator)
      @challenge.accept(current_user, @creator)
    else
      render text: 'invalid challenge or user', status: :not_accepted
    end
  end

  def reject
    @challenge = Challenge.find(params[:id])
    @creator = User.find(params[:user_id])

    if @challenge.allow_reject?(current_user, @creator)
      @challenge.reject(current_user, @creator)
    else
      render text: 'invalid challenge or user', status: :not_accepted
    end
  end

  private

  def challenge_params
    params.require(:challenge).permit(
      :title,
      :description,
      :group_id,
      :_type,
      :due_date,
      :difficulty
    ).merge({
      creator: current_user,
    })
  end
end
