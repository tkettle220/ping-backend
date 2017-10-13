json.chatname @chatroom.chatname
json.messages @chatroom.messages do |message|
  json.content message.content
  json.time message.created_at
  json.user message.user.id
end
