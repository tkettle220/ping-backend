json.friend do
  json.extract! @friend, :name, :pro_pic_url
end
json.emergency @emergency

debugger
json.status @ping[:status]
json.friend do
  json.location do
    json.lat @ping[:location][:lat]
    json.lng @ping[:location][:lng]
  end
end
