class ChallengesController < ApplicationController
  before_action :authorize

  def create
    challenge = Challenge.new(challenge_params)

    if challenge.valid?
      redirect_to group_path(challenge.group), notice: 'Challenge creation pending!'
    else
      redirect_to group_path(challenge.group), alert: 'Challenge invalid!'
    end
  end

  private

  def challenge_params
    params.require(:challenge).permit(:title, :group_id)
  end
end
