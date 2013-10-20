class CompletionWorkflow
  include MongoMapper::EmbeddedDocument

  timestamps!

  # creator: user who completed the challenge
  belongs_to :creator, class_name: 'User'
  validates_presence_of :creator

  many :rejectors, in: :rejectors_ids, class_name: 'User'
  key :rejectors_ids, Set

  many :acceptors, in: :acceptors_ids, class_name: 'User'
  key :acceptors_ids, Set

  def available_for?(user)
    !acceptors.include?(user) &&
    !rejectors.include?(user) &&
    creator != user
  end

  def accepted?(user)
    acceptors.include?(user)
  end

  # another user approves that the creator completed the challenge
  def accept(user)
    self.acceptors << user
    self.save!
  end

  def rejected?(user)
    rejectors.include?(user)
  end

  # another user approves that the creator completed the challenge
  def reject(user)
    self.rejectors << user
    self.save!
  end
end