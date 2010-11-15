class ChartController < ApplicationController
def index
end

def show

doc = Nokogiri::HTML(open_url("http://www.legalsounds.com/InspectChart?" + request.query_string))

@albums = Array.new
doc.css('table.coversChart').each do |n| 
ar = Artist.new
al = Album.new
al.Artist = ar
al.Artist.Name = n.css('td.cont a.artistName')[0] && n.css('td.cont a.artistName')[0].text() || "Various Artists" 
al.Name = n.css('td.cont a')[0] && n.css('td.cont a')[0].text() || ""

al.Artist.Url = n.css('td.cont a.artistName')[0] && n.css('td.cont a.artistName')[0]['href'] || "" 
al.Url = n.css('td.cont a')[0] && n.css('td.cont a')[0]['href'] || ""


@albums << al
end


end

end
