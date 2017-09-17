json.friend do
  json.extract! @friend, :name, :pro_pic_url
end
if @friend.location && @friend.location.distance_from(@user.location)
  json.status true
  json.friend do
    json.location do
      json.lat @friend.location.latitude
      json.lng @friend.location.longitude
    end
  end 
else
  json.status false
  json.error "not_found"
end
