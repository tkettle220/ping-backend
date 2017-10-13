json.extract! user, :id, :name, :pro_pic_url, :visible_radius, :findable, :custom_ping_icons, :custom_ping_messages

json.friends  do
  user.friends.each do |friend|
    json.set! friend.facebook_id do
      json.name friend.name
      json.pro_pic_url friend.pro_pic_url
    end
  end
end

json.fb_friends do
  user.suggested_friends.each do |friend|
    json.set! friend.facebook_id do
      json.id friend.id
      json.name friend.name
      json.pro_pic_url friend.pro_pic_url
    end
  end
end

json.pending_friends do
  user.requested_friends.each do |friend|
    json.set! friend.facebook_id do
      json.id friend.id
      json.name friend.name
      json.pro_pic_url friend.pro_pic_url
      json.require_approval false
    end
  end
  user.friend_requesters.each do |friend|
    json.set! friend.facebook_id do
      json.id friend.id
      json.name friend.name
      json.pro_pic_url friend.pro_pic_url
      json.require_approval true
    end
  end

end
