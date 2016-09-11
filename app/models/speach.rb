require 'active_support/core_ext/securerandom'

class Speach
  attr_accessor :id, :speaker, :transcript, :filename, :tags, :es_id

  def initialize(attrs = {})
    attrs.each { |k, v| public_send("#{k}=", v) }
    self.id ||= SecureRandom.base58(24)
  end

  def to_hash
    {
      id: id,
      speaker: speaker,
      transcript: transcript,
      filename: filename,
      tags: tags,
      es_id: es_id
    }
  end

  def save
    result = $redis.mapped_hmset(redis_key, to_hash)
    result == 'OK'.freeze
  end

  def self.find(id)
    attrs = $redis.hgetall("speach:#{id}")
    self.new(attrs)
  end

  private

  def redis_key
    "speach:#{id}"
  end
end
