class UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def index
    @user = current_user
    @users = User.all
    @book = Book.new
  end

  def show
    @user = User.find(params[:id])
    @book = Book.new
    @books = @user.books
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
     unless @user.id == current_user.id
       @currentUserEntry.each do |cu|
         @userEntry.each do |u|
           if cu.room_id == u.room_id
             @isRoom = true
             @roomId = cu.room_id
           end
         end
       end
       if @isRoom
       else
         @room = Room.new
         @entry = Entry.new
       end
     end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "You have updated user successfully."
    redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  private

  def user_params
  params.require(:user).permit(:name,:introduction, :profile_image,)
  end

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to user_path(current_user)
    end
  end

end
