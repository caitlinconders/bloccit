require 'rails_helper'

# we add SessionsHelper so that we can use the create_session(user) method later in the spec.
include SessionsHelper

# RSpec created a test for PostsController. type: :controller tells RSpec to treat the test as a controller test. This allows us to simulate controller actions such as HTTP requests.
RSpec.describe PostsController, type: :controller do

  let(:my_user) { User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "helloworld") }
  let(:my_topic) { Topic.create!(name:  RandomData.random_sentence, description: RandomData.random_paragraph) }
  let(:my_post) { my_topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: my_user) }

  # add a context for un-signed-in user. Contexts organize tests based on the state of an object.
  context "guest user" do
   # we define the show tests, which allow guests to view posts in Bloccit.
       describe "GET show" do
         it "returns http success" do
           get :show, params: { topic_id: my_topic.id, id: my_post.id }
           expect(response).to have_http_status(:success)
         end

         it "renders the #show view" do
           get :show, params: { topic_id: my_topic.id, id: my_post.id }
           expect(response).to render_template :show
         end

         it "assigns my_post to @post" do
           get :show, params: { topic_id: my_topic.id, id: my_post.id }
           expect(assigns(:post)).to eq(my_post)
         end
       end

   # we define tests for the other crud actions. guests won't be able to access the create, new, edit, update, or destroy actions.
       describe "GET new" do
         it "returns http redirect" do
           get :new, params: { topic_id: my_topic.id }
   # we expect guests to be redirected if they attempt to create, update, or delete a post.
           expect(response).to redirect_to(new_session_path)
         end
       end

       describe "POST create" do
         it "returns http redirect" do
           post :create, params: { topic_id: my_topic.id, post: { title: RandomData.random_sentence, body: RandomData.random_paragraph } }
           expect(response).to redirect_to(new_session_path)
         end
       end

       describe "GET edit" do
         it "returns http redirect" do
           get :edit, params: { topic_id: my_topic.id, id: my_post.id }
           expect(response).to redirect_to(new_session_path)
         end
       end

       describe "PUT update" do
         it "returns http redirect" do
           new_title = RandomData.random_sentence
           new_body = RandomData.random_paragraph

           put :update, params: { topic_id: my_topic.id, id: my_post.id, post: {title: new_title, body: new_body } }
           expect(response).to redirect_to(new_session_path)
         end
       end

       describe "DELETE destroy" do
         it "returns http redirect" do
           delete :destroy, params: { topic_id: my_topic.id, id: my_post.id }
           expect(response).to have_http_status(:redirect)
         end
       end
     end

     

     context "signed-in user" do
       before do
         create_session(my_user)
       end

  describe "GET show" do
    it "returns http success" do

      # we pass {id: my_post.id} to show as a parameter. These parameters are passed to the  params hash.
      get :show, params: { topic_id: my_topic.id, id: my_post.id }
      expect(response).to have_http_status(:success)
    end
    it "renders the #show view" do

      # we expect the response to return the show view using the  render_template matcher.
      get :show, params: { topic_id: my_topic.id, id: my_post.id }
      expect(response).to render_template :show
    end

    it "assigns my_post to @post" do
      get :show, params: { topic_id: my_topic.id, id: my_post.id }

      # we expect the post to equal my_post because we call show with the id of  my_post. We are testing that the post returned to us is the post we asked for.
      expect(assigns(:post)).to eq(my_post)
    end
  end



# When new is invoked, a new and unsaved Post object is created.
  describe "GET new" do
      it "returns http success" do
        get :new, params: { topic_id: my_topic.id }
        expect(response).to have_http_status(:success)
      end

 # we expect PostsController#new to render the posts new view. We use the  render_template method to verify that the correct template (view) is rendered.
      it "renders the #new view" do
        get :new, params: { topic_id: my_topic.id }
        expect(response).to render_template :new
      end

 # we expect the @post instance variable to be initialized by  PostsController#new. 'assigns' gives us access to the @post variable, assigning it to :post.
      it "instantiates @post" do
        get :new, params: { topic_id: my_topic.id }
        expect(assigns(:post)).not_to be_nil
      end
    end

 # When create is invoked, the newly created object is persisted to the database. we expect that after PostsController#create is called with the parameters, the count of Post instances in the database will increase by one.
    describe "POST create" do
      it "increases the number of Post by 1" do
        expect{ post :create, params: { topic_id: my_topic.id, post: { title: RandomData.random_sentence, body: RandomData.random_paragraph } } }.to change(Post,:count).by(1)
      end

 # when create is POSTed to, we expect the newly created post to be assigned to @post.
      it "assigns the new post to @post" do
        post :create, params: { topic_id: my_topic.id, post: { title: RandomData.random_sentence, body: RandomData.random_paragraph } }
        expect(assigns(:post)).to eq Post.last
      end

 #  we expect to be redirected to the newly created post.
      it "redirects to the new post" do
        post :create, params: { topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph } }

        expect(response).to redirect_to [my_topic, Post.last]
      end
    end

    describe "GET edit" do
      it "returns http success" do
        get :edit, params: { topic_id: my_topic.id, id: my_post.id }
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, params: { topic_id: my_topic.id, id: my_post.id }

  # we expect the edit view to render when a post is edited
        expect(response).to render_template :edit
      end

  # we test that edit assigns the correct post to be updated to @post

      it "assigns post to be updated to @post" do
        get :edit, params: { topic_id: my_topic.id, id: my_post.id }

        post_instance = assigns(:post)

        expect(post_instance.id).to eq my_post.id
        expect(post_instance.title).to eq my_post.title
        expect(post_instance.body).to eq my_post.body
      end
    end

    describe "PUT update" do
      it "updates post with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, params: { topic_id: my_topic.id, id: my_post.id, post: {title: new_title, body: new_body } }

        # we test that @post was updated with the title and body passed to update. We also test that @post's id was not changed.
        updated_post = assigns(:post)
        expect(updated_post.id).to eq my_post.id
        expect(updated_post.title).to eq new_title
        expect(updated_post.body).to eq new_body
      end

      it "redirects to the updated post" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        # we expect to be redirected to the post's show view after the update.
        put :update, params: { topic_id: my_topic.id, id: my_post.id, post: {title: new_title, body: new_body } }
        expect(response).to redirect_to [my_topic, my_post]
      end
    end

    describe "DELETE destroy" do
      it "deletes the post" do
        delete :destroy, params: { topic_id: my_topic.id, id: my_post.id }
        # we search the database for a post with an id equal to my_post.id. this is returned as an array. we assign the size of the array to 'count,' and we expect count to equal zero.
        count = Post.where({id: my_post.id}).size
        expect(count).to eq 0
      end

      it "redirects to topic show" do
        delete :destroy, params: { topic_id: my_topic.id, id: my_post.id }
        # we expect to be redirected to the posts index view after a post has been deleted.
        expect(response).to redirect_to my_topic
      end
    end
  end
end
