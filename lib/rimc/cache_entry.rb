module Rimc
  class CacheEntry
    attr_accessor :cached_object, :expire_time

    def expired?
      return false if expire_time.nil?
      Time.now > expire_time
    end
  end
end