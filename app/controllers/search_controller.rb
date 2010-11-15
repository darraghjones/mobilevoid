

class SearchController < ApplicationController
def index
end

def new
if params[:pattern]
doc = Nokogiri::HTML(open_url("http://www.legalsounds.com/search?pattern=#{CGI.escape(params[:pattern])}"))
elsif params[:s] || params[:ar] || params[:a] 
doc = Nokogiri::HTML(open_url("http://www.legalsounds.com/powerSearch?s=#{CGI.escape(params[:s])}&ar=#{CGI.escape(params[:ar])}&a=#{CGI.escape(params[:a])}"))
end

if doc
@songs = Array.new
doc.css('table.tbllist tr.off').each do |n| 
ar = Artist.new
al = Artist.new
s = Song.new
s.Artist = ar
s.Album = al
s.Name = n.css('td')[1].text()
s.Url = n.css('div.preview div')[0]['href']
s.Artist.Name = n.css('td')[2].text()  
s.Artist.Url = n.css('td')[2].at_css('a') && n.css('td')[2].at_css('a')['href'] 
s.Album.Name = n.css('td')[3].text()
s.Album.Url = n.css('td')[3].at_css('a')['href']

@songs << s
end
respond_to do |format|
format.html { render :show }
format.js { render :show }
end
end
end



end
