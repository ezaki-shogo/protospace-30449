class PrototypesController < ApplicationController
  before_action :authenticate_user!, except:[:index, :show]
  before_action :move_to_index, only:[:edit, :destroy, :update] 
  def index
    @prototypes = Prototype.all
  end

  def new
    #newアクションが呼び出された時にPrototype.newで新規投稿ページの内容を保存する箱を生成している。
    @prototype = Prototype.new
  end

  def create
    #createアクションでもう一度Prototype.newを定義して、引数にprototype_paramsを持ってくることによってストロングパラメーターで保存するカラムを制限している。
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path 
    else
      render 'prototypes/new'
    end
  end
  
  def show
    #正解したがなぜこの記述になるのか完全に理解していない！！
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype.id)
    else
      render 'prototypes/edit'
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    if @prototype.destroy
      redirect_to root_path
    end
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end
  
  def move_to_index
    @prototype = Prototype.find(params[:id])
    unless user_signed_in? && current_user.id == @prototype.user_id
      redirect_to action: :index
    end
  end

end
