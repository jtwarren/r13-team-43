class PersonalChallenge < Challenge
  belongs_to :target_user, class_name: 'User'

  validates_presence_of :target_user

  def allow_completion?(user)
    super(user) &&
    target_user == user
  end

  def finished?
    participants.present? &&
    participants.first.decided?
  end

  def points
    2 * difficulty
  end
end