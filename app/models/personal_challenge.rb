class PersonalChallenge < Challenge
  def finished?
    participants.present? &&
    participants.first.decided?
  end

  def points
    2 * difficulty
  end
end