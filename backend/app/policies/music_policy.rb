class MusicPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    return true if user.super_admin?
    
    user.artist? && record.artist.user_id == user.id
  end

  def update?
    user.super_admin? || record.artist.user_id == user.id
  end

  def destroy?
    user.super_admin? || record.artist.user_id == user.id
  end
end
