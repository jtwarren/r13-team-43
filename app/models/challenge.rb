class Challenge
  include MongoMapper::Document

  before_create :add_creation_log_entry

  belongs_to :group
  belongs_to :owner, foreign_key: :owner_id, class_name: 'User'
  many :log_entries, class_name: 'ChallengeLogEntry'

  scope :inactive, where(status: 'inactive')
  scope :active, where(status: 'active')
  scope :finished, where(status: 'finished')
  scope :confirmed, where(status: 'confirmed')

  key :title, String, required: true
  key :description, String
  key :status, String, default: 'inactive'

  validates_presence_of :owner
  validates_presence_of :group

  def inactive?
    status == 'inactive'
  end

  # user can participate in this challenge
  def active?
    status == 'active'
  end

  # user clicked 'complete challenge'
  def finished?
    status == 'finished'
  end

  # after another user confirmed the completeness
  def confirmed?
    status == 'confirmed'
  end

  # a user signals that he completed this challenge
  def complete_by_user(user)
    #TODO
    self.log_entries << ChallengeLogEntry.user_completed_challenge(user)

    self.save!
  end

  private

  def add_creation_log_entry
    self.log_entries << ChallengeLogEntry.challenge_created(owner)
  end
end