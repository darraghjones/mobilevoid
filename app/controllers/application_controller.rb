require 'utility'

class ApplicationController < ActionController::Base
  include Utility
  protect_from_forgery

end
