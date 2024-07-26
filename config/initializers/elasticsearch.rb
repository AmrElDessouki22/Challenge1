# config/initializers/elasticsearch.rb
client = Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: ENV['ELASTICSEARCH_URL'],
  log: true,
  transport_options: {
    headers: { 
      content_type: 'application/json' 
    },
    ssl: { verify: false }
  },
  user: 'elastic', 
  password: ENV['ELASTIC_PASSWORD'],
  transport_options: { request: { timeout: 250 } }

)


index_name = 'messages'

# Define the index settings and mappings
index_settings = {
  settings: {
    index: {
      number_of_shards: 1,
      number_of_replicas: 0
    },
    analysis: {
      analyzer: {
        default: {
          type: 'english'
        }
      }
    }
  },
  mappings: {
    properties: {
      body: {
        type: 'text',
        analyzer: 'english'
      },
      application_id:{
        type: 'integer'
      },
      chat_id:{
        type: 'integer'
      },
    }
  }
}

# Check if the index already exists
if client.indices.exists?(index: index_name)
  puts "Elasticsearch index '#{index_name}' already exists."
else
  # Create the index if it does not exist
  client.indices.create(
    index: index_name,
    body: index_settings
  )
  puts "Elasticsearch index '#{index_name}' created."
end

