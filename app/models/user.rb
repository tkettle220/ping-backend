class User < ApplicationRecord

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :requested_friendships, foreign_key: :requester_id, class_name: "PendingFriendship"
  has_many :requested_friends, through: :requested_friendships, source: :requestee
  has_many :friendship_requests, foreign_key: :requestee_id, class_name: "PendingFriendship"
  has_many :friend_requesters, through: :friendship_requests, source: :requester
  has_many :messages
  belongs_to :location, optional: true
  has_one :token, dependent: :destroy

  has_many :chatrooms,
    through: :friendships,
    source: :chatroom,
    dependent: :destroy

  def fill_user_data(graph)
    self.visible_radius = 5
    profile = graph.get_object('me')
    self.facebook_id = profile["id"]
    self.name = profile["name"]
    self.pro_pic_url = graph.get_picture_data(profile['id'], type: :large)['data']['url']

  end

  def request_friend(friend_id)
    return false if self.friend_requesters.ids.include?(friend_id)
    request = PendingFriendship.new(requester_id: self.id, requestee_id: friend_id)
    return false unless request.valid?

    request.save
    # PendingFriendship.create(requester_id: self.id, requestee_id: friend_id)
  end

  def add_friend(friend_id)
    friend = User.find(friend_id)
    return false if self.friends.include?(friend)

    new_chat = Chatroom.create!
    Friendship.create!(user_id: self.id, friend_id: friend_id, chatroom_id: new_chat.id)
    Friendship.create!(user_id: friend_id, friend_id: self.id, chatroom_id: new_chat.id)
    pending = PendingFriendship.where(requester_id: friend_id, requestee_id: self.id)
    pending[0].destroy unless pending.nil?
  end

  def remove_friend(chatroom_id)
    friendships = Friendship.where(chatroom_id: chatroom_id)
    return false if friendships.nil?

    friendships.each do |friendship|
      friendship.destroy
    end
  end

  def suggested_friends
    graph = Koala::Facebook::API.new(self.session_token)
    all_friends = graph.get_connections("me", "friends")
    all_friends_fb_ids = all_friends.map { |friend| friend["id"] }

    ping_friends = []
    all_friends_fb_ids.each do |fb_id|
      ping_friend = User.find_by(facebook_id: fb_id)
      if ping_friend
        ping_friends << ping_friend
      end
    end
    not_friends = ping_friends.reject { |friend| self.friends.ids.include?(friend.id) }
    not_requester = not_friends.reject { |friend| self.friend_requesters.ids.include?(friend.id) }
    not_requested = not_requester.reject { |friend| self.requested_friends.ids.include?(friend.id) }
  end

  def get_chatroom_id(friend_id)
    Friendship.where(user_id: self.id, friend_id: friend_id)[0].chatroom_id
  end
end
