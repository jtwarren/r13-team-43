class PersonalChallenge < Challenge
  def points
    2 * difficulty
  end
end