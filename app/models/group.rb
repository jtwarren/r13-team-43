class Group
  include MongoMapper::Document

  many :challenges

  key :name, String

  def users
    User.where(group_ids: id).all
  end
end
