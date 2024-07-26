class V1::ChatsController < ApplicationController

  def index 
    application_token = params[:application_id]

    application = Application.find_by(app_token: application_token)
    if !application
      render json: {message:"application not found maybe removed or still under processing, contact support"}, status: 404
      return
    end

    @chat = application.chats.all
    render json: @chat.as_json(except: [:id , :application_id ]), status: 200
  end
  
  def show 
    application_token = params[:application_id]
    chat_id = params[:id]

    application = Application.find_by(app_token: application_token)
    if !application 
      render json: {message:"application not found maybe removed or still under processing, contact support"}, status: 404
      return
    end

    @chat = application.chats.find_by(chat_id_in_application: chat_id)
    render json: @chat.as_json(except: [:id , :application_id ]), status: 200
  end
  
  def create
    application_token = params[:application_id]

    chat_id_in_application = 1

    application = Application.find_by(app_token: application_token)

    if !application 
      render json: {message:"application not found maybe removed or still under processing, contact support"}, status: 404
      return
    end

    application_id = application[:id]

    $redis.lock("instabug_task:application:#{application_id}:chat:total",15)
    total = $redis.get("instabug_task:application:#{application_id}:chat:total")
    if !total 
      last_chat_id_in_application = Chat.where(application_id: application_id).maximum(:chat_id_in_application) || 0
      chat_id_in_application = last_chat_id_in_application + 1
      $redis.set("instabug_task:application:#{application_id}:chat:total", chat_id_in_application)
    else
      chat_id_in_application = total.to_i + 1
      $redis.set("instabug_task:application:#{application_id}:chat:total", chat_id_in_application)
    end
    $redis.unlock("instabug_task:application:#{application_id}:chat:total")
    

    job_id = ChatCreateJob.perform_async(application_id,chat_id_in_application)
    render json: { chat_id_in_application: chat_id_in_application }, status: 202
  end
  
  def destroy
    application_token = params[:application_id]
    chat_id = params[:id]

    application = Application.find_by(app_token: application_token)

    if !application 
      render json: {message:"application not found maybe removed or still under processing, contact support"}, status: 404
      return
    end

    application_id = application[:id]

    job_id = ChatDeleteJob.perform_async(application_id,chat_id)
    render json: {deleted: true , job_id: job_id }, status: 202

  end
  
  private 

  
  
  
end
