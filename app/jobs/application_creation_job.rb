class ApplicationCreationJob 
  include Sidekiq::Worker

  queue_as :default

  def perform(name,app_token)
    # idk do u need the name to be unique or no so if yes you can uncommment the below block of code

    # app_already_exist = Application.find_by(name: name)
    # if app_already_exist
    #  return
    # end
    application = Application.create({name: name , app_token: app_token})
    application.save
  end
end
