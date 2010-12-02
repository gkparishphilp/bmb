class ReviewsController < ApplicationController
    before_filter   :get_reviewable

    def edit
        @review = @reviewable.reviews.find  params[:id]
		validate_owner
    end

    def create
        @review = Review.new params[:review]
        @review.user = @current_user
        
        if @reviewable.reviews << @review
            pop_flash 'Review was successfully created.'

            redirect_to polymorphic_path [ @author, @reviewable ] 
        else
            pop_flash 'Oooops, Review not saved...', :error, @review
            redirect_to polymorphic_path [ @author, @reviewable ]
        end
    end

    def update
        @review = Review.find  params[:id] 
		validate_owner
		
		@review.content += "\n\n Update: " + Time.now.strftime("%b %d, %Y @ %l:%M%p") + "<br>" + params[:new_content]
		
        if @review.save
            pop_flash 'Review was successfully updated.'
            redirect_to polymorphic_path [ @author, @reviewable ]
        else
            pop_flash 'Oooops, Review not updated...', :error, @review
            redirect_to polymorphic_path [ @author, @reviewable ]
        end
    end

    def destroy
        @review = Review.find  params[:id]
        @review.destroy
        
        pop_flash 'Review was successfully deleted.'
        redirect_to polymorphic_path [ @author, @reviewable ]
    end

private 
    def get_reviewable
		# so far, only books and merch
        @reviewable = params[:book_id].present? ? Book.find( params[:book_id ] ) : Merch.find( params[:merch_id] )
    end 

	def validate_owner
		unless @review.user == @current_user
			pop_flash "Not your Review", 'error'
			redirect_to root_path
			return false
		end
	end
        
end
