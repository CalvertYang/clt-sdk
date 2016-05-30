require "clt/version"
require "clt/error_message"
require "clt/cvs"
require "clt/credit_card"

require "nokogiri"
require "nori"
require "json"

module Clt
  class << self
    attr_accessor :cvs_cust_id, :cvs_cust_password, :cvs_expire_after
    attr_accessor :cocs_link_id, :cocs_hash_base
  end

  def self.cvs_expire_after
    @cvs_expire_after || 1
  end

  def self.setup
    yield(self)
  end
end
