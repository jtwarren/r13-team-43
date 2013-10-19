class ChallengeLogEntry
  include MongoMapper::EmbeddedDocument

  timestamps!

  key :message, String

  def self.challenge_created(user)
    new(message: "#{user.title} created this challenge.")
  end

  def self.user_completed_challenge(user)
    new(message: "#{user.title} finished this challenge.")
  end
end