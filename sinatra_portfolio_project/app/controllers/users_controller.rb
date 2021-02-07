require 'rack-flash'  

class UsersController < ApplicationController
    use Rack::Flash

    get "/signup" do 
      if !logged_in? 
        erb :"/users/signup"
      else 
        erb :"/users/show"
      end
    end
    
    post "/signup" do
        binding.pry
        if params[:username].empty? || params[:password].empty?
            flash[:message]= "You Must Type in Username, Password, and Email to Sign Up."
            redirect "/signup"
        else 
            @user = User.create(username: params[:username], password: params[:password])
            session[:user_id] = @user.id 
            redirect "/parks"
        end
    end
      
    get "/login" do 
        if logged_in? 
            erb :"/user/show"
        else 
            erb :"/users/login"
        end 
    end
      
    post "/login" do 
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
            session[:user_id] = user.id 
            redirect "/parks"
        else 
            flash[:message] = "Username or Password were Incorrect. Try again"
            redirect '/login'
        end
    end
      
    get "/logout" do 
        if logged_in?
            session.destroy
            flash[:message] = "Successfully logged out"
            redirect to "/login"
        else 
            redirect "/"
        end
    end
    
    get "/users/:slug" do
        @user = User.find_by_slug(params[:slug])
        erb :"/users/show"
    end
end

      