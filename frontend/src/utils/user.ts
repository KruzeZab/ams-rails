import { Role } from '@/interface/user';

/**
 * Check if user is super_admin
 *
 */
export function isSuperAdmin(role?: Role) {
  return role === Role.SUPER_ADMIN;
}

/**
 * Check if user is artist_manager
 *
 */
export function isArtistManager(role?: Role) {
  return role === Role.ARTIST_MANAGER;
}

/**
 * Check if user is artist
 *
 */
export function isArtist(role?: Role) {
  return role === Role.ARTIST;
}

export function getLoggedUsername() {}
