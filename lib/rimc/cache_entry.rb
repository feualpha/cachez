class Rimc
  class CacheEntry < Struct.new(:cached_object, :expire_time)
    def expired?
      return false if expire_time.nil?

      Time.now > expire_time
    end
  end
end
