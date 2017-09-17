json.extract! user, :name

json.friends user.friends, :id, :name, :pro_pic_url
