export enum Genre {
  CLASSIC = 'classic',
  ROCK = 'rock',
  JAZZ = 'jazz',
  RNB = 'rnb',
  COUNTRY = 'country',
}

export interface Song {
  id: number;
  title: string;
  albumName: string;
  genre: Genre;
  artistId: number;
}

export interface SongFormValues {
  genre: Genre | null;
  albumName: string;
  title: string;
}
