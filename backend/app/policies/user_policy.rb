class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.super_admin?
        scope.all
      elsif user.artist_manager?
        scope.where(role: User::ROLES[:ARTIST])
      else
        scope.none
      end
    end
  end

  def create?
    return true if user.super_admin?
    
    user.artist_manager? && record.artist?
  end

  def index?
    user.super_admin? || user.artist_manager?
  end

  def show?
    user.super_admin? || 
      (user.artist_manager? && record.artist?) || 
      user == record
  end
  
  def update?
    user.super_admin? || user == record
  end

  def destroy?
    return false if user.id == record.id
  
    user.super_admin? || (user.artist_manager? && record.artist?)
  end
end
