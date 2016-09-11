require 'typhoeus/adapters/faraday'

class SpeachRepository
  include Elasticsearch::Persistence::Repository

  client Elasticsearch::Client.new url: '127.0.0.1:9200', log: false

  index :speaches
  type  :speach

  mapping do
    indexes :transcript,  analyzer: 'snowball'
    indexes :speaker,     type: :string, index: :not_analyzed
    indexes :filename,    type: :string, index: :not_analyzed
    indexes :tags,        type: :string, index: :not_analyzed
  end

  create_index!

  def serialize(document)
    {
      id: document.id,
      speaker: document.speaker,
      transcript: document.transcript,
      filename: document.filename,
      tags: document.tags.split(/\s+/).map(&:strip)
    }
  end

  def deserialize(document)
    hash = document['_source'.freeze]
    hash['tags'.freeze] = hash['tags'.freeze].join(' ') if hash['tags'.freeze].is_a?(Array)
    Speach.new(hash)
  end
end
