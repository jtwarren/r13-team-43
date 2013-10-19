class ChallengesController < ApplicationController
  before_action :authorize

  def create
    challenge = Challenge.new(challenge_params)

    if challenge.valid?
      challenge.save!

      redirect_to group_path(challenge.group)
    else
      redirect_to group_path(challenge.group), alert: 'Challenge invalid!'
    end
  end

  # user signals that he completed the challenge
  def complete
    challenge = Challenge.find(params[:id])

    challenge.complete_by_user(current_user)
  end

  private

  def challenge_params
    params.require(:challenge).permit(:title, :group_id).merge({
      owner: current_user,
    })
  end
end
