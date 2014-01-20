Rails.application.routes.draw do

  mount BarclampMessaging::Engine => "/barclamp_messaging"
end
