class Micropost < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length:{maximum:140}
  validates :user_id, presence:true
  default_scope {order(created_at: :DESC)}
  mount_uploader :picture, PictureUploader
  validate :picture_size

  def picture_size
  	if picture.size > 5.megabytes
  		self.errors.add(:picture, "size should be less than 5MB.")
  	end
  end
end
