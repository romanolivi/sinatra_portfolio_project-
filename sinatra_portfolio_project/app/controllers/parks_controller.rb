class ParksController < ApplicationController

    get "/parks" do 
        if logged_in?
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
            @park = Park.create(params[:park])
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

    get "/parks/:id/edit" do 
        @park = Park.find(params[:id])
        if !logged_in? 
            flash[:message] = "Must be logged in to edit park"
            redirect to "/"
        elsif logged_in? && current_user != @park.user 
            flash[:message] = "You can't edit another persons park"
            redirect to "/parks"
        elsif logged_in && current_user == @park.user 
            erb :"/parks/edit"
        end
    end

    patch "/parks/:id" do 
        @park = Park.find(params[:id])
        if params[:name].empty?
            flash[:message] = "Park must have a name before submitting"
            redirect to "/parks/#{@park.id}/edit"
        else 
            @park.update(params)
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

