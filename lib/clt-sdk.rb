require "nokogiri"
require "nori"
require "json"
require "digest"
require "net/http"
require "net/https"

require "clt/version"
require "clt/error_message"
require "clt/general_methods"
require "clt/core_ext/hash"
require "clt/cvs"
require "clt/credit_card"

module Clt
  class << self
    attr_accessor :cvs_cust_id, :cvs_cust_password, :cvs_default_expire_day
    attr_accessor :cocs_link_id, :cocs_hash_base
  end

  def self.cvs_default_expire_day
    @cvs_default_expire_day || 1
  end

  def self.setup
    yield(self)
  end
end
