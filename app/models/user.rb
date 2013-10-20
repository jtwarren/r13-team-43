class User
  include MongoMapper::Document
  include ActiveModel::SecurePassword

  # disabled for RailsRumble
  # has_secure_password

  many :groups, in: :group_ids
  key :group_ids, Set

  key :email, String, required: true, unique: true
  key :password_digest, String

  many :transactions

  def title
    @title ||= email.match(/[^@]+/)
  end

  # override auth logic to allow login without password
  def authenticate(password)
    true
  end

  def points(group)
    user_point = UserPoint.where(group_id: group.id, user_id: id).first

    if user_point
      user_point.points
    else
      0
    end
  end
end
