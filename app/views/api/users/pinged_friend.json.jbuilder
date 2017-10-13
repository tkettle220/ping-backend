json.friend do
  json.extract! @friend, :name, :pro_pic_url, :facebook_id
end
json.emergency @emergency
if @emergency || (@friend.location && @friend.findable && @friend.location.distance_from(@user.location) <= @friend.visible_radius)
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
