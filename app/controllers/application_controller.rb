require 'utility'

class ApplicationController < ActionController::Base
  include Utility
  include SessionsHelper

  #protect_from_forgery

  #after_filter :cache_response


  def cache_response
    response.headers['Cache-Control'] = 'public; max-age=2592000' # cache image for a month
  end

end
