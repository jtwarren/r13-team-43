class Challenge
  include MongoMapper::Document

  before_create :add_creation_log_entry
  before_create :set_activation_threshold

  userstamps!
  belongs_to :group
  many :log_entries, class_name: 'ChallengeLogEntry'

  scope :inactive, where(status: 'inactive')
  scope :active, where(status: 'active')
  scope :finished, where(status: 'finished')
  scope :confirmed, where(status: 'confirmed')

  key :title, String, required: true
  key :description, String
  key :_type, String
  key :status, String, default: 'inactive'
  key :activation_threshold, Integer, default: 1

  key :difficulty, Integer, default: 2
  key :due_date, Time, default: -> { 10.days.from_now }

  many :voted_users, in: :voted_users_ids, class_name: 'User'
  key :voted_users_ids, Set

  validates_presence_of :creator
  validates_presence_of :group

  # mapping between internal type and human readable presentation
  def type_options
    {
      'Top X' => 'TopChallenge',
      'Single' => 'SingleChallenge',
      'Personal' => 'PersonalChallenge',
    }
  end

  # mapping between internal difficulty and human readable presentation
  def difficulty_options
    {
      'easy' => 1,
      'medium' => 2,
      'hard' => 3,
    }
  end

  def points
    raise NotImplementedError
  end

  def votes
    voted_users.count
  end

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

  def allow_vote?(user)
    inactive? &&
    !self.voted_users.include?(user) &&
    user.groups.include?(self.group) &&
    user != creator
  end

  # when a user votes for this challenge
  def vote(voter)
    if allow_vote?(voter)
      self.voted_users << voter
      self.log_entries << ChallengeLogEntry.user_voted_challenge(voter)

      check_activation_threshold
      save!

      true
    else
      false
    end
  end

  # a user signals that he completed this challenge
  def complete_by_user(user)
    #TODO
    self.log_entries << ChallengeLogEntry.user_completed_challenge(user)

    self.save!
  end

  private

  def activate
    self.status = 'active'

    ChallengeLogEntry.challenge_activated()
  end

  def add_creation_log_entry
    self.log_entries << ChallengeLogEntry.challenge_created(creator)
  end

  def set_activation_threshold
    threshold = (group.users.count * 0.2).to_i

    if threshold == 0
      threshold = 1
    end

    self.activation_threshold = threshold
  end

  def check_activation_threshold
    if votes >= activation_threshold
      activate
    end
  end
end
