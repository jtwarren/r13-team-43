class User
  include MongoMapper::Document
  include ActiveModel::SecurePassword

  # disabled for RailsRumble
  # has_secure_password

  many :groups, in: :group_ids
  key :group_ids, Set

  key :email, String, required: true, unique: true
  key :password_digest, String

  key :points, Integer, default: 0

  many :transactions

  def title
    @title ||= email.match(/[^@]+/)
  end

  # override auth logic to allow login without password
  def authenticate(password)
    true
  end
end
