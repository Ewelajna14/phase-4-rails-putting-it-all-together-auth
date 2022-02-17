class RecipesController < ApplicationController

    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

    before_action :authorize

    def index
        recipes = Recipe.all
        render json: recipes, include: [:user]
    end

    def create
            user = User.find_by(id: session[:user_id])
            if user 
            recipe = user.recipes.create!(recipe_params)
            render json: recipe, status: :created
            end
    end

    private
    def authorize
        return render json: {errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id
    end

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end

    def render_unprocessable_entity(invalid)
        render json: {errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

end
