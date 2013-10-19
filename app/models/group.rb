class Group
  include MongoMapper::Document

  many :challenges

  key :name, String, required: true
  key :description, String

  userstamps!
  timestamps!

  def users
    User.where(group_ids: id).all
  end
end
