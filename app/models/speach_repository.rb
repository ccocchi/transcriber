require 'typhoeus/adapters/faraday'

class SpeachRepository
  include Elasticsearch::Persistence::Repository

  client Elasticsearch::Client.new url: '127.0.0.1:9200', log: false

  index :speaches
  type  :speach

  mapping do
    indexes :transcript,  analyzer: 'snowball'
    indexes :speaker,     type: 'string', index: 'not_analyzed'
    indexes :filename,    type: 'string', index: 'not_analyzed'
  end

  create_index!

  def deserialize(document)
    hash = document['_source'.freeze]
    Speach.new(hash['speaker'.freeze], hash['transcript'.freeze], hash['filename'.freeze])
  end
end
