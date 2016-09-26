require 'typhoeus/adapters/faraday'

class SpeachRepository
  include Elasticsearch::Persistence::Repository

  client Elasticsearch::Client.new url: '127.0.0.1:9200', log: false

  index :speaches
  type  :speach

  # settings analysis: {
  #   analyzer: {
  #     french_anal: { type: 'snowball', language: 'French', stopwords: '_french_' }
  #   }
  # }

  settings analysis: {
    "filter": {
        "french_elision": {
          "type":         "elision",
          "articles_case": true,
            "articles": [
              "l", "m", "t", "qu", "n", "s",
              "j", "d", "c", "jusqu", "quoiqu",
              "lorsqu", "puisqu"
            ]
        },
        "french_stop": {
          "type":       "stop",
          "stopwords":  "_french_"
        },
        "french_stemmer": {
          "type":       "stemmer",
          "language":   "light_french"
        }
      },
      "analyzer": {
        "custom_french": {
          "tokenizer": "standard",
          "filter": [
            "french_elision",
            "lowercase",
            "asciifolding",
            "french_stop",
            "french_stemmer"
          ]
        }
      }
    }

  mapping do
    indexes :transcript,  type: :string, analyzer: 'custom_french'
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
