class V1::MessagesController < ApplicationController
  def index 
    application_token = params[:application_id]
    chat_id = params[:chat_id]

    application = Application.find_by(app_token: application_token)
    if application == nil 
      render json: {message:"application not found maybe removed or still under processing, contact support"}, status: 404
      return
    end

    chat = application.chats.find_by(chat_id_in_application: chat_id)
    if !chat
      render json: {message:"chat not found maybe removed or still under processing, contact support"}, status: 404
      return
    end

    @messages = chat.messages.where(application_id: application[:id]).all
    render json: @messages.as_json(except: [:id , :application_id , :chat_id ]), status: 200
  end
  
  def show
    application_token = params[:application_id]
    chat_id = params[:chat_id]
    message_id_in_chat = params[:id]

    application = Application.find_by(app_token: application_token)
    if !application
      render json: {message:"application not found maybe removed or still under processing, contact support"}, status: 404
      return
    end

    chat = application.chats.find_by(chat_id_in_application: chat_id)
    if !chat
      render json: {message:"chat not found maybe removed or still under processing, contact support"}, status: 404
      return
    end

    @message = chat.messages.find_by(message_id_in_chat: message_id_in_chat , application_id: application[:id])
    if !@message
      render json: {message:"message not found maybe removed or still under processing, contact support"}, status: 404
      return
    end

    render json: @message.as_json(except: [:id , :application_id , :chat_id ]), status: 200

  end

  def create
    message_create_params
    application_token = params[:application_id]
    chat_id = params[:chat_id]
    body = params[:data][:body]
    message_id_in_chat = 1

    application = Application.find_by(app_token: application_token)
    if !application
      render json: {message:"application not found maybe removed or still under processing, contact support"}, status: 404
      return
    end

    application_id = application[:id];

    chat = application.chats.find_by(chat_id_in_application: chat_id)
    if !chat
      render json: {message:"chat not found maybe removed or still under processing, contact support"}, status: 404
      return
    end

    chat_id = chat[:id]

    $redis.lock("instabug_task:application:#{application_id}:chat:#{chat_id}:messages:total",15)
    total = $redis.get("instabug_task:application:#{application_id}:chat:#{chat_id}:messages:total")
    if !total 
      latest_message_in_chat = chat.messages.where(application_id: application[:id]).maximum(:message_id_in_chat) || 0
      message_id_in_chat = latest_message_in_chat + 1
      $redis.set("instabug_task:application:#{application_id}:chat:#{chat_id}:messages:total", message_id_in_chat)
    else
      message_id_in_chat = total.to_i + 1
      $redis.set("instabug_task:application:#{application_id}:chat:#{chat_id}:messages:total", message_id_in_chat)
    end
    $redis.unlock("instabug_task:application:#{application_id}:chat:#{chat_id}:messages:total")
    

    job_id = MessageCeationJob.perform_async(application_id,chat_id,message_id_in_chat,body)
    render json: {message_id_in_chat: message_id_in_chat }, status: 202

  end

  def destroy
    application_token = params[:application_id]
    chat_id_in_application = params[:chat_id]
    message_id_in_chat = params[:id]

    application = Application.find_by(app_token: application_token)
    if !application
      render json: {message:"application not found maybe removed or still under processing, contact support"}, status: 404
      return
    end

    application_id = application[:id];

    chat = application.chats.find_by(chat_id_in_application: chat_id_in_application)
    if !chat
      render json: {message:"chat not found maybe removed or still under processing, contact support"}, status: 404
      return
    end

    chat_id = chat[:id]

    job_id = MessageDeleteJob.perform_async(application_id,chat_id,message_id_in_chat)
    render json: {deleted: true }, status: 202

  end

  def update
    message_create_params
    application_token = params[:application_id]
    chat_id = params[:chat_id]
    message_id_in_chat = params[:id]
    body = params[:data][:body]

    application = Application.find_by(app_token: application_token)
    if !application
      render json: {message:"application not found maybe removed or still under processing, contact support"}, status: 404
      return
    end

    application_id = application[:id]

    chat = application.chats.find_by(chat_id_in_application: chat_id)
    if !chat
      render json: {message:"chat not found maybe removed or still under processing, contact support"}, status: 404
      return
    end

    chat_id = chat[:id]
    
    job_id = MessagesUpdataJob.perform_async(application_id, chat_id, message_id_in_chat, body)

    render json: { updated: true }, status: 202

  end

  def search
    message_search_params
    search_value = params[:search]
    application_token = params[:application_id]
    chat_id = params[:chat_id]


    application = Application.find_by(app_token: application_token)
    if !application
      render json: {message:"application not found maybe removed or still under processing, contact support"}, status: 404
      return
    end

    chat = application.chats.find_by(chat_id_in_application: chat_id)
    if !chat
      render json: {message:"chat not found maybe removed or still under processing, contact support"}, status: 404
      return
    end

    if !search_value.present?
      render json: {message:"search can't be empty"}, status: 404
      return
    end

    
    search_query = {
      query: {
        bool: {
          must: [
            { match: { application_id: application[:id] } },
            { match: { chat_id: chat[:id] } },
            {
              bool: {
                should: [
                  { match: { body: search_value } },
                  { wildcard: { body: "*#{search_value}*" } },
                  { prefix: { body: search_value } }            
                ]
              }
            }
          ]
        }
      },
      highlight: {
        fields: {
          body: {}
        }
      }
    }


    @messages = Message.search(search_query).records

    render json: @messages.as_json(except: [:chat_id , :application_id]), status: 200


  end

  private 

  def message_create_params
    params.require(:data).permit(:body)
  end
  def message_search_params
    params.require(:search)
  end

end
