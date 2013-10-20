class TopChallenge < Challenge
  key :limit, Integer, default: 3

  def finished?
    participants.present? &&
    accepted_participants.count == limit
  end

  def points
    1 * difficulty
  end

  private

  def accepted_participants
    participants.select do |workflow|
      workflow.accepted?
    end
  end
end