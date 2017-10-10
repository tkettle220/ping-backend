class User < ApplicationRecord

  has_many :friendships, :dependent => :destroy

  has_many :friends, :through => :friendships

  belongs_to :location, optional: true

  def fill_user_data(graph)
    self.visible_radius = 5;
    self.facebook_id = graph.get_object("me")["id"]
    self.name = graph.get_object("me")["name"]
    self.pro_pic_url = "http://graph.facebook.com/#{self.facebook_id}/picture"
  end

  def add_friend(friend_id)
    # auto adds for now, later need approval before add, use redis?
    Friendship.create!(user_id: self.id, friend_id: friend_id)
    Friendship.create!(user_id: friend_id, friend_id: self.id)
  end

  def friends_on_ping(graph)
    all_friends = graph.get_connections("me", "friends")
    all_friends_fb_ids = all_friends.map { |friend| friend[:id] }

    ping_friends = []
    all_friends_fb_ids.each do |fb_id|
      ping_friend = User.find_by(facebook_id: fb_id)
      ping_friends << ping_friend if ping_friend
    end

    ping_friends
  end

  # def add_friends(graph)
  #   friends = graph.get_connections("me", "friends")
  #
  #   friend_facebook_ids = friends.map{ |friend| friend["id"]}
  #   friend_ids = friend_facebook_ids.map do |fb_id|
  #     friend = User.find_by(facebook_id: fb_id)
  #     friend.nil? ? nil : friend.id
  #   end
  #   friend_ids.each do |id|
  #     return unless id
  #     #need to find the id of the friend with this facebook_id
  #     Friendship.create!(user_id: self.id, friend_id: id)
  #     Friendship.create!(user_id: id, friend_id: self.id)
  #   end
  # end

end
