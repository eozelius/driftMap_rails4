class WaypointsController < ApplicationController
	before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy ]

	def new
		@waypoint = Waypoint.new
	end

	def create
		@waypoint = Waypoint.new(waypoint_params)
		@driftmap = current_user.driftmap
		@waypoint.journey_id = params[:journey_id]

		date = Date.new(params[:waypoint][:date].slice(0, 4).to_i,
										params[:waypoint][:date].slice(4, 2).to_i,
										params[:waypoint][:date].slice(6, 2).to_i);

		@waypoint.date = date

		if @waypoint.save
			if params[:photo].present?
				params[:photo].each do |image|
					@waypoint.waypoint_images.build(image: image[1])
				end
				@waypoint.save
			end
			@waypoint.save
			flash[:success] = "waypoint created successfully"
			redirect_to current_user
		else
			flash[:danger] = 'whoops, something went wrong'
			render 'new'
		end
	end

	def update
		@blip = Blip.find(params[:id])

		if @blip.update_attributes(blip_params)
			# update date
			date = Date.new(params[:blip][:date].slice(0, 4).to_i,
											params[:blip][:date].slice(4, 2).to_i,
											params[:blip][:date].slice(6, 2).to_i);

			@blip.date = date
			@blip.save

			if params[:photo].present?
				params[:photo].each do |image|
					@blip.blip_images.build(image: image[1])
				end
				@blip.save
			end
			flash[:success] = 'blip successfully updated'
			redirect_to current_user
		else
			flash[:danger] = 'whoops, something went wrong'
			render 'edit'
		end
	end

	def show
		@blip = Blip.find(params[:id])
		@user = User.find(Post.find(@blip.post_id).user_id);
	end

	def edit
		@blip = Blip.find(params[:id])
		@user = current_user
	end

	def destroy
		blip = Blip.find(params[:id])
		user = User.find(Post.find(blip.post_id).user_id) # wowzers

		blip.destroy
		user.reload
		flash[:success] = "Blip deleted"
		redirect_to user
	end

	private
		# todo, implement strong params
		def waypoint_params
			params.require(:waypoint).permit(:title, :body, :x, :y, :date)
		end
end
