class User
  JUDGE_MODE = true

  include MongoMapper::Document
  include ActiveModel::SecurePassword

  has_secure_password unless JUDGE_MODE

  many :groups, in: :group_ids
  key :group_ids, Set

  key :email, String, required: true, unique: true
  key :password_digest, String

  def title
    @title ||= email.match(/[^@]+/)
  end

  # override auth logic to allow login without password
  def authenticate(password)
    return true if JUDGE_MODE

    super(password)
  end
end
