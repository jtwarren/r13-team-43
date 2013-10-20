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

  key :title, String, required: true
  key :description, String
  key :_type, String
  key :status, String, default: 'inactive'
  key :activation_threshold, Integer, default: 1

  key :difficulty, Integer, default: 2
  key :due_date, Time, default: -> { 10.days.from_now }

  many :voted_users, in: :voted_users_ids, class_name: 'User'
  key :voted_users_ids, Set

  # users that completed the challenge
  many :participants, in: :participants_ids, class_name: 'CompletionWorkflow'

  validates_presence_of :creator
  validates_presence_of :group

  def self.reviews_for(group, user)
    active.where(group_id: group.id).select do |challenge|
      challenge.open_completion_workflow_for?(user)
    end
  end

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

  def allow_completion?(user)
    active? &&
    workflow_for_user(user).nil? &&
    user.groups.include?(self.group)
  end

  def allow_vote?(user)
    inactive? &&
    !self.voted_users.include?(user) &&
    user.groups.include?(self.group) &&
    user != creator
  end

  # acceptor: user who confirms
  # user: user who claimed the challenge
  def allow_accept?(acceptor, participant_user)
    allow_workflow?(acceptor, participant_user)
  end

  # rejector: user who rejects
  # user: user who claimed  the challenge
  def allow_reject?(rejector, participant_user)
    allow_workflow?(rejector, participant_user)
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
  def complete(user)
    if allow_completion?(user)
      workflow = CompletionWorkflow.new
      workflow.creator = user

      self.participants << workflow
      self.log_entries << ChallengeLogEntry.user_completed_challenge(user)

      self.save!
    else
      false
    end
  end

  # a user signals that another one completed this challenge
  def accept(acceptor, participant_user)
    if allow_accept?(acceptor, participant_user)
      workflow = workflow_for_user(participant_user)

      workflow.accept(acceptor)
      self.log_entries << ChallengeLogEntry.user_accepted_workflow(acceptor, participant_user)

      if workflow.accepted?
        Transaction.update_user_points(participant_user, self, points)
      end

      finish if finished?

      self.save!
    else
      false
    end
  end

  # a user signals that another one completed this challenge
  def reject(rejector, participant_user)
    if allow_reject?(rejector, participant_user)
      workflow = workflow_for_user(participant_user)

      workflow.reject(rejector)
      self.log_entries << ChallengeLogEntry.user_rejected_workflow(rejector, participant_user)

      self.save!
    else
      false
    end
  end

  def participant?(user)
    participants.detect do |workflow|
      workflow.creator == user
    end.present?
  end

  def open_completion_workflow_for?(user)
    participants.detect do |workflow|
      workflow.available_for?(user)
    end.present?
  end

  private

  def finish
    self.status = 'finished'
    self.save!
  end

  def allow_workflow?(workflow_user, participant_user)
    workflow = workflow_for_user(participant_user)

    workflow.present? &&
    workflow.available_for?(workflow_user) &&
    # TODO check scenarios?!
    active? &&
    workflow_user.groups.include?(self.group)
  end

  def workflow_for_user(user)
    participants.detect do |workflow|
      workflow.creator == user
    end
  end

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

  def finished?
    raise NotImplementedError
  end
end
