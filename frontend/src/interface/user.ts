export enum Role {
  SUPER_ADMIN = 'super_admin',
  ARTIST_MANAGER = 'artist_manager',
  ARTIST = 'artist',
}

export enum Gender {
  MALE = 'm',
  FEMALE = 'f',
  OTHERS = 'o',
}

export interface SignupValues {
  firstName: string;
  lastName: string;
  email: string;
  password: string;
  gender: Gender;
  phone: string;
  dob: string;
  address: string;
  role?: Role | null;
}

export interface LoginValues {
  email: string;
  password: string;
}

export interface ArtistValues extends SignupValues {
  numberOfAlbumsReleased: number | null;
  firstReleaseYear: number | null;
}

export interface ArtistSummary {
  id: number;
  numberOfAlbumsReleased: number;
  firstReleaseYear: number;
}

export interface UserResponse {
  id: number;
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
  gender: Gender;
  dob: string;
  address: string;
  role: Role;
  artist?: ArtistSummary;
}

export interface EditUserValues {
  firstName: string;
  lastName: string;
  email: string;
  gender: Gender;
  phone: string;
  dob: string;
  address: string;
  role?: Role;
  numberOfAlbumsReleased?: number | null;
  firstReleaseYear?: number | null;
}

export interface ArtistResponse {
  id: number;
  numberOfAlbumsReleased: number;
  firstReleaseYear: number;
  user: UserResponse;
}

export interface ArtistZodInput {
  role: Role;
  numberOfAlbumsReleased?: number;
  firstReleaseYear?: number;
}
