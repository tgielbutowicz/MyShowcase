namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_posts
    make_user_relations
    make_tags
  end
end

def make_users
  admin = User.create!(:name => "Admin",
                       :email => "admin@railstutorial.org",
                       :password => "foobar",
                       :password_confirmation => "foobar")
  admin.toggle!(:admin)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end

def make_posts
  User.all(:limit => 6).each do |user|
    50.times do |i|
      content = Faker::Lorem.sentence(5)
      user.posts.create!(:title => "title-#{i}", :content => content)
    end
  end
end

def make_user_relations
  users = User.all
  user  = users.first
  following = users[1..50]
  followers = users[3..40]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end

def make_tags
  posts = Post.all[1..100]
  words = Faker::Lorem.words(20).uniq
  words.each do |i|
    tag = Tag.create!(:name => "#{i}")
    20.times do
      posts.shuffle.first.describe!(tag)
    end
  end
end