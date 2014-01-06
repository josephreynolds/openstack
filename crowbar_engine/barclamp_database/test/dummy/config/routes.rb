Rails.application.routes.draw do

  mount BarclampDatabase::Engine => "/barclamp_database"
end
