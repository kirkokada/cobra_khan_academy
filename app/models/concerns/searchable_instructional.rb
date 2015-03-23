# Elastic search settings

module SearchableInstructional
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    index_name "cka-instructionals-#{Rails.env}"

    settings index: { 
      number_of_shards: 1 
      },
      analysis: {
        filter: {
          nGram_filter: {
            type: "edgeNGram",
            min_gram: 2,
            max_gram: 20,
            token_chars: [
              "letter",
              "digit",
              "punctuation",
              "symbol"
            ]
          }
        },
        analyzer: {
          nGram_analyzer: {
            type: "custom",
            tokenizer: "whitespace",
            filter: [
              "lowercase",
              "asciifolding",
              "nGram_filter"
            ]
          },
          whitespace_analyzer: {
            type: "custom",
            tokenizer: "whitespace",
            filter: [
              "lowercase",
              "asciifolding"
            ]
          }
        }
      } do
      mappings dynamic: 'false' do
        indexes :title, type: "multi_field" do
          indexes :title, analyzer: 'standard'
          indexes :tokenized, analyzer: 'simple'
          indexes :autocomplete, index_analyzer: "nGram_analyzer", search_analyzer: "whitespace_analyzer"
        end
        indexes :description, type: "multi_field" do
          indexes :description, analyzer: "standard"
          indexes :tokenized, analyzer: 'simple'
        end
      end
    end

    def self.search(query)
      __elasticsearch__.search({
        query: {
          multi_match: {
            query: query,
            fields: ['title.autocomplete^10', 'description']
          }
        },
        highlight: {
          pre_tags: ['<highlight>'],
          post_tags: ['</highlight>'],
          fields: {
            title: {},
            description: {}
          }
        }
      })
    end
  end
end