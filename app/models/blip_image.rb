class BlipImage < ActiveRecord::Base
  belongs_to :blip
  mount_uploader :image, PictureUploader
  validate :image_size

  private
  	def image_size
  		if image.size > 3.megabytes
  			errors.add(:image, "Photo must be less than 5MB.")
  		end
  	end
end