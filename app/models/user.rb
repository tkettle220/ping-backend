class User < ApplicationRecord

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :requested_friendships, foreign_key: :requester_id, class_name: "PendingFriendship"
  has_many :requested_friends, through: :requested_friendships, source: :requestee
  has_many :friendship_requests, foreign_key: :requestee_id, class_name: "PendingFriendship"
  has_many :friend_requesters, through: :friendship_requests, source: :requester

  belongs_to :location, optional: true

  def fill_user_data(graph)
    self.visible_radius = 5
    self.facebook_id = graph.get_object("me")["id"]
    self.name = graph.get_object("me")["name"]
    self.pro_pic_url = "http://graph.facebook.com/#{self.facebook_id}/picture"
  end

  def request_friend(friend_id)
    PendingFriendship.create!(requester_id: self.id, requestee_id: friend_id)
  end

  def add_friend(friend_id)
    friend = User.find(friend_id)
    return false if self.friends.include?(friend)

    Friendship.create!(user_id: self.id, friend_id: friend_id)
    Friendship.create!(user_id: friend_id, friend_id: self.id)
    pending = PendingFriendship.where(requester_id: friend_id, requestee_id: self.id)
    pending[0].destroy
  end

  def suggested_friends
    graph = Koala::Facebook::API.new(self.session_token)
    all_friends = graph.get_connections("me", "friends")
    all_friends_fb_ids = all_friends.map { |friend| friend["id"] }

    ping_friends = []
    all_friends_fb_ids.each do |fb_id|
      ping_friend = User.find_by(facebook_id: fb_id)
      if ping_friend
        already_friends = ping_friend.friends.ids.include?(self.id)
        requester = ping_friend.friend_requesters.ids.include?(self.id)
        requestee = ping_friend.requested_friends.ids.include?(self.id)
        unless already_friends || requester || requestee
          ping_friends << ping_friend
        end
      end
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
