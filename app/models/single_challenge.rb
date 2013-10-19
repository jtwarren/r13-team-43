class SingleChallenge < Challenge
  def points
    3 * difficulty
  end
end