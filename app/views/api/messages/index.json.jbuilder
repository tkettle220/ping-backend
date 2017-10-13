json.array! @messages do |message|
  json.content message.content
  json.user message.user.name
end
