class ParksController < ApplicationController

    get "/parks" do 
        if logged_in?
            @user = User.find_by_id(current_user.id)
            @parks = Park.all 
            erb :"/parks/index"
        else 
            redirect to "/login"
        end
    end

    get "/parks/new" do 
        if logged_in?
            erb :"/parks/new"
        else 
            redirect to "login"
        end
    end

    post "/parks" do 
        if params[:name].empty?
            flash[:message] = "Must enter a name for your park"
            redirect to "/parks/new"
        else
            @park = Park.create(params)
            @park.user = current_user 
            @park.save 
            redirect to "/parks/#{@park.id}"
        end
    end

    get "/parks/:id" do 
        if !logged_in?
            flash[:message] = "Must be logged in to access park information"
            redirect to "/"
        else
            @park = Park.find(params[:id])
            erb :"/parks/show"
        end
    end

    get '/parks/:id/edit' do
    if logged_in?
      @park = Park.find_by_id(params[:id])
      if @park && @park.user == current_user
        erb :'parks/edit'
      else
        flash[:message] = "Cannot edit other users parks"
        redirect to '/parks'
      end
    else
        flash[:message] = "Must be logged in to edit park"
        redirect to '/login'
    end
  end


    patch "/parks/:id" do 
        @park = Park.find(params[:id])
        if params[:name].empty?
            flash[:message] = "Park must have a name before submitting"
            redirect to "/parks/#{@park.id}/edit"
        else 
            @park.update(name: params[:name], location: params[:location], theme: params[:theme], rides: params[:rides])
            @park.save 
            redirect to "/parks/#{@park.id}"
        end
    end

    delete "/parks/:id" do 
        @park = Park.find(params[:id])
        if @park.user == current_user
            @park.delete 
            flash[:message] = "Successfully deleted park"
            redirect to "/parks"
        else 
            flash[:message] = "Can't delete parks from other users"
            redirect to "/parks/#{@park.id}"
        end
    end

end

