class ApplicationUpdataJob
  include Sidekiq::Worker

  queue_as :default

  def perform(application_id,new_name)
    ActiveRecord::Base.transaction do
      application = Application.lock.find_by(id: application_id)
      application.update(name: new_name)
    end
  end
end
