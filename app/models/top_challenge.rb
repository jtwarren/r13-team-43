class TopChallenge < Challenge
  def accepted_count
    accepted_participants.count
  end

  def finished?
    participants.present? &&
    accepted_participants.count == limit
  end

  def points
    1 * difficulty
  end

  def limit
    value = (group.users.count * 0.4).to_i

    [value, 1].max
  end

  private

  def accepted_participants
    participants.select do |workflow|
      workflow.accepted?
    end
  end
end
