class SingleChallenge < Challenge
  def finished?
    participants.present? &&
    participants.first.decided?
  end

  def points
    3 * difficulty
  end
end