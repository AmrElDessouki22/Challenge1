

class V1::ApplicationController < ApplicationController
  def index 
    # i think it should be an admin or something to access this endpoint 
  end

  def show 
    token = params[:id]

    @application = Application.find_by(app_token: token)

    if !@application
      render json: { error: 'Application not found or maybe still under processing , contact support' }, status: 404  
      return
    end

    render json: @application.as_json(except: :id), status: 200
    
  end

  def create
    application_create_params
    name = params[:data][:name]
    app_token = SecureRandom.uuid
    job_id = ApplicationCreationJob.perform_async(name,app_token)
    render json: { application: { token: app_token} , job_id: job_id }, status: 202

  end

  def update
    application_create_params
    token = params[:id]
    name = params[:data][:name]
    application = Application.find_by(app_token: token)

    if !application
      render json: { error: 'Application not found or maybe still under processing , contact support' }, status: 404  
      return
    end
    application_id = application[:id]
    job_id = ApplicationUpdataJob.perform_async(application_id,name)
    render json: { updated: true , job_id: job_id }, status: 202

  end

  
  def destroy
    token = params[:id]
    job_id = ApplicationDeleteJob.perform_async(token)
    render json: { deleted: true , job_id: job_id }, status: 202
  end

  private 

  def application_create_params
    params.require(:data).permit(:name)
  end

  

end
