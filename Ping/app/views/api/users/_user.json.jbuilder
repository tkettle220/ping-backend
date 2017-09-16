json.extract! user, :id, :user_name
json.friends user.friends.pluck(:friend_id)
