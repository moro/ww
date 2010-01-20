module Ww
  Version = '0.3.1'

  def to_app(*args, &block)
    $stderr.puts <<-WORNING
*** DUPLICATION WORNING ***
Ww.to_app moves to Ww::SpyEye.to_app

This comatibility will be lost on 0.4.0.
***************************
WORNING
    require 'ww/spy_eye'
    Ww::SpyEye.to_app(*args, &block)
  end
  module_function :to_app
end

