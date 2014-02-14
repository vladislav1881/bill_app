class MatchesController < ApplicationController
  before_action :signed_in_user, only: :destroy
  
  def index
    @matches = Match.paginate(page: params[:page]).order("created_at DESC")
  end

  def new
  	@match = Match.new
  end

  def show
  end

  def edit
    @match = Match.find(params[:id])
  end

  def create
  	@match = Match.new(match_params)
    @match.initiator = current_user
    if @match.save
      flash[:success] = "Match created"
  	  redirect_to matches_path
    else
      logger.fatal @match.errors.inspect
      flash.now[:error] = "Match not created: please fill in wins and loses of finished match"
      render 'new'
    end
  end

  def update
    @match = Match.find(params[:id])
    if @match.update_attributes(match_params)

      flash[:success] = "Match updated"
      redirect_to matches_path
    else
      render 'edit'      
    end
  end

  def destroy
    Match.find(params[:id]).destroy
    flash[:success] = "Match deleted"
    redirect_to matches_path
  end

end

private

  def match_params
    params.require(:match).permit(:initiator_id, :invited_id, :status,
                                   :wins, :loses)
  end
