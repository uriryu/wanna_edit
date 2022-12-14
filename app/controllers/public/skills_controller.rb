class Public::SkillsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :ensure_skill, only: [:show, :edit, :update]
  before_action :ensure_user, only: [:edit, :update, :destroy]

  def new
    @skill = Skill.new
  end

  def create
    @skill = Skill.new(skill_params)
    @skill.user_id = current_user.id
    @skill.save ? (redirect_to skill_path(@skill)): (render :new)
  end

  def index
    if params[:genre_id]
      @genre = Genre.find(params[:genre_id])
      all_skills = @genre.skills
    else
      all_skills = Skill.includes(:genres)
    end
    @skills = all_skills.page(params[:page])
    @all_skills_count = all_skills.where(is_active: true).count
  end

  def show
    @cart_item = CartItem.new
  end

  def edit
  end

  def update
    @skill.update(skill_params) ? (redirect_to skill_path(@skill)) : (render :edit)
  end
  private

  def skill_params
    params.require(:skill).permit(:genre_id, :name, :body, :image, :price, :is_active, genre_ids: [])
  end

  def ensure_skill
    @skill = Skill.find(params[:id])
  end

  def ensure_user
    @skill = Skill.find(params[:id])
    if @skill.user.id != current_user.id
      flash[:alert] = "権限がありません"
      redirect_to skills_path
    end
  end
end
