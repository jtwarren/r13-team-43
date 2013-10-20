class ChallengeLogEntry
  include MongoMapper::EmbeddedDocument

  timestamps!

  key :message, String

  def self.challenge_created(user)
    new(message: "#{user.title} created this challenge.")
  end

  def self.challenge_activated()
    new(message: "Challenge activated.")
  end

  def self.user_completed_challenge(user)
    new(message: "#{user.title} finished this challenge.")
  end

  def self.user_voted_challenge(user)
    new(message: "#{user.title} voted for this challenge.")
  end
end