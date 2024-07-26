class ApplicationDeleteJob
  include Sidekiq::Worker

  queue_as :default

  def perform(token)
    application = Application.find_by(app_token: token)

    if !application
      return
    end

    application.destroy 
  end
end
