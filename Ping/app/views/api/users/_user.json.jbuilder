json.extract! user, :id, :name, :pro_pic_url
json.friends user.friends.pluck(:friend_id)
