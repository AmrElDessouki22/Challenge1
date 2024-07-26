class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :chat
  belongs_to :application

  

  settings do
    mappings dynamic: false do
      indexes :body, type: :text, analyzer: :english
      indexes :application_id, type: :integer
      indexes :chat_id, type: :integer

    end
  end

  after_update do
    __elasticsearch__.index_document
  end

  after_destroy do
    __elasticsearch__.delete_document
  end

end
