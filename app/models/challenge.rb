class Challenge
  include MongoMapper::Document

  before_create :add_creation_log_entry

  belongs_to :group
  many :log_entries, class_name: 'ChallengeLogEntry'

  belongs_to :owner, foreign_key: :owner_id, class_name: 'User'

  key :title, String, required: true
  key :description, String

  validates_presence_of :owner
  validates_presence_of :group
  validates_presence_of :title

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