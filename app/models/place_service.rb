class PlaceService
  attr_reader :place, :pictures

  def initialize(place, pictures)
    @place = place
    @pictures = pictures
  end

  def save
    return false unless valid?
    begin
      place.transaction do
        if @pictures
          @pictures.each do |picture|
            if picture.new_record?
              @place.pictures.each {|p|p.destroy} if @place.pictures
              @place.pictures << picture
              picture.place = @place
              picture.save!
            end
          end
        end
        @place.save!
        true
      end
    rescue
      false
    end
  end

  def valid?
    @place.valid? && (@pictures.empty? || @pictures.map(&:valid?).all?{|p|p})
  end

  def update_attributes(place_attributes, picture_files)
    @place.attributes = place_attributes
    unless picture_files.compact.empty?
      # delete old pictures
      @pictures.clear
      # add new pictures
      picture_files.each{|file|@pictures << Picture.new(:uploaded_data => file)}
    end
    save
  end
end 
