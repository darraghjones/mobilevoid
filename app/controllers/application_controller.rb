require 'utility'

class ApplicationController < ActionController::Base
  include Utility
  protect_from_forgery


  after_filter do |controller|
    response.headers['Cache-Control'] = 'public; max-age=2592000' # cache image for a month
  end

end
