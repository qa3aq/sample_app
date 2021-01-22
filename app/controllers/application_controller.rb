class ApplicationController < ActionController::Base
    include SessionsHelper

  def hello
    render plain: 'hello, world!'
  end
end
