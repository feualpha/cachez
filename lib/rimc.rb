require 'rimc/version'
require 'rimc/cache_entry'

class Rimc
  class << self
    def set(cache_key, cached_object, ttl = nil)
      entry = CacheEntry.new(cached_object, expiration_time(ttl))
      cache_entries[cache_key] = entry
      true
    end

    def get(cache_key)
      entry = cache_entries[cache_key]
      return nil unless entry
      return entry.cached_object unless entry.expired?

      cache_entries.delete(cache_key)
      nil
    end

    def cache(cache_key, ttl)
      result = get(cache_key)
      return result if result

      result = yield if block_given?
      set(result, cache_key, ttl)
      result
    end

    private

    def cache_entries
      @cache_entries ||= {}
    end

    def expiration_time(ttl)
      Time.now + ttl
    end
  end
end
