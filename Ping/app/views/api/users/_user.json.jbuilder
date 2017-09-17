json.extract! user, :id, :name, :pro_pic_url

json.friends user.friends, :id, :name, :pro_pic_url
