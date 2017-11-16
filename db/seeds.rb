require 'random_data'

# Create Posts
50.times do

  # Adding a ! instructs the method to raise an error if there's a problem with the data we're seeding. Using create without a bang could fail without warning, causing the error to surface later.
  Post.create!(

    #  We use methods from a class that does not exist yet, RandomData, that will create random strings for title and body. Writing code for classes and methods that don't exist is known as "wishful coding" and can increase productivity because it allows you to stay focused on one problem at a time.
    title: RandomData.random_sentence,
    body: RandomData.random_paragraph
  )
end

posts = Post.all

# Create comments
100.times do
  Comment.create!(

    # We call sample on the array returned by Post.all, in order to pick a random post to associate each comment with. sample returns a random element from the array every time it's called.
    post: posts.sample,
    body: RandomData.random_paragraph
  )
end

100.times do
  Question.create!(
  title: RandomData.random_sentence,
  body: RandomData.random_paragraph,
  resolved: false
  )
end

puts "Seed finished"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
puts "#{Question.count} questions created"
