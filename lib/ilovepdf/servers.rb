module Ilovepdf
  module Servers
    PROTOCOL = 'http'.freeze # https
    HOST = 'apidev'.freeze # api
    START_SERVER = "#{PROTOCOL}://#{HOST}.ilovepdf.com".freeze
  end
end