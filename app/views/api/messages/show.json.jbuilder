json.array! @messages do |message|
  json._id message.id
  json.text message.content
  json.createdAt message.created_at
  json.user do
    json._id message.user.id
    json.name message.user.name
    json.avatar message.user.pro_pic_url
  end
end
