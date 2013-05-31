module PlacesHelper
  def picture_for(place, size = :thumb)
    if !place.pictures.empty?
      p = place.pictures[0]
#      place.pictures.each do |p|
        thumbnail = p.public_filename(size)
        link_to(image_tag(thumbnail, :width => 160, :height => 120), p.public_filename, {:rel => "lightbox", :class=>"o_picture"})
#      end
    else
#      link_to(image_tag("koch.png", :width => 160, :height => 120), '#', {:rel => "lightbox", :class=>"o_picture"})
    end
  end

  # see http://blog.tinucleatus.com/?p=9 for original stuff
  # all patched and extended a little bit
  def rating_links(place)
    average = (place.rating_average.blank? ? 0 : place.rating_average) * 100 / 5

    html = "<ul class='stars'>"
    html += "<li class='current_rating' style='width: #{average}%'>#{average}%</li>"
#    if(!place.rated?)
      html += "<li>#{link_to_remote "One", :update => "place_rating_#{place.id}", :url => rate_place_path(place, :rating => 1), :html => {:class => "one_star"}, :method => :put}</li>"
      html += "<li>#{link_to_remote "Two", :update => "place_rating_#{place.id}", :url => rate_place_path(place, :rating => 2), :html => {:class => "two_stars"}, :method => :put}</li>"
      html += "<li>#{link_to_remote "Three", :update => "place_rating_#{place.id}", :url => rate_place_path(place, :rating => 3), :html => {:class => "three_stars"}, :method => :put}</li>"
      html += "<li>#{link_to_remote "Four", :update => "place_rating_#{place.id}", :url => rate_place_path(place, :rating => 4), :html => {:class => "four_stars"}, :method => :put}</li>"
      html += "<li>#{link_to_remote "Five", :update => "place_rating_#{place.id}", :url => rate_place_path(place, :rating => 5), :html => {:class => "five_stars"}, :method => :put}</li>"
#    end
    html += "</ul>"
    html += "<span class='click' style='display:none;'>&nbsp;jetzt bewerten!</span>"
    html += "<span class='rating_count'>(#{pluralize(place.rating_count, 'Bewertung', 'Bewertungen')})</span>"
    html
  end
end
