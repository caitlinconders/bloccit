module SessionsHelper

  #we define create_session, which sets user_id on the session object to user.id, which is unique for each user. session is an object Rails provides to track the state of a particular user. There is a one-to-one relationship between session object can only have one user id and a user id is related to one session object.
  def create_session(user)
    session[:user_id] = user.id
  end

  # we define destroy_session. we clear the user id on the session object by setting it to nil, which effectively destorys the user session because we can't track it via their user id any longer.
  def destroy_session(user)
    session[:user_id] = nil
  end

  # we define current_user, which returns the current user of the application.  current_user encapsulates the pattern of finding the current user that we would otherwise call throughout Bloccit. Thus we won't have to constantly call  User.find_by(id: session[:user_id]); current_user is our shortcut to that functionality. current_user finds the signed-in user by taking the user id from the session and searching the database for the user in question. When the user closes Bloccit, the related session object will be destroyed. Because our session only stores the user id, we need to retrieve the  User instance, and all of its properties, by searching the database for the record with the corresponding user id.
  def current_user
    User.find_by(id: session[:user_id])
  end
end
