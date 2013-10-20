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
    challenge = Challenge.find(params[:challenge_id])

    challenge.vote(current_user)
  end

  # user signals that he completed the challenge
  def complete
    challenge = Challenge.find(params[:id])

    challenge.complete_by_user(current_user)
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
