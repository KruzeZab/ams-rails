class ArtistPolicy < ApplicationPolicy
  def index?
    user.super_admin? || user.artist_manager?
  end

  def show?
    user.super_admin? || user.artist_manager? || user.id == record.user_id
  end

  def create?
    user.super_admin? || user.artist_manager?
  end

  def update?
    user.super_admin? || user.artist_manager? || user.id == record.user_id
  end

  def upload?
    user.super_admin? || user.artist_manager?
  end

  def download?
    user.super_admin? || user.artist_manager?
  end
end
