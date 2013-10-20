class UserPoint
  include MongoMapper::Document

  key :points, Integer, default: 0

  belongs_to :group
  belongs_to :user
end
