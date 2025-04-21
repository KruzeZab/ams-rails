import type { LoginResponse } from '@/interface/auth';
import type { ApiResponse } from '@/interface/response';

import server from '@/server';
import config from '@/config';

import type { Song } from '@/interface/song';
import type { UserResponse } from '@/interface/user';

import { buildUrl, interpolate } from '@/utils/string';

/**
 * Login a user
 *
 */
export async function login(body = {}) {
  const loginUrl = buildUrl(config.endpoints.login);

  const { data } = await server.post<ApiResponse<LoginResponse>>(
    loginUrl,
    body,
  );

  return data;
}

/**
 * Signup a user
 *
 */
export async function signup(body = {}) {
  const signupUrl = buildUrl(config.endpoints.signup);

  const { data } = await server.post<ApiResponse<UserResponse>>(
    signupUrl,
    body,
  );

  return data;
}

/**
 *
 */
export async function fetchUsers(params = {}) {
  const usersUrl = buildUrl(config.endpoints.users);

  const response = await server.get(usersUrl, { params });

  return response;
}

/**
 * Fetch a single user
 *
 */
export async function fetchUserDetail(id: number) {
  const userUrl = buildUrl(interpolate(config.endpoints.userDetail, { id }));

  const { data } = await server.get(userUrl);

  return data;
}

/**
 * Update user
 *
 */
export async function updateUser(id: number, body = {}) {
  const userUpdateUrl = buildUrl(
    interpolate(config.endpoints.userDetail, { id }),
  );

  const { data } = await server.patch(userUpdateUrl, body);

  return data;
}

/**
 * Delete User
 *
 */
export async function deleteUser(id: number) {
  const userDeleteUrl = buildUrl(
    interpolate(config.endpoints.userDetail, { id }),
  );

  const { data } = await server.delete(userDeleteUrl);

  return data;
}

/**
 * Add manager
 *
 */
export async function createUser(body = {}) {
  const userCreateUrl = buildUrl(config.endpoints.createUser);

  const { data } = await server.post<ApiResponse<UserResponse>>(
    userCreateUrl,
    body,
  );

  return data;
}

/**
 * Fetch single artist
 */
export async function fetchArtistDetail(artistId: number) {
  const userUrl = buildUrl(interpolate(config.endpoints.artist, { artistId }));

  const { data } = await server.get(userUrl);

  return data;
}

/**
 * Fetch Artists
 *
 */
export async function fetchArtists(params = {}) {
  const userCreateUrl = buildUrl(config.endpoints.artists);

  const response = await server.get(userCreateUrl, {
    params,
  });

  return response;
}

/**
 * Bulk upload artist
 *
 */
export async function uploadArtist(body = {}) {
  const uploadUrl = buildUrl(config.endpoints.artistUpload);

  const { data } = await server.post(uploadUrl, body, {
    headers: {
      'Content-Type': 'multipart/form-data',
    },
  });

  return data;
}

/**
 * Fetch songs
 *
 */
export async function fetchSongs(params = {}) {
  const songsUrl = buildUrl(config.endpoints.songs);

  const response = await server.get(songsUrl, { params });

  return response;
}

/**
 * Fetch a single user
 *
 */
export async function fetchSongDetail(songId: number) {
  const songUrl = buildUrl(
    interpolate(config.endpoints.songDetail, { songId }),
  );

  const { data } = await server.get(songUrl);

  return data;
}

/**
 * Add a song
 *
 */
export async function addSong(body = {}) {
  const songCreateUrl = buildUrl(config.endpoints.songs);

  const { data } = await server.post<ApiResponse<Song>>(songCreateUrl, body);

  return data;
}

/**
 * Update a song
 *
 */
export async function updateSong(songId: number, body = {}) {
  const songUpdateUrl = buildUrl(
    interpolate(config.endpoints.songDetail, { songId }),
  );

  const { data } = await server.patch(songUpdateUrl, body);

  return data;
}

/**
 * Delete song
 *
 */
export async function deleteSong(songId: number) {
  const deleteSongUrl = buildUrl(
    interpolate(config.endpoints.songDetail, { songId }),
  );

  const { data } = await server.delete(deleteSongUrl);

  return data;
}

/**
 * Bulk upload artist
 *
 */
export async function downloadArtist(params = {}) {
  const downloadUrl = buildUrl(config.endpoints.artistDownload);

  const { data } = await server.get(downloadUrl, {
    params,
    responseType: 'blob',
  });

  return data;
}

/**
 * Check if email exists
 *
 */
export async function checkEmailExists(params = {}) {
  const emailCheckUrl = buildUrl(config.endpoints.checkEmail);

  const { data } = await server.get(emailCheckUrl, { params });

  return data;
}
