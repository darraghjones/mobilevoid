require 'open-uri'
require 'amazon/aws/search'
require 'nokogiri'
require 'digest/md5'

class TestController < ApplicationController
  include Amazon::AWS
  include Amazon::AWS::Search

  def album_art
    # use the configure method to setup your api credentials
    #configure :secret => 'aZIjrMKf7wzYG5wLdpFE5d4u7g4r/gPT2XhcGOrL', :key => '1WS5BB46KDFHM0SF3PR2'

    # We can use symbols instead of string.
#
is = ItemSearch.new( :Music, { :Artist => 'Stranglers' } )
is.response_group = ResponseGroup.new( :Medium )

req = Request.new
req.locale = 'uk'

resp = req.search( is )

# Use of :ALL_PAGES means an array of responses is returned, one per page.
#
items = resp.collect { |r| r.item_search_response[0].items[0].item }.flatten
	
	render :content_type => "text/plain", :text => items.to_yaml

  end

end