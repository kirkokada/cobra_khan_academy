module InstructionalsHelper
  def youtube_thumbnail_for(uid)
    image_tag "http://img.youtube.com/vi/#{uid}/default.jpg"
  end
end
